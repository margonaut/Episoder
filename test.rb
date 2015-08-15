# require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_Steven_Universe_episodes"))

class Episode
  attr_reader :title, :number, :description
  def initialize (title, number, description)
    @title = title
    @number = number
    @description = description
  end
end

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

episode_list = []
episodes = page.css('tr.vevent')
episodes.each do |episode|
  title = (episode > ('.summary')).text
  number = episode.children[1].text
  description = find_description(episode)
  new_episode = Episode.new(title, number, description)
  episode_list << new_episode
end

puts episode_list[6].description
