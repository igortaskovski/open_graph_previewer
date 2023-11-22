defmodule OpenGraphPreviewer.FetcherTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
    :ok
  end

  test "fetches HTML successfully" do
    use_cassette "httpoison_get" do
      {:ok, result} = OpenGraphPreviewer.Fetcher.fetch_html("http://example.com")
      assert String.contains?(result, "Example Domain")
    end
  end
end
