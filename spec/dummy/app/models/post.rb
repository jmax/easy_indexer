class Post < ActiveRecord::Base
  # Make sure you define as_indexed_json method for each indexed model
  def as_indexed_json
    as_json
  end
end
