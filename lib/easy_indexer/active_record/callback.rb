module ActiveRecord
  class Base
    def self.update_index(index_name, condition = true)
      class_eval <<-EOV
        after_save :push_to_#{index_name}_index
        after_destroy :remove_from_#{index_name}_index

        def push_to_#{index_name}_index
          if #{condition}
            #{index_name.camelize}Index.new.store(self)
          end
        end

        def remove_from_#{index_name}_index
          if #{condition}
            #{index_name.camelize}Index.new.delete(self)
          end
        end
      EOV
    end
  end
end
