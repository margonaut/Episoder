# Preliminary test area for building ruby logic

require 'nokogiri'
require 'open-uri'

# Sets the show being examined with Nokogiri

# def new_show(name)
#   url_name = name.split.map(&:capitalize).join('_')
#   page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_#{url_name}_episodes"))
#   return page
# end
# page = new_show("hannibal")

# Seperate method to find episode descriptions without breaking everything
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

# Defines Episode Class

class Episode
  attr_reader :title, :number, :description
  def initialize (title, number, description)
    @title = title
    @number = number
    @description = description
  end
end

# Creates and populates and array of Episode objects from the current show
def new_show(name)
  url_name = name.split.map(&:capitalize).join('_')
  page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_#{url_name}_episodes"))
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

episode_list = new_show("better off ted")
puts episode_list.count




# episode_list = []
# episodes = page.css('tr.vevent')
# episodes.each do |episode|
#   title = (episode > ('.summary')).text
#   number = episode.children[1].text
#   description = find_description(episode)
#   new_episode = Episode.new(title, number, description)
#   episode_list << new_episode
# end

# puts episode_list[6].description
