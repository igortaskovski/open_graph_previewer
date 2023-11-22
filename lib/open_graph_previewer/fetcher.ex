defmodule OpenGraphPreviewer.Fetcher do
  def fetch_html(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status_code: code}} ->
        {:error, "Failed to fetch URL. Status code: #{code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Failed to fetch URL. Reason: #{reason}"}
    end
  end
end
