require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'open-uri'
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
          rtext = Readability::Document.new(source, :tags => %w[div p img a], :attributes => %w[src href], :remove_empty_nodes => false).content;
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