module EasyIndexer
  module Callbacks
    extend ActiveSupport::Concern

    included do
      after_save        :store_index
      before_destroy    :remove_index
    end

    def to_indexed_json
      to_json
    end

  protected
    def store_index
      index.store(self)
    end

    def remove_index
      index.remove(self)
    end
  end
end
