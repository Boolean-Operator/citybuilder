defmodule LiveStory.Repo.Migrations.AddPlanToPosts do
  use Ecto.Migration

  def change do
     alter table(:stories_posts) do
     add :plan, :string
     add :done_so_far_one, :string
     add :done_so_far_two, :string
     add :done_so_far_three, :string
     add :done_so_far_one_title, :string
     add :done_so_far_two_title, :string
     add :done_so_far_three_title, :string
     add :project_pic, :string
     #timestamps
  end
end
end