class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body, null: false
      t.references :sender, null: false
      t.references :receiver, null: false


      t.timestamps null:false
    end
  end
end
