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

  protected

    def bootstrap!
      @index = Tire::Index.new(index_name)
      @index.create(mappings) unless @index.exists?
    end

    def mappings
      JSON.parse(File.open("#{Rails.root}/config/indexes/#{@index_name}.json").read)
    end

    def index_name
      "#{@index_name}-#{Rails.env}"
    end

    def engine
      @engine ||= Tire::Search::Search.new(index_name)
    end

    def results
      engine.results
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
