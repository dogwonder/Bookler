# wordcloud.rb
require 'rubygems'
require 'sinatra'
require 'haml'
require 'feed-normalizer'
require 'prince-ruby'
require './readability.rb'
require 'open-uri'

post '/' do
   feedurl = params[:feedurl]
   posts = []
   @chapters = []
   feed = FeedNormalizer::FeedNormalizer.parse open(feedurl)
   feed.entries.each do |post|
      source = open(post.urls.first).read
      rtext = Readability::Document.new(source, :tags => %w[p img], :attributes => %w[src href], :remove_empty_nodes => false).content;
      @chapters.push("title"=>post.title,"content"=>rtext)

  end

   haml :book
end

get '/' do
  haml :index
end
