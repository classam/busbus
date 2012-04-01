
require "./post"
require "./input_yaml"

require "yaml"
require "test/unit"

class MockRenderer
    def to_html( content )
        return content
    end
end

class MockRendererFactory
    def create( content_type )
        return MockRenderer.new()
    end
end

class TestYamlInput < Test::Unit::TestCase

    def setup
        @yaml =
        "
        title: ! 'Hello, How Are You? '
        created: '2008-01-10T23:58:31+00:00'
        visible: false
        categories:
        - One
        - Two
        content_type: html
        content: <h1>Hello!</h1> <p>Talkin' about stuff!</p>
        "

        @converter = InputYaml.new( @yaml, MockRendererFactory.new() )
        @post = @converter.post
    end

    def test_title
        assert_equal("Hello, How Are You? ", @post.title)
    end

    def test_created
        assert_equal( DateTime.new( 2008, 1, 10, 23, 58, 31 ), @post.created ) 
    end

    def test_content
        assert_not_nil( @post.html_content )
    end
    
    def test_status
        assert( !@post.visible? )
    end
   
    def test_category
        assert_equal( ["One", "Two"], @post.categories ) 
    end

end
