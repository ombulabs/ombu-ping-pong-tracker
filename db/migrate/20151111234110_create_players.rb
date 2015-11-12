class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :user_id
      t.string :username
      t.string :image_url

      t.timestamps null: false
    end
  end
end
