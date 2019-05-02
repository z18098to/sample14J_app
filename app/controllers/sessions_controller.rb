class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      
      #params[:session][:remember_me] == '1' ? remember(user) : forget(user) #10.2.3でコメントとした
      redirect_back_or user #10.2.3で追加した
      #redirect_to user #10.2.3でコメントとした
    else
      flash.now[:danger] = 'Invalid email/password combination' # flashは正しくない flash.now　でOK
      render 'new'
    end
  end
  

  def destroy
    log_out
    redirect_to root_url
  end
  
  
end