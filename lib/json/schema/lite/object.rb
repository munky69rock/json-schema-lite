module JSON
  class Schema
    module Lite
      module Object
        def self.define(definition)
          option = definition.is_a?(Hash) ? definition.delete(:option) || {} : {}

          {}.tap do |json_schema|
            if definition.is_a? Hash
              definition.each_pair do |k, v|
                if k.to_s == 'properties' || option[:properties]
                  v[:option] = { properties: true } if v.is_a?(Hash) && v[:properties].nil?
                  json_schema[k] = define v
                else
                  json_schema[k] = v
                end
              end
            elsif definition.is_a? Array
              if definition.size == 1
                json_schema[:type] = :array
                json_schema[:items] = define definition[0]
              else
                json_schema[:anyOf] = definition.map { |d| { type: d } }
              end
            else
              json_schema[:type] = definition
            end
          end
        end
      end
    end
  end
end
