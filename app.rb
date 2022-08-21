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
enable :sessions

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

# get '/edit' do
#     @url = ""
#     erb :editor
# end

get '/edit' do
    # @url = ""
    if session[:admin] == true
        @url = ""
        erb :editor
    else
        # redirect '/editor_login'
        # @url = ""
        erb :editor_login
    end
end

post '/editor_login' do
    username=params[:username]
    password=params[:password]
    if username == ENV['USERNAME'] && password == ENV['PASSWORD']
        session[:admin] = true
        redirect '/edit'
    end
    # @url = ""
    # erb :editor
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
    @img_url = ''
    if params[:image]
        img = params[:image]
        tempfile = img[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
        json = {
            "success": 1,
            "file": {
                "url": img_url
            }
        }
        puts json
        json.to_json
    end
end