# -*- encoding : utf-8 -*-

require "./post" 
require "./output_yaml"

require "test/unit"
require "Date"
require "yaml"

class TestPost < Test::Unit::TestCase
    
    def setup
        @post = Post.new()
        @post.title = "Hello, How Are You? "
        @post.created = DateTime.new( 2008, 1, 10, 23, 58, 31)  
        @post.html_content = "<h1>Hello!</h1> <p>Talkin' about stuff!</p>" 
        @post.categories = ["One", "Two"] 
    end

    def test_id
        assert_equal( "2008_01_10-Hello_How_Are_You", @post.id )
    end

    def test_visible
        assert( !@post.visible? )
        @post.visible = true
        assert( @post.visible? )
    end

end
