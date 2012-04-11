
require "./renderer"
require "test/unit"

class TestRenderer < Test::Unit::TestCase

    def setup
    end

    def test_html_output
        html_renderer = HtmlRenderer.new()
        html = "<h1>Hello</h1><p>How are you?</p>"
        output = html_renderer.to_html( html, nil )
        assert_equal( "<p>"+html+"</p>", output ) 
    end

    def test_markdown_output
        markdown_renderer = MarkdownRenderer.new()
        markdown = "
Hello
-----
How are you?
        "
        output = markdown_renderer.to_html( markdown, nil )
        assert_match( /<h2 id='hello'>/, output )
    end

end
