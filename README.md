EasyIndexer
=======

Easy ElasticSearch indexer powered by Tire.

Dependencies
-------

 - Ruby 2.0.0-p247
 - Bundler 1.3.5
 - Tire

Usage
-------

Add the gem to your application, like this:

```
gem 'easy_indexer', github: 'jmax/easy_indexer'
```

Then you just need to create an index, just like the following class:

```
class PetsIndex < EasyIndexer::Engine
  index_name "pets"
end
```

We recommend to store these indexes in the same folder (app/indexes would be
just fine).

This engine will require some mappings to be setup. These files will need to have
the same name as the index name.

For example, if the PetsIndex sets up a "pets" index_name, its mappings must
be stored in the file config/indexes/pets.json with the following structure:

```
{
  "mappings": {
    "document": {
      "properties": {
        "id":           { "type": "string", "index": "not_analyzed" },
        "name":         { "type": "string", "analyzer": "snowball" },
        "published_on": { "type": "date", "index": "not_analyzed" },
        "removed":      { "type": "string", "index": "not_analyzed" }
      }
    }
  }
}
```

Goodies
-------

EasyIndexer provides some helpers to easily execute searches in order to test
the setup.

```
class PetsIndex < EasyIndexer::Engine
  include EasyIndexer::Helpers
  index_name "pets"
end
```

You'll be able to perform a search like this:

```
index = PetsIndex.new
index.all.results
```

In case you need to produce a randomly ordered results list, you can try:

```
index = PetsIndex.new
index.all.randomly_ordered.results
```

Scopes
-------

EasyIndexer provides a mechanism to create scopes. For example:

```
class PetsIndex < EasyIndexer::Engine
  index_name "pets"

  scope :dogs, type: "Dogs"
end
```

Then, you'll be able to list:

```
index = PetsIndex.new
index.all.dogs.results
```
