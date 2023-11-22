defmodule OpenGraphPreviewer.PreviewsTest do
  use OpenGraphPreviewer.DataCase

  alias OpenGraphPreviewer.Previews

  describe "previews" do
    alias OpenGraphPreviewer.Previews.Preview

    import OpenGraphPreviewer.PreviewsFixtures

    @invalid_attrs %{status: nil, og_title: nil, og_url: nil, og_description: nil, og_image_url: nil}

    test "list_previews/0 returns all previews" do
      preview = preview_fixture()
      assert Previews.list_previews() == [preview]
    end

    test "get_preview!/1 returns the preview with given id" do
      preview = preview_fixture()
      assert Previews.get_preview!(preview.id) == preview
    end

    test "create_preview/1 with valid data creates a preview" do
      valid_attrs = %{status: "some status", og_title: "some og_title", og_url: "some og_url", og_description: "some og_description", og_image_url: "some og_image_url"}

      assert {:ok, %Preview{} = preview} = Previews.create_preview(valid_attrs)
      assert preview.status == "some status"
      assert preview.og_title == "some og_title"
      assert preview.og_url == "some og_url"
      assert preview.og_description == "some og_description"
      assert preview.og_image_url == "some og_image_url"
    end

    test "create_preview/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Previews.create_preview(@invalid_attrs)
    end

    test "update_preview/2 with valid data updates the preview" do
      preview = preview_fixture()
      update_attrs = %{status: "some updated status", og_title: "some updated og_title", og_url: "some updated og_url", og_description: "some updated og_description", og_image_url: "some updated og_image_url"}

      assert {:ok, %Preview{} = preview} = Previews.update_preview(preview, update_attrs)
      assert preview.status == "some updated status"
      assert preview.og_title == "some updated og_title"
      assert preview.og_url == "some updated og_url"
      assert preview.og_description == "some updated og_description"
      assert preview.og_image_url == "some updated og_image_url"
    end

    test "update_preview/2 with invalid data returns error changeset" do
      preview = preview_fixture()
      assert {:error, %Ecto.Changeset{}} = Previews.update_preview(preview, @invalid_attrs)
      assert preview == Previews.get_preview!(preview.id)
    end

    test "delete_preview/1 deletes the preview" do
      preview = preview_fixture()
      assert {:ok, %Preview{}} = Previews.delete_preview(preview)
      assert_raise Ecto.NoResultsError, fn -> Previews.get_preview!(preview.id) end
    end

    test "change_preview/1 returns a preview changeset" do
      preview = preview_fixture()
      assert %Ecto.Changeset{} = Previews.change_preview(preview)
    end
  end
end
