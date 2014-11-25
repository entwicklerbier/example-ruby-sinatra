require 'sinatra'
require 'aws/s3'

set :port, ENV["PORT"] || 5000

get '/' do
  @whom = ENV["POWERED_BY"] || "Deis!"
  @container = `hostname`.strip || "unknown"
  erb :index :locals => {  whom: @whom, container: @container}
end

post '/upload' do
  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
  redirect '/'
end

helpers do
  def upload(filename, file)
    bucket = 'bucket_name'
    AWS::S3::Base.establish_connection!(
    server:             ENV['S3_HOST'],
    access_key_id:      ENV['S3_ACCESS_KEY_ID'],
    secret_access_key:  ENV['S3_SECRET_ACCESS_KEY']
    )
    AWS::S3::S3Object.store(
    filename,
    open(file.path),
    bucket
    )
    return filename
  end
end
