#=begin
class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    #debugger
  end

  def new
    @user = User.new
    #debugger
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #8.2.5 追加
    #if @user.false  #演習
      flash[:success] = "Welcome to the Sample App!"
      # 保存の成功をここで扱う。
      #redirect_to @user 下と同じ意味
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
  
end
#=end
