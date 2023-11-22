defmodule OpenGraphPreviewer.Parser do
  def build_properties(document) do
    with {:ok, og_description} <- parse_open_graph_value(document, :description),
         {:ok, og_title}       <- parse_open_graph_value(document, :title),
         {:ok, og_image_url}   <- parse_open_graph_value(document, :image),
         {:ok, og_url}         <- parse_open_graph_value(document, :url) do
      {:ok, %{
        og_description: og_description |> hd,
        og_title: og_title |> hd,
        og_image_url: og_image_url |> hd,
        og_url: og_url |> hd,
        status: "Processed"
      }}
    else
      _ -> {:error, "Failed to get meta values from HTML document"}
    end
  end

  defp parse_open_graph_value(document, tag) do
    try do
      {:ok, html} = Floki.parse_document(document)
      tags =
        Floki.find(html, ~s(meta[property="og:#{tag}"]))
        |> Enum.map(&Floki.attribute(&1, "content"))

        {:ok, hd(tags)}
    rescue
      _ -> {:error, "Failed to parse HTML document"}
    end
  end
end
