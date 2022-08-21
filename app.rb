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
# require 'rack/cache'
# require 'sinatra'
enable :sessions

before do
    Dotenv.load
    Cloudinary.config do |config|
        config.cloud_name = ENV['CLOUD_NAME']
        config.api_key = ENV['CLOUDINARY_API_KEY']
        config.api_secret = ENV['CLOUDINARY_API_SECRET']
    end
end

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['USERNAME'], ENV['PASSWORD']]
  end
end

get '/edit' do
    protected!
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