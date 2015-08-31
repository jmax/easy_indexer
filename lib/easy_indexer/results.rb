module EasyIndexer
  class Results

    def initialize(es_response)
      @response = Hashie::Mash.new(es_response)
    end

    def raw_results
      @response
    end

    def results
      @response.hits.hits.map(&:_source)
    end

    def aggregations
      @response.aggregations
    end

    def count
      @response.hits.total
    end

    def empty?
      count == 0
    end

  end
end
