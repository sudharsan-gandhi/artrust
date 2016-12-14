class PostsController < ApplicationController
  def new
  	@post = current_user.posts.build
  end

  def index
    @posts=Post.all.order('created_at desc')
  end

  def show
    @post=Post.find(params[:id])
    @comment=Comment.new
    @pullcomments=Comment.where(:commentable_id => params[:id])
  end

  def create
  	@post=current_user.posts.build(post_params)
  	if @post.save
  		flash[:sucess] ="success!"
  		puts 'success'
  		redirect_to post_path(@post)
  	else
  		flash[:error] =@post.errors.full_messages
  		puts 'error'
  		redirect_to new_post_path
  	end
  end

  def edit
    @post=Post.find(params[:id])
  end

  def update
    @post=Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: "successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    post=Post.find(params[:id])
    comments=Comment.where(:commentable_id=>params[:id])
    post.destroy
    comments.destroy_all
    redirect_to action:'index', notice: "post deleted successfully"
  end

  def upvote
    @post=Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @post=Post.find(params[:id])
    @post.downvote_by current_user
    redirect_to :back
  end

  def comments
    commentable=Post.find(params[:id])
    comment=commentable.comments.new
    comment.user=current_user
    comment.title=params[:comment][:title].to_s
    comment.comment=params[:comment][:comment].to_s
    if comment.save
      redirect_to :back
    else
      redirect_to :back, notice: "please try again later"
    end

  end

  private
  	def post_params
  		params.require(:post).permit(:image,:Description)
  	end
end
