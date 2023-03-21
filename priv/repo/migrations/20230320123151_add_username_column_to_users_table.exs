defmodule Pento.Repo.Migrations.AddUsernameColumnToUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add_if_not_exists :username, :string, null: false, default: "no_username"
      unique_index("users", [:username])
    end
  end
end
