require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'net/http'
require 'sinatra/activerecord'
require './models'

get '/' do
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