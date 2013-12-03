module EasyIndexer
  class Engine
    def initialize
      bootstrap!
    end

    def source
      @index
    end

    def rebuild!
      @index.delete
      bootstrap!
    end

    def store(element)
      updater.store(element)
    end

    def remove(element)
      updater.remove(element)
    end

    def self.index_name(index_name)
      define_method "base_name" do
        instance_variable_set("@base_name", index_name)
      end
    end

    def self.scope(name, condition = {})
      define_method name do
        engine.filter :term, condition
        self
      end
    end

    def results
      engine.results
    end

  protected

    def bootstrap!
      @index = Tire::Index.new(index_name)
      @index.create(mappings) unless @index.exists?
    end

    def mappings
      JSON.parse(File.open("#{Rails.root}/config/indexes/#{base_name}.json").read)
    end

    def index_name
      "#{base_name}-#{Rails.env}"
    end

    def engine
      @engine ||= Tire::Search::Search.new(index_name)
    end

    def paginate(criteria)
      page = criteria[:page]
      search_size = criteria[:per_page]
      engine.from (page - 1) * search_size
      engine.size search_size
    end

    def updater
      Tire.index(index_name)
    end
  end
end
