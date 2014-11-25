require 'sinatra'
require 'aws/s3'

set :port, ENV["PORT"] || 5000

get '/' do
  whom = ENV["POWERED_BY"] || "Deis!"
  container = `hostname`.strip || "unknown"

  AWS::S3::Base.establish_connection!(
    server:             ENV['S3_HOST'],
    access_key_id:      ENV['S3_ACCESS_KEY_ID'],
    secret_access_key:  ENV['S3_SECRET_ACCESS_KEY']
  )

  bucket_list = {}

  AWS::S3::Service.buckets.each do |bucket|
    bucket_content = []

    p bucket

    AWS::S3::Bucket.find(bucket.name).each do |object|
      bucket_content.push "#{object.key}\t#{object.about['content-length']}\t#{object.about['last-modified']}"
      p "  #{object.to_s}"
    end
    p '_____________'

    bucket_list[bucket.name] = bucket_content

  end


  erb :index, locals: {  whom: whom, container: container, buckets: bucket_list}
end

post '/upload' do
  upload(params[:content]['file'][:filename], params[:content]['file'][:tempfile])
  redirect '/'
end

helpers do
  def upload(filename, file)
    bucket = ENV['S3_BUCKET_NAME'] || 'deis-store.local3.deisapp.com/fancy_new_bucket'
    AWS::S3::Base.establish_connection!(
      server:             ENV['S3_HOST'] || 'deis-store.local3.deisapp.com',
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
