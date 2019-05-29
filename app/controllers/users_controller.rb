#=begin
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers] #14.2.3
  #before_action :logged_in_user, only: [:index, :edit, :update, :destroy] #10.4.2
  #before_action :logged_in_user, only: [:index, :edit, :update] #10.3.1
  #before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page]) #10.3.3
  end

  def show
    @user = User.find(params[:id])
    #debugger
    
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
    #debugger
  end
  
  def create
    @user = User.new(user_params)
    if @user.save

#      log_in @user #8.2.5 追加
#    #if @user.false  #演習
#      flash[:success] = "Welcome to the Sample App!"
#      # 保存の成功をここで扱う。
#      #redirect_to @user 下と同じ意味
#      redirect_to user_url(@user)
      
      #11.2.4 　上をコメントアウトして以下を有効化
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id]) #10.2.2
  end
  
  def update
    #@user = User.find(params[:id]) #10.2.2
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following #14.2.3
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers #14.2.3
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end



  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
     # beforeアクション

#13.3.1で logged_in_user は　application_controller.rb　にひっこし
#    # ログイン済みユーザーかどうか確認
#    def logged_in_user
#      unless logged_in?
#        store_location  #10.2.3
#        flash[:danger] = "Please log in."
#        redirect_to login_url
#      end
#    end
  
      # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user) #10.2.2
    end
    
      # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
#=end
