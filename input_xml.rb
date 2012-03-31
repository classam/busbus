require "post"

require 'rubygems'
require 'cgi' 
require 'nokogiri'
require 'Date' 

class InputStringXml
    def initialize( xml_item, xml_converter_factory=WordpressNokogiriXmlFactory.new() )
        xml_parsed = Nokogiri::XML( xml_item )
        @post = xml_converter_factory.create( xml_parsed ).post
    end
    attr_reader :post
end

class WordpressNokogiriXmlFactory
    def create( nokogiri_xml_item ) 
        return InputWordpressNokogiriXml.new( nokogiri_xml_item ) 
    end
end

class InputWordpressNokogiriXml
    ## Intended to convert Wordpress 'item' XML blocks into canonical post units. 
    def initialize( nokogiri_xml_item )
        nokogiri_xml_item.remove_namespaces! 
        @post = Post.new()
        @post.title = nokogiri_xml_item.at_css("title").content
        @post.created = DateTime.parse( nokogiri_xml_item.at_css("post_date").content ) 
        @post.html_content = nokogiri_xml_item.css("encoded").first().content
        @post.status = nokogiri_xml_item.at_css("status").content
        @post.categories = nokogiri_xml_item.css("category")
        @post.categories = post.categories.map { |category| CGI.unescapeHTML(category.content) } 
        @post.wp_link = nokogiri_xml_item.at_css("post_id").content
    end
    attr_reader :post
end
