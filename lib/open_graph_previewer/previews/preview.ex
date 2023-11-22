defmodule OpenGraphPreviewer.Previews.Preview do
  use Ecto.Schema
  import Ecto.Changeset

  schema "previews" do
    field :status, :string
    field :og_title, :string
    field :og_url, :string
    field :og_description, :string
    field :og_image_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(preview, attrs) do
    preview
    |> cast(attrs, [:og_title, :og_url, :og_description, :og_image_url, :status])
    |> validate_required([:og_title, :og_url, :og_description, :og_image_url, :status])
  end
end
