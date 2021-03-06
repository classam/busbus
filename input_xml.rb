# -*- encoding : utf-8 -*-
require "./post"

require 'rubygems'
require 'cgi' 
require 'nokogiri'
require 'Date' 

class WordpressPost < Post
## A special subclass of Post for ex-Wordpress posts. 
    attr_accessor :wp_link
end


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
        @post = WordpressPost.new()
        begin
            @post.title = nokogiri_xml_item.at_css("title").content
        rescue
            @post.title = ""
            @post.errors.push( "Could not parse title." )
        end

        begin
            @post.created = DateTime.parse( nokogiri_xml_item.at_css("post_date").content ) 
        rescue
            @post.errors.push( "Could not parse date" )
        end
       
        begin 
            @post.html_content = nokogiri_xml_item.css("encoded").first().content
        rescue 
            @post.errors.push( "Could not parse content" )
        end

        if nokogiri_xml_item.at_css("status") != nil 
            @post.visible = nokogiri_xml_item.at_css("status").content == "publish"
        else
            @post.errors.push( "Could not parse status" )
        end
        @post.visible = true if nokogiri_xml_item.at_css("status") != nil and nokogiri_xml_item.at_css("status").content == "publish"
        @post.categories = nokogiri_xml_item.css("category")
        @post.categories = post.categories.map { |category| CGI.unescapeHTML(category.content) } 
        if nokogiri_xml_item.at_css("post_id") != nil
            @post.wp_link = nokogiri_xml_item.at_css("post_id").content
        else
            @post.errors.push( "Could not parse id." )
        end
    end
    attr_reader :post
end
