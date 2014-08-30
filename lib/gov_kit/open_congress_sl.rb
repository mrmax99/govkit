module GovKit

  # Parent class for OpenStates resources
  # See http://openstates.sunlightlabs.com/api/
  class OpenCongressSlResource < Resource
    base_uri GovKit::configuration.opencongress_sunlight_base_url

    # Do a GET query, with optional parameters.
    #
    # OpenStates returns a 404 error when a query
    # returns nothing.
    #
    # So, if a query result is a resource not found error,
    # we return an empty set.
    def self.get_uri(uri, options={})
      options[:query] ||= {}
      options[:query][:apikey] = GovKit::configuration.sunlight_apikey

      begin
        parse(get(URI.encode(uri), options))
      rescue ResourceNotFound
        []
      end
    end

  end

  # Ruby module for interacting with the Open States Project API
  # See http://openstates.sunlightlabs.com/api/
  # Most +find+ and +search+ methods: 
  # * call HTTParty::ClassMethods#get
  # * which returns an HTTParty::Response object
  # * which is passed to GovKit::Resource#parse
  # * which uses the response to populate a Resource
  #
  module OpenCongressSl

    # The Legislator class represents the legislator data returned from Open States.
    #
    # For details about fields returned, see the Open States documentation, at 
    # http://openstates.sunlightlabs.com/api/legislators/, 
    #
    class Legislator < OpenCongressSlResource
      def self.locate(options = {})
        result = get_uri('/legislators/locate', :query => options)
        return Array(result).first.results
      end

      def self.search(options = {})
        result = get_uri('/legislators', :query => options)
        return Array(result).first.results
      end
    end
    
  end
end
