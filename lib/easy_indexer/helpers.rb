module EasyIndexer
  module Helpers
    def all
      engine.query { all }
      self
    end

    def match(key)
      engine.query { match :_all, key }
      self
    end

    def randomly_ordered
      engine.sort do
        by _script: {
          script: "Math.random()",
          type:   "number",
          params: {},
          order:  "asc"
        }
      end

      self
    end
  end
end
