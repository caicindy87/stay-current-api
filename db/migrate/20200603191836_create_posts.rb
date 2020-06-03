class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :text
      t.string :image
      t.integer :upvotes
      t.integer :downvotes
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
