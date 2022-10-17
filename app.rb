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

helpers do
    def current_user
        User.find_by(id:session[:user])
    end
end

get '/' do
    redirect '/blog'
end

get '/signin' do
    erb :sign_in
end

get 'signup' do
    erb :sign_up
end

post '/signin' do
    user = User.find_by(username: username)
    if user then
        if password == user.password then
            session[:user] = user.id
        end
    end
    redirect '/'
end

post '/signup' do
    @user = User.create(mail:params[:mail], password:params[:password],
    password_confirmation:params[:password_confirmation])
    if @user.persisted?
        session[:user] = @user.id
    end
    redirect '/'
end

get '/signout' do
    session[:user] = nil
    redirect '/'
end

get '/edit' do
    # protected!
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
    # data = params
    Article.create(
        title: params[:title],
        articles: params[:articles],
        thumbnail: params[:thumbnail]
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