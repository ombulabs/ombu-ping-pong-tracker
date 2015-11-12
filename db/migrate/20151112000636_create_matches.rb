class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.datetime :played_at
      t.integer :challenger_id
      t.integer :opponent_id
      t.string :challenger_message
      t.string :opponent_message

      t.timestamps null: false
    end
  end
end
