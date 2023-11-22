defmodule OpenGraphPreviewer.Repo.Migrations.CreatePreviews do
  use Ecto.Migration

  def change do
    create table(:previews) do
      add :og_title, :string
      add :og_url, :string
      add :og_description, :string
      add :og_image_url, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
