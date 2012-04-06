
require 'rss/maker'
require 'date'

class FeedMeSeymour

    attr_reader :content

    def initialize( posts, settings )

        @content = RSS::Maker.make('2.0') do |m|
            m.channel.title = settings['title']
            m.channel.link = settings['location']
            m.channel.description = settings['description'] 
            m.items.do_sort = true # sort items by date
            
            posts.take(10).each do |post|
                i = m.items.new_item
                i.title = post.title
                i.description = post.html_content
                i.link = settings['location']+"/"+post.id+".html"
                i.date = Time.parse(post.created.to_s)
            end
        end
    end

end
