
require 'rubygems'
require 'maruku'

class RendererFactory
    def create( content_type )
        case content_type
        when "html"
            return HtmlRenderer.new()
        when "markdown" 
            return MarkdownRenderer.new()
        end
    end
end

class HtmlRenderer
    def to_html( content, yaml_object )
        return content.gsub("\n\n", "<br/>")
    end
end

class MarkdownRenderer
    def to_html( content, yaml_object )
        return Maruku.new(content).to_html()
    end
end
