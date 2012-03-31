
class Post
    attr_accessor :title, :created, :html_content, :categories 
    def initialize()
        @visible = false
    end
    
    def datestamp
        @created.strftime("%Y_%b_%d")
    end
    
    def namestamp 
        @title.strip!.gsub(/\s/, '_').gsub(/\W/, '')
    end

    def id
        datestamp + '-' + namestamp
    end


    def visible=( bool )
        @visible = bool
    end

    def visible?
        @visible
    end
end

class WordpressPost < Post
## A special subclass of Post for ex-Wordpress posts. 
    attr_accessor :wp_link
end
