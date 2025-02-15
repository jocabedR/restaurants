defmodule MelpWeb.RestaurantControllerTest do
  use MelpWeb.ConnCase

  import Melp.MelpServiceFixtures

  alias Melp.MelpService.Restaurant

  @create_attrs %{
    city: "some city",
    email: "some email",
    lat: 120.5,
    lng: 120.5,
    name: "some name",
    phone: "some phone",
    rating: 42,
    site: "some site",
    state: "some state",
    street: "some street"
  }
  @update_attrs %{
    city: "some updated city",
    email: "some updated email",
    lat: 456.7,
    lng: 456.7,
    name: "some updated name",
    phone: "some updated phone",
    rating: 43,
    site: "some updated site",
    state: "some updated state",
    street: "some updated street"
  }
  @invalid_attrs %{
    city: nil,
    email: nil,
    lat: nil,
    lng: nil,
    name: nil,
    phone: nil,
    rating: nil,
    site: nil,
    state: nil,
    street: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all restaurants", %{conn: conn} do
      conn = get(conn, ~p"/api/restaurants")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create restaurant" do
    test "renders restaurant when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/restaurants", restaurant: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/restaurants/#{id}")

      assert %{
               "id" => ^id,
               "city" => "some city",
               "email" => "some email",
               "lat" => 120.5,
               "lng" => 120.5,
               "name" => "some name",
               "phone" => "some phone",
               "rating" => 42,
               "site" => "some site",
               "state" => "some state",
               "street" => "some street"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/restaurants", restaurant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update restaurant" do
    setup [:create_restaurant]

    test "renders restaurant when data is valid", %{
      conn: conn,
      restaurant: %Restaurant{id: id} = restaurant
    } do
      conn = put(conn, ~p"/api/restaurants/#{restaurant}", restaurant: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/restaurants/#{id}")

      assert %{
               "id" => ^id,
               "city" => "some updated city",
               "email" => "some updated email",
               "lat" => 456.7,
               "lng" => 456.7,
               "name" => "some updated name",
               "phone" => "some updated phone",
               "rating" => 43,
               "site" => "some updated site",
               "state" => "some updated state",
               "street" => "some updated street"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, restaurant: restaurant} do
      conn = put(conn, ~p"/api/restaurants/#{restaurant}", restaurant: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete restaurant" do
    setup [:create_restaurant]

    test "deletes chosen restaurant", %{conn: conn, restaurant: restaurant} do
      conn = delete(conn, ~p"/api/restaurants/#{restaurant}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/restaurants/#{restaurant}")
      end
    end
  end

  defp create_restaurant(_) do
    restaurant = restaurant_fixture()
    %{restaurant: restaurant}
  end
end
