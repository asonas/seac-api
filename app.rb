require 'sinatra'
require "sinatra/json"
require "sinatra/reloader" if development?
require 'pathname'

get "/captures" do
  RASTERIZE_JS = File.expand_path('js/rasterize.js').to_s
  OUT_DIR = Pathname.new('public/captures').realpath
  HOSTNAME = "http://seac.ason.as"

  url = params[:url]
  file_name = "#{Digest::MD5.hexdigest(url)}_#{Time.now.to_i}.png"
  file_path = OUT_DIR.join(file_name).to_s
  buf = IO.popen(['phantomjs', RASTERIZE_JS, url, file_path, err: :out], 'r') do |io|
    io.read
  end
  raise buf.inspect unless $?.success?

  json ({image_url: "http://seac.ason.as/captures/#{file_name}"})
end
