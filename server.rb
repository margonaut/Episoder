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

# Methods to assist in and populate an array of Episodes objects

def find_description(episode)
  unless episode.next_element.nil?
    description = episode.next_element.text
  end
  if description.nil?
    description = "SOMETHING WEIRD IS HAPPENING HERE"
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

# End of Ruby Logic. Sinatra routes below

get "/" do
  erb :index
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
