class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :post, index: true, foreign_key: true, null: false
      t.references :hashtag, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
