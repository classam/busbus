# -*- encoding : utf-8 -*-

class Post
    attr_accessor :title, :created, :html_content, :categories, :errors 
    def initialize()
        @title = ""
        @visible = false
        @created = DateTime.now
        @html_content = ""
        @categories = []
        @errors = []
    end
    
    def datestamp
        @created.strftime("%Y_%m_%d")
    end
    
    def namestamp 
        @title.strip.gsub(/\s/, '_').gsub(/\W/, '')
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

    def link
        "post/"+id+".html"
    end
end


def yaml_directory_to_list_of_posts( input_folder) 
    contains = Dir.new( input_folder ).entries

    posts = []
    
    contains.each { |path|
        if( path != "." and path != ".." and path =~ /yaml$/ ) 
            file = File.open( input_folder + "/" + path, 'rb' )
            print( "Loading file: " + path + "\n")
            content = file.read 
            content = content.encode("UTF-8", {:invalid => :replace, :undef => :replace, :replace => '?'})
            converter = InputYaml.new( content )
            posts.push( converter.post )
        end
    }

    return posts
end
