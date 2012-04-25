
require 'yaml'
require 'erb'
require 'cgi'
require './post'
require './util'
require './rss'

class Theme

    def initialize( theme_folder, root )
        @theme_folder = theme_folder
        index_file = @theme_folder + "/index.rhtml"      
        single_file = @theme_folder + "/single.rhtml" 
        preferences_file = @theme_folder + "/settings.yaml"
        
        file = File.open( index_file, 'rb' )
        @index_theme_erb = ERB.new( file.read )
        file = File.open( single_file, 'rb' )
        @single_theme_erb = ERB.new( file.read )
        file = File.open( preferences_file, 'rb' )
        @settings = YAML.load(file.read)
        @settings['location'] = root
        
        @templates = get_all_other_templates( @theme_folder ) 
        
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

    def copy_style( theme_folder_path, output_folder_path ) 
        # calculate paths
        output_style_folder_path = File.join( output_folder_path, "style" )
        theme_style_folder_path = File.join( theme_folder_path, "style" ) 
        # delete the folder if it already exists
        if File.directory? output_style_folder_path
            FileUtils.rm_rf( output_style_folder_path )  
        end
        # replace it. 
        FileUtils.cp_r( theme_style_folder_path, output_style_folder_path )
    end

    def render( posts, output_folder )

        posts.sort! { |a, b|  b.created <=> a.created }

        categories = extract_categories( posts )

        softmkdir( output_folder )

        render_all_modules( posts, categories )
        render_all_pages( posts, categories, output_folder )

        generate_index( posts, categories, output_folder )
        generate_posts( posts, categories, output_folder )
        generate_rss( posts, output_folder )
        
        copy_style( @theme_folder, output_folder ) 
    end
   
    def extract_categories( posts ) 
        categories = {}
        for post in posts
            for category in post.categories
                if categories[category] == nil
                    categories[category] = []
                end
                categories[category].push( post ) 
            end
        end
        return categories 
    end

    def render_all_modules( posts, categories ) 
        for template_name, template in @templates
            if( template_name =~ /^_/ ) 
                @templates[template_name] = template.result( binding )
            end
        end
    end

    def render_all_pages( posts, categories, output_folder ) 
        for template_name, template in @templates
            unless( template_name =~ /^_/ ) 
                @templates[template_name] = template.result( binding )
                quickwrite( @templates[template_name], File.join( output_folder, template_name)  ) 
            end
        end
    end

    def generate_index( posts, categories, output_folder ) 
        categories = categories.sort_by{|key, value| -value.length } 
        quickwrite( @index_theme_erb.result( binding ), File.join( output_folder, "index.html") ) 
    end

    def generate_posts( posts, categories, output_folder )
        softmkdir( File.join( output_folder, "post" ) )

        posts.each_with_index do |post, index|  
            previous_index = index + 1
            next_index = index - 1

            previous_post = nil

            if previous_index <= posts.length
                previous_post = posts[previous_index]
            end
            unless next_index < 0 
                next_post = posts[next_index]
            end 

            category_object = {}
            post.categories.each do |category|
                category_object[category] = {}
                categories[category].each_with_index do |category_post, category_index|
                    if category_post.id == post.id then
                        previous_post_in_category_index = category_index + 1
                        next_post_in_category_index = category_index - 1

                        if previous_post_in_category_index <= categories[category].length 
                            category_object[category]['previous'] = categories[category][previous_post_in_category_index]
                        end
                        unless next_post_in_category_index < 0 
                            category_object[category]['next'] = categories[category][next_post_in_category_index]
                        end 
                    end
                end
    
            end
            
            generate_post( previous_post, post, next_post, category_object, output_folder )
        end
    end

    def generate_post( previous_post, current_post, next_post, category_object, output_folder ) 
        quickwrite( @single_theme_erb.result( binding ), File.join( output_folder, 'post', current_post.id + ".html") ) 
    end

    def generate_rss( posts, output_folder )
        rss = FeedMeSeymour.new( posts, @settings )
        quickwrite( rss.content, File.join( output_folder, "rss.xml" ) )
    end

end
