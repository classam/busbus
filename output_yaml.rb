# -*- encoding : utf-8 -*-

require "./post"

require "yaml"

class Post
    def to_yaml
        object = {'title' => @title,
                  'created' => @created.to_s, 
                  'visible'=> @visible,
                  'categories' => @categories,
                  'content_type' => 'html',
                  'content' => @html_content,
                  } 
        return YAML.dump( object ) 
    end
end
