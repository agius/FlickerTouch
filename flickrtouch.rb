require 'sinatra'
require 'yaml'
require 'haml'
require 'httparty'

helpers do
  def flickr(method, options = {})
    if ENV['API_KEY']
      @config = {"api_key" => ENV['API_KEY']}
    else
      @config = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/config.yaml')
    end
    HTTParty.get('http://api.flickr.com/services/rest/', :query => {:api_key => @config["api_key"], :method => method}.merge(options))
  end
end

get '/' do
  @page = params[:page] ? params[:page].to_i : 1
  @photos = flickr 'flickr.photos.getRecent', :per_page => '25', :page => @page
  @photos = @photos["rsp"]["photos"]["photo"] if @photos
  if request.xhr?
    @photos.collect{|p| @photo = p; haml(:small_photo, :layout => false)}.join('')
  else
    haml :index
  end
end

get '/photo' do
  unless params[:photo] && ["farm", "server", "id", "secret"].all? {|prop| params[:photo].keys.member?(prop) }
    session['notice'] = 'invalid image'
    redirect '/'
  end
  @photo = params[:photo]
  haml :photo, :layout => !request.xhr?
end

get '/search' do
  redirect '/' unless params[:q]
  @page = params[:page] ? params[:page].to_i : 1
  @photos = flickr('flickr.photos.search', :text => params[:q], :per_page => 25, :page => @page)
  @photos = @photos["rsp"]["photos"]["photo"] if @photos
  @photos.collect{|p| @photo = p; haml(:small_photo, :layout => false)}.join('')
end