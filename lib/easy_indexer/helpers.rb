module EasyIndexer
  module Helpers
    def global_search
      engine.query { all }
      engine.results
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
