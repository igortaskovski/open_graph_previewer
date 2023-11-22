defmodule OpenGraphPreviewerWeb.PreviewLive.Index do
  use OpenGraphPreviewerWeb, :live_view

  alias OpenGraphPreviewer.Parser
  alias OpenGraphPreviewer.Fetcher
  alias OpenGraphPreviewer.Previews

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, result: %{og_description: "", og_title: "", og_image_url: "", og_url: "", status: "", error: ""})}
  end

  @impl true
  def handle_event("process", %{"url" => url}, socket) do
    processed_data = process_request(url)
    {:noreply, assign(socket, result: processed_data)}
  end

  defp process_request(url) do
    with {:ok, document}   <- Fetcher.fetch_html(url),
         {:ok, properties} <- Parser.build_properties(document),
         {:ok, preview}    <- Previews.create_preview(properties) do
         Map.from_struct(preview)
    else
      {:error, message} ->
        %{error: message}
    end
  end
end
