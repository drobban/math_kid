defmodule MathKidWeb.MultipleLiveTest do
  use MathKidWeb.ConnCase

  import Phoenix.LiveViewTest
  import MathKid.MathFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_multiple(_) do
    multiple = multiple_fixture()
    %{multiple: multiple}
  end

  describe "Index" do
    setup [:create_multiple]

    test "lists all multiples", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.multiple_index_path(conn, :index))

      assert html =~ "Listing Multiples"
    end

    test "saves new multiple", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.multiple_index_path(conn, :index))

      assert index_live |> element("a", "New Multiple") |> render_click() =~
               "New Multiple"

      assert_patch(index_live, Routes.multiple_index_path(conn, :new))

      assert index_live
             |> form("#multiple-form", multiple: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#multiple-form", multiple: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.multiple_index_path(conn, :index))

      assert html =~ "Multiple created successfully"
    end

    test "updates multiple in listing", %{conn: conn, multiple: multiple} do
      {:ok, index_live, _html} = live(conn, Routes.multiple_index_path(conn, :index))

      assert index_live |> element("#multiple-#{multiple.id} a", "Edit") |> render_click() =~
               "Edit Multiple"

      assert_patch(index_live, Routes.multiple_index_path(conn, :edit, multiple))

      assert index_live
             |> form("#multiple-form", multiple: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#multiple-form", multiple: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.multiple_index_path(conn, :index))

      assert html =~ "Multiple updated successfully"
    end

    test "deletes multiple in listing", %{conn: conn, multiple: multiple} do
      {:ok, index_live, _html} = live(conn, Routes.multiple_index_path(conn, :index))

      assert index_live |> element("#multiple-#{multiple.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#multiple-#{multiple.id}")
    end
  end

  describe "Show" do
    setup [:create_multiple]

    test "displays multiple", %{conn: conn, multiple: multiple} do
      {:ok, _show_live, html} = live(conn, Routes.multiple_show_path(conn, :show, multiple))

      assert html =~ "Show Multiple"
    end

    test "updates multiple within modal", %{conn: conn, multiple: multiple} do
      {:ok, show_live, _html} = live(conn, Routes.multiple_show_path(conn, :show, multiple))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Multiple"

      assert_patch(show_live, Routes.multiple_show_path(conn, :edit, multiple))

      assert show_live
             |> form("#multiple-form", multiple: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#multiple-form", multiple: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.multiple_show_path(conn, :show, multiple))

      assert html =~ "Multiple updated successfully"
    end
  end
end
