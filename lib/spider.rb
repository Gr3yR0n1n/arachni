=begin
  $Id$

                  Arachni
  Copyright (c) 2010 Anastasios Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LINCENSE file for details)

=end
require 'rubygems'
require 'anemone'
require 'nokogiri'
require 'lib/anemone/http'
require 'lib/anemone/page'
require 'lib/net/http'
require 'ap'
require 'pp'

#
# Spider class<br/>
# Crawls the URL in opts[:url] and grabs the HTML code and headers
#
# @author: Zapotek <zapotek@segfault.gr> <br/>
# @version: 0.1-planning
#
class Spider

  #
  # Hash of options passed to initialize( user_opts ).
  #
  # Default:
  #  opts = {
  #        :threads              =>  3,
  #        :discard_page_bodies  =>  false,
  #        :user_agent           =>  "Arachni/0.1",
  #        :delay                =>  0,
  #        :obey_robots_txt      =>  false,
  #        :depth_limit          =>  false,
  #        :link_depth_limit     =>  false,
  #        :redirect_limit       =>  5,
  #        :storage              =>  nil,
  #        :cookies              =>  nil,
  #        :accept_cookies       =>  true
  #  }
  #
  # @return [Hash]
  #
  attr_reader :opts

  #
  # Sitemap, array of links
  #
  # @return [Array]
  #
  attr_reader :sitemap

  #
  # Code block to be executed on each page
  #
  # @return [Proc]
  #
  attr_reader :on_every_page_blocks
  
  #
  # Constructor <br/>
  # Instantiates Spider class with user options.
  #
  # @param  [{String => Symbol}] opts  hash with option => value pairs
  #
  def initialize( opts )

    @opts = {
      :threads              =>  3,
      :discard_page_bodies  =>  false,
      :user_agent           =>  "Arachni/0.1",
      :delay                =>  0,
      :obey_robots_txt      =>  false,
      :depth_limit          =>  false,
      :link_count_limit     =>  false,
      :redirect_limit       =>  false,
      :storage              =>  nil,
      :cookies              =>  nil,
      :accept_cookies       =>  true,
      :proxy_addr           =>  nil,
      :proxy_port           =>  nil,
      :proxy_user           =>  nil,
      :proxy_pass           =>  nil
    }.merge opts

    @sitemap = []
    @on_every_page_blocks = []

    @opts[:include] = @opts[:include] ? @opts[:include] : Regexp.new( '.*' )

    @url = @opts[:url]
    $opts = @opts
  end

  #
  # Runs the Spider and passes the url, html
  # and cookies to the block as strings
  #
  # @param [Proc] block  a block expecting url, html, cookies
  #
  # @return [Array] array of links, a sitemap
  #
  def run( &block )

    i = 1
    Anemone.crawl( @opts[:url], @opts ) do |anemone|
      anemone.on_pages_like( @opts[:include] ) do |page|

        url = page.url.to_s
        if url =~ @opts[:exclude]
          puts '[Skipping: Matched exclude rule] ' + url if @opts[:arachni_verbose]
          next
        end

        if page.error
          puts "[Error: " + (page.error.to_s) + "] " + url
          next
        end

        @sitemap.push( url )

        puts "[HTTP: #{page.code}] " + url if @opts[:arachni_verbose]

        if block
          block.call( url, page.body, page.headers['set-cookie'].to_s )
        end

        @on_every_page_blocks.each do |block|
          block.call( page )
        end

        page.discard_doc!()

        if( @opts[:link_count_limit] != false &&
        @opts[:link_count_limit] <= i )
          return @sitemap.uniq
        end

        i+=1
      end
    end

    return @sitemap.uniq
  end

  #
  # Hook for further analysis of pages, statistics etc.
  #
  # @param [Proc] block code to be executed for every page
  #
  # @return [self]
  #
  def on_every_page( &block )
    @on_every_page_blocks.push( block )
    self
  end

end