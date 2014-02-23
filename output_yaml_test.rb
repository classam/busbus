# -*- encoding : utf-8 -*-

require "./post"
require "./output_yaml"

require "yaml"
require "test/unit"

class TestYamlOutput < Test::Unit::TestCase

    def setup
        @post = Post.new()
        @post.title = "Hello, How Are You? "
        @post.created = DateTime.new( 2008, 1, 10, 23, 58, 31)  
        @post.html_content = "<h1>Hello!</h1> <p>Talkin' about stuff!</p>" 
        @post.categories = ["One", "Two"] 
        @yaml = @post.to_yaml()
    end

    def test_output
        assert_not_nil( @yaml )
    end

    def test_parse_output
        returned_yaml = YAML.load( @yaml )
        assert_equal( "html", returned_yaml['content_type'] ) 
        assert_equal( @post.title, returned_yaml['title'] )
        assert_equal( @post.created, DateTime.parse(returned_yaml['created'] ))
        assert_equal( @post.html_content, returned_yaml['content'] )
        assert_equal( @post.categories, returned_yaml['categories'] )
        assert_equal( @post.visible?, returned_yaml['visible'] )
    end

end
