defmodule MathKidWeb.AddSubLiveTest do
  use MathKidWeb.ConnCase

  import Phoenix.LiveViewTest
  import MathKid.BasicFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_add_sub(_) do
    add_sub = add_sub_fixture()
    %{add_sub: add_sub}
  end

  describe "Index" do
    setup [:create_add_sub]

    test "lists all add_subs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.add_sub_index_path(conn, :index))

      assert html =~ "Listing Add subs"
    end

    test "saves new add_sub", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.add_sub_index_path(conn, :index))

      assert index_live |> element("a", "New Add sub") |> render_click() =~
               "New Add sub"

      assert_patch(index_live, Routes.add_sub_index_path(conn, :new))

      assert index_live
             |> form("#add_sub-form", add_sub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#add_sub-form", add_sub: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.add_sub_index_path(conn, :index))

      assert html =~ "Add sub created successfully"
    end

    test "updates add_sub in listing", %{conn: conn, add_sub: add_sub} do
      {:ok, index_live, _html} = live(conn, Routes.add_sub_index_path(conn, :index))

      assert index_live |> element("#add_sub-#{add_sub.id} a", "Edit") |> render_click() =~
               "Edit Add sub"

      assert_patch(index_live, Routes.add_sub_index_path(conn, :edit, add_sub))

      assert index_live
             |> form("#add_sub-form", add_sub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#add_sub-form", add_sub: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.add_sub_index_path(conn, :index))

      assert html =~ "Add sub updated successfully"
    end

    test "deletes add_sub in listing", %{conn: conn, add_sub: add_sub} do
      {:ok, index_live, _html} = live(conn, Routes.add_sub_index_path(conn, :index))

      assert index_live |> element("#add_sub-#{add_sub.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#add_sub-#{add_sub.id}")
    end
  end

  describe "Show" do
    setup [:create_add_sub]

    test "displays add_sub", %{conn: conn, add_sub: add_sub} do
      {:ok, _show_live, html} = live(conn, Routes.add_sub_show_path(conn, :show, add_sub))

      assert html =~ "Show Add sub"
    end

    test "updates add_sub within modal", %{conn: conn, add_sub: add_sub} do
      {:ok, show_live, _html} = live(conn, Routes.add_sub_show_path(conn, :show, add_sub))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Add sub"

      assert_patch(show_live, Routes.add_sub_show_path(conn, :edit, add_sub))

      assert show_live
             |> form("#add_sub-form", add_sub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#add_sub-form", add_sub: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.add_sub_show_path(conn, :show, add_sub))

      assert html =~ "Add sub updated successfully"
    end
  end
end
