
require './input_yaml'
require './post'
require './theme'

def compile( input_folder, output_folder, theme_folder )

    posts = yaml_directory_to_list_of_posts( input_folder )
    theme = Theme.new( theme_folder ) 

    theme.render( posts, output_folder ) 

end

compile( "/Users/curtis/code/generated", "/Users/curtis/code/website", "/Users/curtis/code/busbus/default_theme" )
