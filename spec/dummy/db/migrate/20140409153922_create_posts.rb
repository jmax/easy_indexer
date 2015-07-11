class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :body
      t.integer :points
      t.boolean :published, default: true

      t.timestamps
    end
  end
end
