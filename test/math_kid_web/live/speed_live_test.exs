defmodule MathKidWeb.SpeedLiveTest do
  use MathKidWeb.ConnCase

  import Phoenix.LiveViewTest
  import MathKid.BasicFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_speed(_) do
    speed = speed_fixture()
    %{speed: speed}
  end

  describe "Index" do
    setup [:create_speed]

    test "lists all speed", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.speed_index_path(conn, :index))

      assert html =~ "Listing Speed"
    end

    test "saves new speed", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.speed_index_path(conn, :index))

      assert index_live |> element("a", "New Speed") |> render_click() =~
               "New Speed"

      assert_patch(index_live, Routes.speed_index_path(conn, :new))

      assert index_live
             |> form("#speed-form", speed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#speed-form", speed: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speed_index_path(conn, :index))

      assert html =~ "Speed created successfully"
    end

    test "updates speed in listing", %{conn: conn, speed: speed} do
      {:ok, index_live, _html} = live(conn, Routes.speed_index_path(conn, :index))

      assert index_live |> element("#speed-#{speed.id} a", "Edit") |> render_click() =~
               "Edit Speed"

      assert_patch(index_live, Routes.speed_index_path(conn, :edit, speed))

      assert index_live
             |> form("#speed-form", speed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#speed-form", speed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speed_index_path(conn, :index))

      assert html =~ "Speed updated successfully"
    end

    test "deletes speed in listing", %{conn: conn, speed: speed} do
      {:ok, index_live, _html} = live(conn, Routes.speed_index_path(conn, :index))

      assert index_live |> element("#speed-#{speed.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#speed-#{speed.id}")
    end
  end

  describe "Show" do
    setup [:create_speed]

    test "displays speed", %{conn: conn, speed: speed} do
      {:ok, _show_live, html} = live(conn, Routes.speed_show_path(conn, :show, speed))

      assert html =~ "Show Speed"
    end

    test "updates speed within modal", %{conn: conn, speed: speed} do
      {:ok, show_live, _html} = live(conn, Routes.speed_show_path(conn, :show, speed))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Speed"

      assert_patch(show_live, Routes.speed_show_path(conn, :edit, speed))

      assert show_live
             |> form("#speed-form", speed: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#speed-form", speed: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.speed_show_path(conn, :show, speed))

      assert html =~ "Speed updated successfully"
    end
  end
end
