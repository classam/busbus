
require 'rubygems'
require 'maruku'
require 'cgi'

class RendererFactory
    def create( content_type )
        case content_type
        when "irc"
            return IRCRenderer.new()
        when "comic"
            return ComicRenderer.new()
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
        for line in lines
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

class ComicRenderer
    def to_html( content, yaml_object )

        if yaml_object['comic'] then 
            unless yaml_object['alt-text']
                yaml_object['alt-text'] = ""
            end

            constructed_content = "<div class='comic'>"
            if yaml_object['comic'].kind_of?(Array) then
                constructed_content << "<ul class='comics'>"
                yaml_object['comic'].each do |comic|
                    constructed_content << "<li><img src='"+comic+"' title='"+yaml_object['alt-text']+"' alt='Comic' /></li>"
                end
                constructed_content << "</ul>"
            else
                constructed_content << "<img src='"+yaml_object['comic']+"' title='"+yaml_object['alt-text']+"' alt='Comic' />"
            end
            constructed_content << "</div>"
        end

        constructed_content << "<div class='blog_post'>"
        constructed_content << "" + Maruku.new(content).to_html()
        constructed_content << "</div>"

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
        constructed_content = "<div class='blog_post'>"
        constructed_content << Maruku.new(content).to_html()
        constructed_content << "</div>"
        return constructed_content
    end
end
