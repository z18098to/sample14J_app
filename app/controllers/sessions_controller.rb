class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      
      
#      # ユーザーログイン後にユーザー情報のページにリダイレクトする
#      log_in user
#      #remember user #9.1
#      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #9.2で復活　上はコメントアウト
#      #params[:session][:remember_me] == '1' ? remember(user) : forget(user) #10.2.3でコメントとした
#      redirect_back_or user #10.2.3で追加した
#      #redirect_to user #10.2.3でコメントとした
      
      if user.activated? #11.3 上の部分は置き換え
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      
      
      
    else
      flash.now[:danger] = 'Invalid email/password combination' # flashは正しくない flash.now　でOK
      render 'new'
    end
  end
  

  def destroy
    #log_out
    log_out if logged_in? #9.1.3
    redirect_to root_url
  end
  
  
end