# -*- encoding : utf-8 -*-

require 'optparse'
require './post'
require './util'
require './output_yaml'

def create_post( title, path )
    post = Post.new()
    post.title = title  
    file_location = File.join( path, post.id + ".yaml") 
    quickwrite( post.to_yaml, file_location )
    puts file_location
end

options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: ruby create_post.rb --title TITLE -o OUTPUT_FOLDER"
    
    options[:title] = nil
    opts.on( '-t', '--title TITLE', 'The title of the generated post.') { |title| options[:title] = title } 
    
    options[:output_folder] = "./"
    opts.on( '-o', '--output_folder OUTPUT', 'Path to the target folder.') { |output| options[:output_folder] = output } 

    opts.on("-h", "--help", "Show this message"){
        puts opts
        exit
    }
}

optparse.parse!

if options[:title] == nil
    puts optparse
    exit
end

create_post( options[:title], options[:output_folder] ) 
