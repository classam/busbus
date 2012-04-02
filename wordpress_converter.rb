
require './input_xml'
require "./output_yaml"

require 'rubygems'
require 'nokogiri'
require 'FileUtils'


def wordpress_convert( input_filename, output_folder )

    xml_parsed = Nokogiri::XML( File.open( input_filename) ) 

    posts = []
    # extract into individual items
    xml_parsed.css('item').each { |item|
        converter = InputStringXml.new( item.to_s )
        posts.push(converter.post)
    }

    posts.each{ |post|
    }
    
    # create output directory
    begin
        FileUtils.mkdir( output_folder ) 
    rescue
    end

    # convert into YAML
    # write to files
    posts.each{ |post|
        begin
            file_path = output_folder + "/" + post.id + ".yaml" 
            File.open( file_path, 'w' ) do |f|
                f.puts post.to_yaml() 
            end
        rescue
            
        end
    }

end

wordpress_convert( "/Users/curtis/code/curtislassam.wordpress.2012-03-30.xml", "/Users/curtis/code/generated" )
