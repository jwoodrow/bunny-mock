# frozen_string_literal: true
module BunnyMock
  module Exchanges
    class Topic < BunnyMock::Exchange
      # @private
      # @return [String] Multiple subdomain wildcard
      MULTI_WILDCARD = '#'.freeze

      # @private
      # @return [String] Single subdomain wildcard
      SINGLE_WILDCARD = '*'.freeze

      #
      # API
      #

      ##
      # Deliver a message to route with keys matching wildcards
      #
      # @param [Object] payload Message content
      # @param [Hash] opts Message properties
      # @param [String] key Routing key
      #
      # @api public
      #
      def deliver(payload, opts, key)
        delivery_routes = @routes.dup.keep_if { |route, _| key =~ route_to_regex(route) }
        if delivery_routes.values.flatten.any?
          delivery_routes.values.flatten.each { |dest| dest.publish(payload, opts) }
        elsif opts.fetch(:mandatory, false)
          handle_return({ exchange: name, routing_key: key }, opts, payload)
        end
      end

      private

      # @private
      def route_to_regex(key)
        key = key.gsub('.', '\.')
        key = key.gsub(SINGLE_WILDCARD, '(?:\w+)')
        key = key.gsub(MULTI_WILDCARD, '\w+\.?')

        Regexp.new(key)
      end
    end
  end
end
