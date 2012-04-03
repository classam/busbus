
require './input_xml'
require "./output_yaml"
require "./util"

require 'rubygems'
require 'nokogiri'

def write_post_to_file( post, output_folder ) 
    begin
        file_path = output_folder + "/" + post.id + ".yaml" 
        quickwrite( post.to_yaml(), file_path )
    rescue
    end
end

def wordpress_convert( input_filename, output_folder )
    xml_parsed = Nokogiri::XML( File.open( input_filename) ) 

    posts = []
    # extract into individual items
    xml_parsed.css('item').each { |item|
        converter = InputStringXml.new( item.to_s )
        posts.push(converter.post)
    }
    
    # create output directory
    softmkdir( output_folder )

    # convert into YAML
    # write to files
    posts.each{ |post| write_post_to_file( post, output_folder ) }
end

wordpress_convert( "/Users/curtis/code/curtislassam.wordpress.2012-03-30.xml", "/Users/curtis/code/generated" )
