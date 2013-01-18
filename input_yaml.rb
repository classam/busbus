
require "./post"
require 'yaml'
require './renderer'
require 'date'

class InputYaml

    def initialize( yaml, rendererFactory = RendererFactory.new() )
        object = YAML.load( yaml )

        @post = Post.new()

        @post = Post.new()
        @post.title = object['title']
        @post.created = DateTime.parse(object['created'])

        if object['content'] then
            content = object['content']
        else
            content = ""
        end
        
        if object['content_type'] then
            content_type = object['content_type']
        else
            content_type = "html"
        end
        renderer = rendererFactory.create( content_type )

        @post.html_content = renderer.to_html( content, object )  
        @post.categories = object['categories']
        @post.visible = object['visible']
    end
    
    attr_reader :post
end
