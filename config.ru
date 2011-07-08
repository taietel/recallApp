require "sinatra"
require "./main.rb"
SITE_TITLE = "Recall"
SITE_DESCRIPTION = "'cause you're to busy to remember"
enable :sessions
enable :logging
set :environment, :development
set :authorization_realm, "Protected content"
set :root, File.dirname(__FILE__)
#disable :run
# app = File.join(File.dirname(__FILE__), 'main')



Sinatra::Application::run
