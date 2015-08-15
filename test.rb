require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_Trailer_Park_Boys_episodes"))

class Episode
  def initialize (title, number, description)
  end
end
#
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

episodes = page.css('tr.vevent')
episodes.each do |episode|
  title = (episode > ('.summary')).text
  number = episode.children[1].text
  description = find_description(episode)
  Episode.new(title, number, description)
end



# episodes.each do |episode|
#   unless episode.next_element.nil?
#     description = episode.next_element.text
#   end
#   if description.nil?
#     description = "SOMETHING WEIRD IS HAPPENING HERE"
#   end
#   unless description.include? "TBA"
#     puts description
#   end
# end

#
# descriptions = page.css('tr.vevent').first.class
# puts descriptions

# episodes = page.css('tr.vevent')
# puts episodes[0]
