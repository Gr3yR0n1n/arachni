=begin
  $Id$

                  Arachni
  Copyright (c) 2010 Anastasios Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

require 'singleton'

module Arachni

#
# Options class.
# 
# Implements the Singleton pattern and formaly defines
# all of Arachni's runtime options.
#
# @author: Anastasios "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: $Rev: 287 $
#
class Options

    include Singleton
    
    #
    # Holds absolute paths for the directory structure of the framework
    #
    # @return    [Hash]
    #
    attr_accessor :dir
    
    #
    # The URL to audit
    #
    # @return    [String,URI]
    #
    attr_accessor :url
    
    #
    # Show help?
    #
    # @return    [Bool]
    #
    attr_accessor :help
    
    #
    # Output only positive results during the audit?
    #
    # @return    [Bool]
    #
    attr_accessor :only_positives
    
    #
    # Not implemented
    #
    attr_accessor :resume
    
    #
    # Be verbose?
    #
    # @return    [Bool]
    #
    attr_accessor :arachni_verbose
    
    #
    # Output debugging messages?
    #
    # @return    [Bool]
    #
    attr_accessor :debug
    
    #
    # Filters for redundant links
    #
    # @return    [Array]
    #
    attr_accessor :redundant
    
    #
    # Should the crawler obery robots.txt files?
    #
    # @return    [Bool]
    #
    attr_accessor :obey_robots_txt
    
    #
    # How deep to go in the site structure?<br/>
    # If nil, depth_limit = inf
    #
    # @return    [Integer]
    #
    attr_accessor :depth_limit
    
    #
    # How many links to follow?
    # If nil, link_count_limit = inf
    #
    # @return    [Integer]
    #
    attr_accessor :link_count_limit
    
    #
    # How many redirects to follow?
    # If nil, redirect_limit = inf
    #
    # @return    [Integer]
    #
    attr_accessor :redirect_limit
    
    #
    # List modules and exit?
    #
    # @return    [Bool]
    #
    attr_accessor :lsmod
    
    #
    # List reports and exit?
    #
    # @return    [Bool]
    #
    attr_accessor :lsrep
    
    #
    # How many threads to spawn?
    #
    # @return    [Integer]
    #
    attr_accessor :threads
    
    #
    # Should Arachni audit links?
    #
    # @return    [Bool]
    #
    attr_accessor :audit_links
    
    #
    # Should Arachni audit forms?
    #
    # @return    [Bool]
    #
    attr_accessor :audit_forms
    
    #
    # Should Arachni audit cookies?
    #
    # @return    [Bool]
    #
    attr_accessor :audit_cookies
    
    #
    # Should Arachni audit the cookies in the cookiejar?
    #
    # @return    [Bool]
    #
    attr_accessor :audit_cookie_jar
    
    #
    # Should Arachni audit HTTP headers?
    #
    # @return    [Bool]
    #
    attr_accessor :audit_headers
    
    #
    # Array of modules to load
    #
    # @return    [Array]
    #
    attr_accessor :mods
    
    #
    # Array of reports to load
    #
    # @return    [Array]
    #
    attr_accessor :reports
    
    #
    # Location of an Arachni Framework Report (.afr) file to load
    #
    # @return    [String]
    #
    attr_accessor :repload
    
    #
    # Where to save the Arachni Framework Report (.afr) file
    #
    # @return    [String]
    #
    attr_accessor :repsave
    
    #
    # Options to be passed to the reports
    #
    # @return    [Hash]     name=>value pairs
    #
    attr_accessor :repopts
    
    #
    # Where to save the Arachni Framework Profile (.afp) file
    #
    # @return    [String]
    #
    attr_accessor :save_profile
    
    #
    # Location of an Arachni Framework Profile (.afp) file to load
    #
    # @return    [String]
    #
    attr_accessor :load_profile
    
    #
    # The person that authorized the scan<br/>
    # It will be added to the HTTP "user-agent" and "from" headers.
    #
    # @return    [String]
    #
    attr_accessor :authed_by
    
    #
    # The address of the proxy server
    #
    # @return    [String]
    #
    attr_accessor :proxy_addr
    
    #
    # The port to connect on the proxy server
    #
    # @return    [String]
    #
    attr_accessor :proxy_port
    
    #
    # The proxy password
    #
    # @return    [String]
    #
    attr_accessor :proxy_pass
    
    #
    # The proxy user
    #
    # @return    [String]
    #
    attr_accessor :proxy_user
    
    #
    # The proxy type
    #
    # @return    [String]     [http, socks]
    #
    attr_accessor :proxy_type
    
    #
    # To be populated by the framework
    #
    # Parsed cookiejar cookies
    #
    # @return    [Hash]     name=>value pairs
    #
    attr_accessor :cookies
    
    #
    # Location of the cookiejar
    #
    # @return    [String]
    #
    attr_accessor :cookie_jar
    
    #
    # The HTTP user-agent to use
    #
    # @return    [String]
    #
    attr_accessor :user_agent
    
    #
    # Exclude filters <br/>
    # URL matching any of these patterns won't be followed
    #
    # @return    [Array]
    #
    attr_accessor :exclude
    
    #
    # Include filters <br/>
    # Only URLs that match any of these patterns will be followed
    #
    # @return    [Array]
    #
    attr_accessor :include
    
    #
    # Should the crawler follow subdomains?
    #
    # @return    [Bool]
    #
    attr_accessor :follow_subdomains
    
    #
    # Run the modules after the crawl/analysis?
    #
    # @return    [Bool]
    #
    attr_accessor :mods_run_last
    
    # to be populated by the framework
    attr_accessor :start_datetime
    # to be populated by the framework
    attr_accessor :finish_datetime
    # to be populated by the framework
    attr_accessor :delta_time
    
    def initialize( )
        
        # nil everything out
        self.instance_variables.each {
            |var|
            send( "#{var}=", nil )
        }
        
        @exclude    = [] 
        @include    = []
        @redundant  = []
        @reports    = []
        @repopts    = Hash.new
        @dir        = Hash.new
        
    end
    
    #
    # Converts the Options object to hash
    #
    # @return    [Hash]
    #
    def to_h
        hash = Hash.new
        self.instance_variables.each {
            |var|
            hash[normalize_name( var )] = self.instance_variable_get( var ) 
        }
        hash
    end
    
    #
    # Merges self with the object in 'options'
    #
    # @param    [Options]
    #
    def merge!( options )
        options.to_h.each_pair {
            |k, v|
            send( "#{k}=", v ) if v
        }
    end
    
    private
    
    def normalize_name( name )
        name.to_s.gsub( /@/, '' )
    end

    
end
end