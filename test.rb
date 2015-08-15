require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_Steven_Universe_episodes"))

class Episode
  def initialize (title, number)
  end
end

episodes = page.css('tr.vevent')
episodes.each do |episode|
  title = (episode > ('.summary')).text
  number = episode.children[1].text
  Episode.new(title, number)
end



# episodes = page.css('tr.vevent')
# puts episodes[0]
