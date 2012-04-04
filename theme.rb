
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
    end

    def get_all_other_templates( folder ) 
        contains = Dir.new( folder ).entries

        templates = {}
        
        contains.each { |path|
            if( path != "." and path != ".." and path =~ /rhtml$/ and path != 'single.rhtml' and path != 'index.rhtml' ) 
                file = File.open( folder + "/" + path, 'rb' )

                # remove extension from module name
                pathname_without_extension = path[ 0, path.rindex('.')]  

                templates[pathname_without_extension] = ERB.new( file.read )
            end
        }

        return templates
    end

    def render( posts, output_folder )
        softmkdir( output_folder )

        render_all_modules( posts )
        render_all_pages( posts )

        generate_index( posts, output_folder )

        posts.each_with_index do |post, index|  
            previous_index = index - 1
            next_index = index + 1

            previous_post = nil

            unless previous_index < 0
                previous_post = posts[previous_index]
            end
            unless next_index > posts.length 
                next_post = posts[next_index]
            end
            
            generate_post( previous_post, post, next_post, output_folder )

        end
    end
    
    def render_all_modules( posts ) 
        for template_name, template in @templates
            if( template_name =~ /^_/ ) 
                @templates[template_name] = template.result( binding )
            end
        end
    end

    def render_all_pages( posts ) 
        for template_name, template in @templates
            unless( template_name =~ /^_/ ) 
                @templates[template_name] = template.result( binding )
                quickwrite( @templates[template_name], output_folder + "/" + template_name ) 
            end
        end
    end

    def generate_index( posts, output_folder ) 
        quickwrite( @index_theme_erb.result( binding ), output_folder + "/index.html" ) 
    end

    def generate_post( previous_post, current_post, next_post, output_folder ) 
        quickwrite( @single_theme_erb.result( binding ), output_folder + "/" + current_post.id + ".html" ) 
    end

end
