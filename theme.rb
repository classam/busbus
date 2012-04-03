
require 'yaml'
require 'erb'
require './post'
require './util'

class Theme

    def initialize( theme_folder )
        index_file = theme_folder + "/index.rhtml"      
        single_file = theme_folder + "/single.rhtml" 
        preferences_file = theme_folder + "/settings.yaml"
        
        file = File.open( index_file, 'rb' )
        @index_theme_erb = ERB.new( file.read )
        file = File.open( single_file, 'rb' )
        @single_theme_erb = ERB.new( file.read )
        file = File.open( preferences_file, 'rb' )
        @settings = YAML.load(file.read)
        
        @templates = get_all_other_templates( theme_folder ) 
        puts @templates.inspect

    end

    def get_all_other_templates( folder ) 
        contains = Dir.new( folder ).entries

        templates = {}
        
        contains.each { |path|
            if( path != "." and path != ".." and path =~ /rhtml$/ and path != 'single.rhtml' and path != 'index.rhtml' ) 
                file = File.open( folder + "/" + path, 'rb' )
                templates[path] = ERB.new( file.read )
            end
        }

        return templates

    end

    def render( posts, output_folder )
        softmkdir( output_folder )

        quickwrite( generate_index( posts ), output_folder + "/index.html" )
    end
    
    def generate_index( posts ) 
        return @index_theme_erb.result( binding )
    end

end
