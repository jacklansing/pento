defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> unique_constraint(:sku)
  end

  @doc false
  def decrease_unit_price_changeset(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_change(:unit_price, fn :unit_price, new_price ->
      if new_price > product.unit_price do
        [unit_price: "new price cannot be higher than current price"]
      else
        []
      end
    end)
  end
end
