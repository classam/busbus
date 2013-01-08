
require 'rubygems'
require 'maruku'
require 'cgi'

class RendererFactory
    def create( content_type )
        case content_type
        when "irc"
            return IRCRenderer.new()
        when "html"
            return HtmlRenderer.new()
        when "markdown" 
            return MarkdownRenderer.new()
        end
    end
end

class IRCRenderer
    def to_html( content, yaml_object )
        constructed_content = "<ul id='irc'>"
        
        lines = content.split(/\n/) 
        for line in lines:
            escaped_line = CGI.escapeHTML( line )
            if line.match(/<([\S]*)>/)
                constructed_content << escaped_line.gsub(/&lt;([\S]*)&gt;/, '<li><strong class="name">\1</strong>') << "</li>\n"
            else
                constructed_content << "<li class='other'>" << escaped_line << "</li>"
            end
        end

        constructed_content << "</ul>"
        return constructed_content
    end
end

class HtmlRenderer
    def to_html( content, yaml_object )
        constructed_content = "<p>"
        constructed_content << content.gsub("\n\n", "</p><p>")
        constructed_content << "</p>"
        return constructed_content
    end
end

class MarkdownRenderer
    def to_html( content, yaml_object )
        return Maruku.new(content).to_html()
    end
end
