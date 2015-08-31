require "easy_indexer/active_record/callback"

class Post < ActiveRecord::Base
  update_index "posts"
  # Make sure you define as_indexed_json method for each indexed model
  def as_indexed_json
    as_json
  end
end
