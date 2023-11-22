defmodule OpenGraphPreviewerWeb.PreviewLiveTest do
  use OpenGraphPreviewerWeb.ConnCase

  import Phoenix.LiveViewTest
  import OpenGraphPreviewer.PreviewsFixtures

  @create_attrs %{status: "some status", og_title: "some og_title", og_url: "some og_url", og_description: "some og_description", og_image_url: "some og_image_url"}
  @update_attrs %{status: "some updated status", og_title: "some updated og_title", og_url: "some updated og_url", og_description: "some updated og_description", og_image_url: "some updated og_image_url"}
  @invalid_attrs %{status: nil, og_title: nil, og_url: nil, og_description: nil, og_image_url: nil}

  defp create_preview(_) do
    preview = preview_fixture()
    %{preview: preview}
  end

  describe "Index" do
    setup [:create_preview]

    test "lists all previews", %{conn: conn, preview: preview} do
      {:ok, _index_live, html} = live(conn, ~p"/previews")

      assert html =~ "Listing Previews"
      assert html =~ preview.status
    end

    test "saves new preview", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/previews")

      assert index_live |> element("a", "New Preview") |> render_click() =~
               "New Preview"

      assert_patch(index_live, ~p"/previews/new")

      assert index_live
             |> form("#preview-form", preview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#preview-form", preview: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/previews")

      html = render(index_live)
      assert html =~ "Preview created successfully"
      assert html =~ "some status"
    end

    test "updates preview in listing", %{conn: conn, preview: preview} do
      {:ok, index_live, _html} = live(conn, ~p"/previews")

      assert index_live |> element("#previews-#{preview.id} a", "Edit") |> render_click() =~
               "Edit Preview"

      assert_patch(index_live, ~p"/previews/#{preview}/edit")

      assert index_live
             |> form("#preview-form", preview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#preview-form", preview: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/previews")

      html = render(index_live)
      assert html =~ "Preview updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes preview in listing", %{conn: conn, preview: preview} do
      {:ok, index_live, _html} = live(conn, ~p"/previews")

      assert index_live |> element("#previews-#{preview.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#previews-#{preview.id}")
    end
  end

  describe "Show" do
    setup [:create_preview]

    test "displays preview", %{conn: conn, preview: preview} do
      {:ok, _show_live, html} = live(conn, ~p"/previews/#{preview}")

      assert html =~ "Show Preview"
      assert html =~ preview.status
    end

    test "updates preview within modal", %{conn: conn, preview: preview} do
      {:ok, show_live, _html} = live(conn, ~p"/previews/#{preview}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Preview"

      assert_patch(show_live, ~p"/previews/#{preview}/show/edit")

      assert show_live
             |> form("#preview-form", preview: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#preview-form", preview: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/previews/#{preview}")

      html = render(show_live)
      assert html =~ "Preview updated successfully"
      assert html =~ "some updated status"
    end
  end
end
