class User < ApplicationRecord

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  attr_accessor :remember_token  
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }  #cf 6.2.5 演習1
  
  validates :name,  presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    #uniqueness: true
                    uniqueness: { case_sensitive: false }
  has_secure_password
  #validates :password, presence: true, length: { minimum: 6 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #10.1.4


  #class << self  #●リスト9.5 NG
  # 渡された文字列のハッシュ値を返す
  #def User.digest(string)
  def self.digest(string) #リスト9.4
  #def digest(string) #●リスト9.5 NG
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す  #9.1
  #def User.new_token
  def self.new_token #リスト9.4
  #def new_token #●リスト9.5　NG
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する #9.1
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す #9.1
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget #9.1
    update_attribute(:remember_digest, nil)
  end



  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  #def feed
  #  #Micropost.where("user_id = ?", id)
  #  #Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id) #14.3
  #  Micropost.where("user_id IN (:following_ids) OR user_id = :user_id", #14.3
  #   following_ids: following_ids, user_id: id)
  #end
  
  
  # ユーザーのステータスフィードを返す
  
  def feed # 最終的な feed #14.3
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user #最後の行に追加
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
   
   
   
end

