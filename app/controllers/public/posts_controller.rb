class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
  end
  
  def destroy
  end
end
