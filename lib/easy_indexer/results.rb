module EasyIndexer
  class Results

    def initialize(es_response)
      @response = Hashie::Mash.new(es_response)
    end

    def results
      @response.hits.hits.map(&:_source)
    end

    def count
      @response.hits.total
    end

    def empty?
      count == 0
    end

  end
end
