defmodule MathKidWeb.SingleLiveTest do
  use MathKidWeb.ConnCase

  import Phoenix.LiveViewTest
  import MathKid.WordsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_single(_) do
    single = single_fixture()
    %{single: single}
  end

  describe "Index" do
    setup [:create_single]

    test "lists all singles", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.single_index_path(conn, :index))

      assert html =~ "Listing Singles"
    end

    test "saves new single", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.single_index_path(conn, :index))

      assert index_live |> element("a", "New Single") |> render_click() =~
               "New Single"

      assert_patch(index_live, Routes.single_index_path(conn, :new))

      assert index_live
             |> form("#single-form", single: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#single-form", single: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.single_index_path(conn, :index))

      assert html =~ "Single created successfully"
    end

    test "updates single in listing", %{conn: conn, single: single} do
      {:ok, index_live, _html} = live(conn, Routes.single_index_path(conn, :index))

      assert index_live |> element("#single-#{single.id} a", "Edit") |> render_click() =~
               "Edit Single"

      assert_patch(index_live, Routes.single_index_path(conn, :edit, single))

      assert index_live
             |> form("#single-form", single: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#single-form", single: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.single_index_path(conn, :index))

      assert html =~ "Single updated successfully"
    end

    test "deletes single in listing", %{conn: conn, single: single} do
      {:ok, index_live, _html} = live(conn, Routes.single_index_path(conn, :index))

      assert index_live |> element("#single-#{single.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#single-#{single.id}")
    end
  end

  describe "Show" do
    setup [:create_single]

    test "displays single", %{conn: conn, single: single} do
      {:ok, _show_live, html} = live(conn, Routes.single_show_path(conn, :show, single))

      assert html =~ "Show Single"
    end

    test "updates single within modal", %{conn: conn, single: single} do
      {:ok, show_live, _html} = live(conn, Routes.single_show_path(conn, :show, single))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Single"

      assert_patch(show_live, Routes.single_show_path(conn, :edit, single))

      assert show_live
             |> form("#single-form", single: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#single-form", single: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.single_show_path(conn, :show, single))

      assert html =~ "Single updated successfully"
    end
  end
end
