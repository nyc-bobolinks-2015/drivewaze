class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user,null:false
      t.integer :reviewable_id
      t.string :reviewable_type

      t.text :review_body,null:false
      t.integer :review_score,null:false

      t.timestamps null:false
    end
  end
end
