
require "input_xml"
require "test/unit"
require "Date"
require 'rubygems'
require 'nokogiri'

class TestXmlInput < Test::Unit::TestCase

    def setup
        xml = '
        <item>
        <title>The Watchmaker&#039;s Story</title>
		<link>http://www.curtis.lassam.net/?p=340</link>
		<pubDate>Fri, 11 Jan 2008 07:58:31 +0000</pubDate>
		<dc:creator>lassam</dc:creator>
		<guid isPermaLink="false">http://www.curtis.lassam.net/?p=340</guid>
		<description></description>
		<content:encoded><![CDATA[From <a title="Wikipedia: Haberdashery" href="http://en.wikipedia.org/wiki/Haberdashery">Wikipedia</a>: A haberdasher is a person who sells small, commonly used items in clothing via retail. This can include ribbons and buttons, or completed accessories, such as hats or gloves. A haberdashers shop or the items sold therein are called haberdashery.

I would just like to make it known that Ive had a lifelong dream to be a haberdasher, if only for the name. It is s a dangerous profession, though- I dont want to be a man with "<a title="Read the alt-text" href="http://xkcd.com/369/">Died In A Haberdashery Accident</a>" in his obituary.

]]></content:encoded>
		<excerpt:encoded><![CDATA[]]></excerpt:encoded>
		<wp:post_id>340</wp:post_id>
		<wp:post_date>2008-01-10 23:58:31</wp:post_date>
		<wp:post_date_gmt>2008-01-11 07:58:31</wp:post_date_gmt>
		<wp:comment_status>open</wp:comment_status>
		<wp:ping_status>open</wp:ping_status>
		<wp:post_name>haberdashery</wp:post_name>
		<wp:status>publish</wp:status>
		<wp:post_parent>0</wp:post_parent>
		<wp:menu_order>0</wp:menu_order>
		<wp:post_type>post</wp:post_type>
		<wp:post_password></wp:post_password>
		<wp:is_sticky>0</wp:is_sticky>
		<category domain="category" nicename="uncategorized"><![CDATA[Misc]]></category>
        <category domain="category" nicename="design_and_typography"><![CDATA[Design &amp; Typography]]></category> 
	    </item>
        '
        @converter = InputStringXml.new( xml )
        @post = @converter.post
    end

    def test_title
        assert_equal("The Watchmaker's Story", @post.title)
    end

    def test_created
        assert_equal( DateTime.new( 2008, 1, 10, 23, 58, 31 ), @post.created ) 
    end

    def test_content
        assert_not_nil( @post.html_content )
        assert_no_match( /CDATA/, @post.html_content )  
    end
    
    def test_status
        assert_equal( "publish", @post.status )
    end
   
    def test_category
        assert_equal( ["Misc", "Design & Typography"], @post.categories ) 
    end
    
    def test_wp_link
        assert_equal("340", @post.wp_link) 
    end
end

