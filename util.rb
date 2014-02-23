# -*- encoding : utf-8 -*-

require 'fileutils'

# It's lazy, but I have a soft spot for convenience methods.

def softmkdir( output_folder )
    begin
        FileUtils.mkdir( output_folder ) 
    rescue
    end
end

def quickwrite( string, path ) 
    print("writing to " + path + "\n")
    File.open( path, 'w' ) do |f|
        f.puts string
    end
end
