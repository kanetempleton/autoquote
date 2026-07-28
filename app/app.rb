require 'sinatra'
require 'json'
require 'securerandom'

set :bind, '0.0.0.0'
set :port, 43594
ruby app/app.rb

