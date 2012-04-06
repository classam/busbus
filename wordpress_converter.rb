
require './input_xml'
require "./output_yaml"
require "./util"

require 'rubygems'
require 'nokogiri'
require 'optparse'

def write_post_to_file( post, output_folder ) 
    begin
        file_path = File.join( output_folder, post.id + ".yaml" )
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

    #construct a htaccess file
    htaccess = ""
    posts.each{ |post| htaccess << ("Redirect /?p=" + post.wp_link + " /" + post.id + ".html\n")}  
    quickwrite( htaccess, File.join( output_folder, ".htaccess" ) )

end

options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: ruby wordpress_converter.rb --wordpress_xml WORDPRESS_XML --output_folder OUTPUT_FOLDER"

    options[:wordpress_xml] = nil
    opts.on( '-w', '--wordpress_xml INPUT', 'Path to a wordpress export XML file') { |input| options[:wordpress_xml] = input } 
    
    options[:output_folder] = nil
    opts.on( '-o', '--output_folder OUTPUT', 'Creates a busbus .yaml directory in the target folder.') { |output| options[:output_folder] = output } 

    opts.on("-h", "--help", "Show this message"){
        puts opts
        exit
    }
}

optparse.parse!

if options[:wordpress_xml] == nil or options[:output_folder] == nil
    puts optparse
    exit
end

wordpress_convert( options[:wordpress_xml], options[:output_folder] ) 
