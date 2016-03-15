EasyIndexer
=======

Take ElasticSearch to the max with this super simple integration for Ruby on Rails applications.


Warning!
-------

Do not try this gem at home unless you've got an advanced knowledge on ElasticSearch's API and you know what you're doing. If you're new to ElasticSearch, I'd urge you to start playing around with a more easy-to-use gem such as:

* [elasticsearch-rails]:https://github.com/elastic/elasticsearch-rails
* [chewy]:https://github.com/toptal/chewy


Dependencies
-------

* ruby 2.0.0 or higher
* elasticsearch 1.0.15 or higher
* rails 4.2.0 or higher


Installation
-------

Add the following line to your Gemfile:

```ruby
gem 'easy_indexer', github: 'jmax/easy_indexer'
```

This will install the unreleased version of the gem which is recommendable given its early stage.


Basics
-------

There are three parts you will need to consider for this integration:

* mappings: they must be defined in JSON format and must be stored in config/indexes folder.

* indexes: they should be stored in app/indexes folder. An index is a class inherited from EasyIndexer::Engine.

* model integration: you need to define the way your models will update indexes. Despite the fact that this gem provides you with an out-of-the-box way to achieve this integration, you might need to consider a more tailor-made solution to cover your needs.


Usage
-------

Let's assume that your application has a Post model with the following attributes: title:string, body:text, published:boolean.

Let's define a mapping to index this model. To do so, you'll need add a posts.json into config/indexes folder.

```ruby
{
  "post": {
    "properties": {
      "title": { "type": "string", "index": "not_analyzed" },
      "body":  { "type": "string", "analyzer": "snowball" },
      "published": { "type": "boolean", "index": "not_analyzed" }
    }
  }
}
```

Now we can define an index to search on the published posts. Let's create a posts_index.rb file into app/indexes folder.


```ruby
class PostsIndex < EasyIndexer::Engine
  index_name "posts"
end
```

The first time you initalize an EasyIndexer instance, it will create an index using the mappings define in a file with the same name which must be stored in config/indexes folder.

EasyIndexer takes into account the environment where is running to name the indexes. So, if you're running the server on development mode, a "posts-development" index will be created.

This index can be used to execute a query on ElasticSearch using EasyIndex's request command. Despite the fact that the request method is accessible from any index instance, it's recommendable to add a method to define the query that you want to perform.


```ruby
class PostsIndex < EasyIndexer::Engine
  index_name "posts"

  def search(key)
    request({
      query: {
        filtered: {
          query:  { match: { "_all" => key } },
          filter: { { term: { published: true }  } }
        }
      }
    })
end
```

EasyIndex's requests will return an EasyIndex::Result object which will include the query results, a total count and an empty? flag to easily check whether the query has produced any matches or not.


```
> query = PostsIndex.new.search("to be or not to be")
> query.empty?
# true or false
> query.total_count
# 1
> query.results
# an array of serialized posts
```

The last piece you'll need to set up is the hook between the model and its index.

EasyIndexer will require your model to define an as_indexed_json method which will defined the way each record will be serialized before being store in the index.


```ruby
class Post < ActiveRecord::Base
  def as_indexed_json
    as_json
  end
end
```

EasyIndexer will also require your model to define an strategy for updating the index: when to store each record, when to remove it, and so on.

If your model doesn't need of a complex strategy, EasyIndexer provides with an out-of-the-box strategy to cover this issue.


```ruby
require "easy_indexer/active_record/callback"

class Post < ActiveRecord::Base
  update_index "posts"

  def as_indexed_json
    as_json
  end
end
```

The update_index macro will include the necessary callbacks to keep the index properly synchronized with the data.

This macro will also allow you to define a simple condition to give more control on each index update.


```ruby
require "easy_indexer/active_record/callback"

class Post < ActiveRecord::Base
  update_index "posts", "published?"

  def as_indexed_json
    as_json
  end
end
```

Now, the model will only update the index with published posts.


Running EasyIndexer on production environments
-------

By default, EasyIndexer will connect to an ElasticSearch node running on locahost:9200. This will be helpful for development and test environments, however it won't work on production environment where ElasticSearch node will be most likely on an external server.

To sort this out, you will need to define and env variable named ELASTICSEARCH_URL which will be use to specify the node location.


License
-------

EasyIndexer is released under the [MIT License]:http://www.opensource.org/licenses/MIT