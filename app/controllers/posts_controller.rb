class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    connected_user_ids = current_user.accepted_friends.ids << current_user.id
    @timeline_posts ||= Post.where(user_id: connected_user_ids).ordered_by_most_recent.includes(:user)
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
