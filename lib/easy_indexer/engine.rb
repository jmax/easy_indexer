module EasyIndexer
  class Engine

    def initialize
      bootstrap!
      @criteria = { index: index_name }
      self
    end

    def self.index_name(index_name)
      define_method "base_name" do
        instance_variable_set("@base_name", index_name)
      end
    end

    def refresh!
      client.indices.refresh index: index_name
    end

    def store(record)
      client.index( index: index_name, type: type_for(record),
        id: record.id, body: record.as_indexed_json )
    end

    def delete(record)
      client.delete(
        index: index_name, type: type_for(record), id: record.id
      )
    end

    def rebuild!
      remove_index!
      bootstrap!
      self
    end

    def request(query = {})
      EasyIndexer::Results.new(
        client.search(@criteria.merge( body: query ))
      )
    end

    def remove_index!
      client.indices.delete( index: index_name )
    end

  protected
    def bootstrap!
      unless already_defined?
        client.indices.create(
          index: index_name, body: { mappings: mappings }
        )
      end
    end

    def mappings
      JSON.parse(
        File.open("#{Rails.root}/config/indexes/#{base_name}.json").read
      )
    end

    def index_name
      "#{base_name}-#{Rails.env}"
    end

    def client
      @client ||= Elasticsearch::Client.new(url: host_url, log: true)
    end

    def already_defined?
      client.indices.exists( index: index_name )
    end

    def type_for(record)
      record.class.to_s.downcase
    end

    def host_url
      ENV['ELASTICSEARCH_URL'] || "localhost:9200"
    end
  end
end
