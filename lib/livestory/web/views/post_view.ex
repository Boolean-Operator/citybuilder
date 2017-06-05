defmodule LiveStory.Web.PostView do
  use LiveStory.Web, :view

  alias LiveStory.Stories.Comment

  @spec upvoted_class(button_state :: binary, upvote_state :: boolean) :: binary
  def upvoted_class("upvoted", true), do: ""
  def upvoted_class("upvoted", nil), do: "hidden "
  def upvoted_class("not_upvoted", true), do: "hidden "
  def upvoted_class("not_upvoted", nil), do: ""

  def root_path(path) do
    LiveStory.Stories.root_path(path)
  end

  # Avoid fail on less than 3 posts by doing different matches
  # Text duplication here is unavoidable.
  def welcome(true, conn, [post1, post2, post3, post4 | _tail]) do
    "Latest top stories are #{link_post conn, post1}, #{link_post conn, post2} and #{link_post conn, post2}. Help edit them. Click 𝜓 to fork the post. Fork means you get your own copy. "
  end
  def welcome(true, conn, [post1, post2]) do
    "Latest top stories are #{link_post conn, post1} and #{link_post conn, post2}. Help edit them. Click 𝜓 to fork any post. Fork means you get your own copy"
  end
  def welcome(true, conn, [post1]) do
    "The latest top story is #{link_post conn, post1}. Help edit it. Click 𝜓 button to form any post. Fork means you get your own copy."
  end
  def welcome(_, conn, _posts) do
    ""
  end

  defp link_post(conn, post) do
    {:safe, link} = link post.title, to: post_path(conn, :show, post)
    link
  end

  def topic_select(topics) do
    Enum.map(topics, &{&1.name, &1.id})
  end

  def comment_upvote_class(%Comment{upvotes_count: %{count: count}}) when count >= 10 do
    "upvotes-above-ten"
  end
  def comment_upvote_class(%Comment{upvotes_count: %{count: count}}) when count >= 5 do
    "upvotes-above-five"
  end
  def comment_upvote_class(%Comment{}), do: ""

  def split_topic_name(name) do
    content_tag :div, class: "font-select-div mobile-hide" do
      do_split(name, "select-fonts")
    end
  end

  def split_logout(text) do
    do_split(text, "logout-multi")
  end

  defp do_split(string, class_prefix) do
    string
    |> String.trim
    |> String.graphemes
    |> Enum.with_index(1)
    |> Enum.map(fn({letter, index}) ->
      content_tag :span, class: Enum.join([class_prefix, index], "-") do
        letter
      end
    end)
  end
end
