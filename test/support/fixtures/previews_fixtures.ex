defmodule OpenGraphPreviewer.PreviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OpenGraphPreviewer.Previews` context.
  """

  @doc """
  Generate a preview.
  """
  def preview_fixture(attrs \\ %{}) do
    {:ok, preview} =
      attrs
      |> Enum.into(%{
        og_description: "some og_description",
        og_image_url: "some og_image_url",
        og_title: "some og_title",
        og_url: "some og_url",
        status: "some status"
      })
      |> OpenGraphPreviewer.Previews.create_preview()

    preview
  end
end
