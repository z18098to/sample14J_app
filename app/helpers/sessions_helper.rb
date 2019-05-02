module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
 # 永続セッションとしてユーザーを記憶する
#  def remember(user)
#    user.remember
#    cookies.permanent.signed[:user_id] = user.id
#    cookies.permanent[:remember_token] = user.remember_token
#  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

end

  
  
  

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
    #current_user.nil?  #演習　!を消すとRED
  end
  
    # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  
