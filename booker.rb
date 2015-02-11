require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'open-uri'
# Look at integrating princely https://github.com/mbleigh/princely
require 'princely'
require './readability.rb'

post '/' do
   feedurl = params[:feedurl]
   posts = []
   @chapters = []
   feed = FeedNormalizer::FeedNormalizer.parse open(feedurl)
   feed.entries.each do |post|
      begin
        if not feed.entries.nil?
          source = open(post.urls.first).read
          rtext = Readability::Document.new(source, :tags => %w[div p img a ul li h1 h2 h3 h4 h5 h6], :attributes => %w[src href], :remove_empty_nodes => false).content;
          @chapters.push("title"=>post.title,"content"=>rtext)
        end
      rescue
              # sliently recue from any tmieouts or 404 when hitting the feeds
      end

  end

   haml :book
end

get '/' do
  haml :index
end