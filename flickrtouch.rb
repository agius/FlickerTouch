require 'sinatra'
require 'yaml'
require 'haml'
require 'httparty'

before do
  @config = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + '/config.yaml')
end

get '/' do
  @photos = HTTParty.get('http://api.flickr.com/services/rest/', :query => {:api_key => '184ac67ff5ec7b673f506e74a09b74c0', :method => 'flickr.photos.getRecent', :per_page => '10'})
  @photos = @photos["rsp"]["photos"]["photo"]
  haml :index
end