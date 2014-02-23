
require './input_yaml'
require './post'
require './theme'

require 'optparse' 

def compile( input_folder, output_folder, theme_folder, root, single_category = nil )

    posts = yaml_directory_to_list_of_posts( input_folder )
    theme = Theme.new( theme_folder, root ) 

    theme.render( posts, output_folder, single_category ) 

end


options = {} 

optparse = OptionParser.new {|opts|
    opts.banner = "Usage: ruby busbus_compiler.rb --input_folder INPUT_FOLDER --theme_folder THEME_FOLDER --output_folder OUTPUT_FOLDER"

    options[:input_folder] = nil
    opts.on( '-i', '--input_folder INPUT', 'Path to a folder containing .yaml posts.') { |input| options[:input_folder] = input } 
    
    options[:root] = nil
    opts.on( '-r', '--root FOLDER', 'The site root - e.g. curtis.lassam.net/') { |folder| options[:root] = folder } 
    
    options[:theme_folder] = nil
    opts.on( '-t', '--theme_folder THEME', 'Path to a folder containing a busbus theme.') { |theme| options[:theme_folder] = theme } 
    
    options[:output_folder] = nil
    opts.on( '-o', '--output_folder OUTPUT', 'Path to the target folder.') { |output| options[:output_folder] = output } 

    options[:single_category] = nil
    opts.on( '-s', '--single_category CATEGORY', 'Only render posts that contain this category.') { |category| options[:single_category] = category } 

    opts.on("-h", "--help", "Show this message"){
        puts opts
        exit
    }
}

optparse.parse!

if options[:input_folder] == nil or options[:theme_folder] == nil or options[:output_folder] == nil or options[:root] == nil
    puts optparse
    exit
end

compile( options[:input_folder], options[:output_folder], options[:theme_folder], options[:root], options[:single_category]) 
