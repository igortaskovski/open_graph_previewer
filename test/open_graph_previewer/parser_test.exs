defmodule OpenGraphPreviewer.ParserTest do
  use ExUnit.Case
  alias OpenGraphPreviewer.Parser

  test "builds properties successfully" do
    document = """
      <html>
        <head>
          <meta property="og:description" content="Description 1" />
          <meta property="og:title" content="Title 1" />
          <meta property="og:image" content="Image URL 1" />
          <meta property="og:url" content="URL 1" />
        </head>
        <body></body>
      </html>
    """

    expected = %{
      og_description: "Description 1",
      og_title: "Title 1",
      og_image_url: "Image URL 1",
      og_url: "URL 1",
      status: "Processed"
    }

    assert {:ok, result} = Parser.build_properties(document)
    assert result == expected
  end

  test "handles parsing errors in build_properties" do
    document = "<html></html>"

    assert {:error, _} = Parser.build_properties(document)
  end
end
