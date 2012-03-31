
class Post
    attr_accessor :title, :created, :html_content, :status, :categories 
    
    def datestamp
        @created.strftime("%Y_%b_%d")
    end

    def id
        datestamp + '-' + @title
    end
end

class WordpressPost < Post
## A special subclass of Post for ex-Wordpress posts. 
    attr_accessor :wp_link
end
