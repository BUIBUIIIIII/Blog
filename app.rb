require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'
require 'sinatra/activerecord'
require './models'
require 'dotenv'
require 'cloudinary'

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

get '/' do
    @url = ""
    erb :editor
end

get '/blog' do
    @articles = Article.all
    erb :blog
end

get '/blog/:id' do
    @articles = Article.find(params[:id])
    erb :articles
end

post '/post-articles' do
    puts params
    Article.create(
        title: params[:title],
        articles: params[:articles]
        )
end

post '/post-images-file' do
    # puts params[:image]
    @img_url = ''
    if params[:image]
        img = params[:image]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        $img_url = upload['url']
    end
    # @@foo = "bar"
    # puts $img_url
    # response = JSON.dump(:"success" => "1", :"file" => {:"url" => $image_url})
    # json response
    # puts CLOUDINARY_API_SECRET
    # redirect '/'
    # "Hello World"
    # puts params
end

get '/get-images-file' do
    # sleep(10)
    puts $img_url
    # json = JSON.parse[res.body]
    # res = NET::HTTP.get_response
    data = {
        :"url" => $img_url
    }
    json = data.to_json
    puts json
    return json
    # render :json => result
    # render json: response
    # json response
    # puts json
    # json response
    # puts "urllist" + $img_url
    # @url = $img_url
    # result = $img_url
    # result response
    # render text: $img_url
end

# post '/post-images-url' do
#     puts params
# end

# get '/get-image-url' do
# end