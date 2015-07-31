module JSON
  class Schema
    module Lite
      class Block < Hash

        def initialize(&block)
          self.instance_eval &block
        end

        %w(string number boolean null).each do |method|
          define_method method do |key, option = {}|
            set_properties key, __method__
            add_required key if option[:required]
          end
        end

        def array(key, *args, &block)
          prop = {
            type: :array
          }
          if block_given?
            prop[:items] = self.class.new(&block)
            opt_index = 0
          else
            prop[:items] = { type: args[0] }
            opt_index = 1
          end
          if args[opt_index].is_a?(Hash)
            option = args[opt_index]
            add_required key if option[:required]
          end
          set_properties key, prop
        end

        def object(key, option = {}, &block)
          set_properties key, self.class.new(&block)
          add_required key if option[:required]
        end

        private

        def set_properties(key, prop)
          self[:type] ||= :object
          self[:properties] ||= {}
          self[:properties][key] = prop.is_a?(Hash) ? prop : { type: prop }
        end

        def add_required(key)
          self[:required] ||= []
          self[:required] << key
        end
      end
    end
  end
end
