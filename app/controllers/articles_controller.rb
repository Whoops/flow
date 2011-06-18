class ArticlesController < ApplicationController
  before_filter :user_required, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :find_article, :authorized_users_only, :only => [:edit, :update, :destroy]

  def index
    @articles = Article.order("id desc")
  end

  def new
    @article = current_user.articles.build
  end

  def edit
  end

  def create
    @article = current_user.articles.build(params[:article])

    if @article.save
      redirect_to(root_path, :notice => 'Article was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to(root_path, :notice => 'Article was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article.destroy
    redirect_to(root_path, :notice => 'Article was successfully destroyed.')
  end

  private

  def authorized_users_only
    unless article_editable_by?(@article, current_user)
      redirect_to root_path,
        :alert => "You are not authorized to edit other user's articles!"
    end
  end

  # TODO: review after integrating models.
  def article_editable_by?(article, user)
    user.admin? || user == article.user
  end
  helper_method :article_editable_by?

  # TODO: remove this stub method after integrate entire auth.
  def current_user
    @current_user ||= User.last
  end

  def find_article
    @article = Article.find(params[:id])
  end
end
