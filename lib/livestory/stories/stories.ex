defmodule LiveStory.Stories do
  @moduledoc """
  The boundary for the Stories system.
  """
  import Ecto.{Query, Changeset}, warn: false
  alias LiveStory.Repo
  alias Ecto.Multi

  alias LiveStory.Stories.Post
  alias LiveStory.Stories.ForkedPost

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> post_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> post_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    post_changeset(post, %{})
  end


  def create_forked_post(%Post{title: title, body: body, id: id} = original_post) do
    {:ok, new_post} = create_post(%{title: title, body: body})
    forked_post_params = %{
      original_post_id: id,
      forked_post_id: new_post.id
    }

    %ForkedPost{}
    |> fork_post_changeset(forked_post_params)
    |> Repo.insert() 
    |> case do
      {:ok, forked_post} -> new_post
      {:error, error} -> error
    end
  end

  defp post_changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body]) #Need to change this to Para1, Para2 at some point.
    |> validate_required([:title, :body]) #Need to change this to Para1, Para2 at some point.
  end

  defp fork_post_changeset(%ForkedPost{} = forked_posts, attrs) do
    IO.inspect attrs
    forked_posts
    |> cast(attrs, [:original_post_id, :forked_post_id])
    |> validate_required([:original_post_id, :forked_post_id])
  end
end