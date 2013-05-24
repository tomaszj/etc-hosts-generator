require 'rubygems'
require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dev.db")

class HadoopNode
  include DataMapper::Resource

  property :id, Serial
  property :host_name, String
  property :ip, String
end

DataMapper.finalize.auto_upgrade!

get '/' do
  redirect '/nodes'
end

get '/hosts' do
  content_type 'text/plain'
  erb :'hosts_file/hosts', :format => :text, :layout => false
end

get '/nodes' do
  @nodes = HadoopNode.all
  erb :'nodes/index'
end

get '/nodes/new' do
  erb :'nodes/new'
end

get '/nodes/:id' do |id|
  @node = HadoopNode.get!(id)
  erb :'nodes/show'
end

get '/nodes/:id/edit' do |id|
  @node = HadoopNode.get!(id)
  erb :'nodes/edit'
end

post '/nodes' do
  node = HadoopNode.new(params[:node])
  
  if node.save
    redirect '/nodes'
  else
    redirect '/nodes/new'
  end
end

put '/nodes/:id' do |id|
  node = HadoopNode.get!(id)
  success = node.update!(params[:node])
  
  if success
    redirect "/nodes/#{id}"
  else
    redirect "/nodes/#{id}/edit"
  end
end

delete '/nodes/:id' do |id|
  node = HadoopNode.get!(id)
  node.destroy!
  redirect "/nodes"
end
