#require "bundler/setup"
require "sinatra"
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'
require 'builder'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/reloader' if development?

require 'sinatra/authorization'
models = File.join(File.dirname(__FILE__), 'models/notes.rb')
require models

use Rack::Flash, :sweep => true

helpers do
	def authorize(login, password)
		login = 'admin' && password = 'secret'
	end
	include Rack::Utils
	alias_method :h, :escape_html
end

get '/rss.xml' do
	@notes = Note.all :order => :id.desc
	builder :rss
end

get '/' do
	@notes = Note.all :order => :id.desc
	@title = "All notes"
	if @notes.empty?
		flash[:error] = "No notes found. Add your first below."
	end
	erb :home
end
post '/?' do
	n = Note.new
	n.content     = params[:content]
	n.created_at  = Time.now
	n.updated_at  = Time.now
	if n.save
		redirect '/?', :notice => "Note created successfully."
	else
		redirect '/?', :error => "Failed to save note."
	end
end
get '/:id/?' do
	@note   = Note.get params[:id]
	@title  = "Edit note ##{params[:id]}"
	if @note
		erb :edit
	else
		redirect '/?', :notice => "Can't find that note."
	end
end
put '/:id/?' do
	n = Note.get params[:id]
	unless n
		redirect '/', :notice => "Can't find that note."
	end
	n.content     = params[:content]
	n.complete    = params[:complete] ? 1 : 0
	n.updated_at  = Time.now
	if n.save
		redirect '/', :notice => "Note updated successfully."
	else
		redirect '/', :error  => "Error updating note."
	end
	redirect '/'
end
get '/:id/delete/?' do
	@note   = Note.get params[:id]
	@title  = "Confirm deletion of note ##{params[:id]}"
	if @note
		erb :delete
	else
		redirect '/', :error => "Can't find that note."
	end
end
delete '/:id/?' do
	n = Note.get params[:id]
	if n.destroy
		redirect '/', :notice => "Note deleted successfully."
	else
		redirect '/', :error => "Error deleting note."
	end
end
get '/:id/complete/?' do
	n = Note.get params[:id]
	unless n
		redirect '/', :error => "Can't find that note."
	end
	n.complete = params[:complete] ? 0 : 1
	n.updated_at = Time.now
	if n.save
		redirect '/', :notice => 'Note marked as complete.'
	else
		redirect '/', :error => "Error marking note as complete."
	end
	redirect '/'
end