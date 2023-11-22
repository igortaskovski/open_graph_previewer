defmodule OpenGraphPreviewerWeb.PreviewLive.Index do
  use OpenGraphPreviewerWeb, :live_view

  alias OpenGraphPreviewer.Previews
  alias OpenGraphPreviewer.Previews.Preview

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :previews, Previews.list_previews())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Preview")
    |> assign(:preview, Previews.get_preview!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Preview")
    |> assign(:preview, %Preview{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Previews")
    |> assign(:preview, nil)
  end

  @impl true
  def handle_info({OpenGraphPreviewerWeb.PreviewLive.FormComponent, {:saved, preview}}, socket) do
    {:noreply, stream_insert(socket, :previews, preview)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    preview = Previews.get_preview!(id)
    {:ok, _} = Previews.delete_preview(preview)

    {:noreply, stream_delete(socket, :previews, preview)}
  end
end
