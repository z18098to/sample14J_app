#変更は　https://qiita.com/nobu0717/items/a34a896f6e7ad68dc54e　参照

equire 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory  = 'z18098to' #'AWSで作成したバケット名'
  #config.fog_directory     =  ENV['S3_BUCKET']
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_DEFAULT_REGION'],
    path_style: true
  }

end

#以下は変更前
#if Rails.env.production?
#  CarrierWave.configure do |config|
#    config.fog_credentials = {
#      # Amazon S3用の設定
#      :provider              => 'fog/aws', #'AWS',
#      :region                => ENV['S3_REGION'],     # 例: 'ap-northeast-1'
#      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
#      :aws_secret_access_key => ENV['S3_SECRET_KEY']
#    }
#    config.fog_directory     =  ENV['S3_BUCKET']
#  end
#end