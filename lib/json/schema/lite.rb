require 'json'
require 'json/schema/lite/version'
require 'json/schema/lite/block'
require 'json/schema/lite/object'

module JSON
  class Schema
    module Lite
      def self.define(definition = nil, &block)
        if block_given?
          Block.new &block
        else
          Object.define definition
        end
      end

      def self.generate(definition = nil, &block)
        if block_given?
          define(&block).to_json
        else
          define(definition).to_json
        end
      end
    end
  end
end
