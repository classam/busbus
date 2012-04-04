
require "./post"
require 'yaml'
require './renderer'
require 'Date'

class InputYaml

    def initialize( yaml, rendererFactory = RendererFactory.new() )
        object = YAML.load( yaml )

        begin
            @post = WordpressPost.new()
            @post.wp_link = object['wp_link'] 
        rescue
            @post = Post.new()
        end

        @post = Post.new()
        @post.title = object['title']
        @post.created = DateTime.parse(object['created'])

        content = object['content']
        content_type = object['content_type']
        renderer = rendererFactory.create( content_type )

        @post.html_content = renderer.to_html( content, object )  
        @post.categories = object['categories']
        @post.visible = object['visible']
    end
    
    attr_reader :post
end
