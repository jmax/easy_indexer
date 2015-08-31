class PostsIndex < EasyIndexer::Engine
  index_name "posts"

  def search(key, from = 0, to = 10)
    query = {
      query: {
        filtered: {
          query:  { match: { _all: key } }
        }
      },
      size: to,
      from: from
    }

    request(query)
  end
end
