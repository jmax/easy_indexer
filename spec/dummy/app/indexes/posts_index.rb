class PostsIndex < EasyIndexer::Engine
  index_name "posts"

  def search(key, from = 0, to = 10)
    query = {
      query: { filtered: {
        query:  { match: { body: key } },
        filter: { range: { points: { gte: from, lte: to } } }
      } }
    }

    request(query)
  end
end
