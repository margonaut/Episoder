require 'sinatra'
require 'nokogiri'
require 'open-uri'

class Episode
  attr_reader :title, :number, :description
  def initialize (title, number, description)
    @title = title
    @number = number
    @description = description
  end
end

# Methods to assist in populating an array of Episodes objects

def is_i?(string)
       /\A[-+]?\d+\z/ === string
end

def find_description(episode)
  unless episode.next_element.nil?
    description = episode.next_element.text
  end
  if description.nil?
    description = "SOMETHING WEIRD IS HAPPENING HERE"
  end
  if is_i?(description[1])
    description = ""
  end
  unless description.include? "TBA"
    description
  end

end

def new_show(name)
  page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_#{name}_episodes"))
  episode_list = []
  episodes = page.css('tr.vevent')
  episodes.each do |episode|
    title = (episode > ('.summary')).text
    number = episode.children[1].text
    description = find_description(episode)
    new_episode = Episode.new(title, number, description)
    episode_list << new_episode
  end
  return episode_list
end

def suggested_shows
  shows = ["Steven Universe", "Better Off Ted", "Arrow", "Trailer Park Boys", "Hannibal", "Sherlock", "Twin Peaks", "Firefly", "Orphan Black", "Broad City", "Downton Abbey", "Friends", "Sense8", "American Horror Story", "Arrested Development", "Fringe", "Mad Men", "Scrubs", "The Walking Dead"]
  suggested_shows = []
  shows.each do |show_name|
    show = {}
    name = show_name
    url = show_name.split.map(&:capitalize).join('_')
    show[:name] = name
    show[:url] = url
    suggested_shows << show
  end
  return suggested_shows
end

# End of Ruby Logic. Sinatra routes below

get "/" do
  suggested_shows
  erb :index, locals: { suggested_shows: suggested_shows }
end

get "/show/:show_name" do
  episode_list = new_show(params[:show_name])
  erb :show, locals: { episode_list: episode_list}
end

post "/show" do
  show_name = params[:show_name]
  show_name = show_name.split.map(&:capitalize).join('_')
  redirect "/show/#{show_name}"
end
