require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class Article < ActiveRecord::Base
end