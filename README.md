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

On the other hand, in the Pets model, you have to add the following three things:

```
include EasyIndexer::Callbacks
```
to include the after_save and before_destroy callbacks,

```
def index
  @index ||= PetsIndex.new
end
```
to perform the indexation, and

```
def to_indexed_json
  {
    name: name,
    published_on: published_on,
    removed: removed
  }.to_json
end
```
to tell which attributes will be returned in a search.

How to index
------------

It is recommended to write a rake task to perform the indexation.
From within the task

Instantiate a PetsIndex object
```
indexer = PetsIndex.new
```

Call the rebuild! method to clean the index.
```
indexer.rebuild!
```

Iterate over your Pets model, and call the pets
```
<--- Example using ActiveRecord ---->
Pets.all.find_in_batches(batch_size: 100) do |pets|
  indexer.source.import pets
end

<--- Example using Mongoid ---->
indexer.source.import Pets.all
```

Finally call
```
indexer.source.refresh
```

And you are good to go!

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

To perform a search, you only have to type
```
index = PetsIndex.new
index.match 'Chow Chow'
```
Internally, the match method perform a match: _all query.


Alternatively, if you want to retrieve all the pets, type
```
index = PetsIndex.new
index.all
```

In case you need to produce a randomly ordered results list, you can try:

```
index = PetsIndex.new
index.all.randomly_ordered
```

To save all the results out of a search, chain the results method like so
```
pets = PetsIndex.all.results
or
pets = PetsIndex.match('Chow Chow').results
or
pets_randomly_ordered = PetsIndex.all.randomly_ordered.results
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
