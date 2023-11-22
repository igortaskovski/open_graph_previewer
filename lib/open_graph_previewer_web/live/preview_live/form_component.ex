defmodule OpenGraphPreviewerWeb.PreviewLive.FormComponent do
  use OpenGraphPreviewerWeb, :live_component

  alias OpenGraphPreviewer.Previews

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage preview records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="preview-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:og_title]} type="text" label="Og title" />
        <.input field={@form[:og_url]} type="text" label="Og url" />
        <.input field={@form[:og_description]} type="text" label="Og description" />
        <.input field={@form[:og_image_url]} type="text" label="Og image url" />
        <.input field={@form[:status]} type="text" label="Status" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Preview</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{preview: preview} = assigns, socket) do
    changeset = Previews.change_preview(preview)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"preview" => preview_params}, socket) do
    changeset =
      socket.assigns.preview
      |> Previews.change_preview(preview_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"preview" => preview_params}, socket) do
    save_preview(socket, socket.assigns.action, preview_params)
  end

  defp save_preview(socket, :edit, preview_params) do
    case Previews.update_preview(socket.assigns.preview, preview_params) do
      {:ok, preview} ->
        notify_parent({:saved, preview})

        {:noreply,
         socket
         |> put_flash(:info, "Preview updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_preview(socket, :new, preview_params) do
    case Previews.create_preview(preview_params) do
      {:ok, preview} ->
        notify_parent({:saved, preview})

        {:noreply,
         socket
         |> put_flash(:info, "Preview created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
