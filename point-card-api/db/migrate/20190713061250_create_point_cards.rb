class CreatePointCards < ActiveRecord::Migration[5.2]
  def up
    create_table :point_cards do |t|
      t.timestamps
      t.string :name, null: false
      t.string :display_name, null: false
      t.text :description
      t.integer :issue_count, null: false, default: 0
      t.string :image_url
    end

    add_index :point_cards, :name, unique: true, name: "ux__point_cards__name"
  end

  def down
    remove_index :point_cards, name: "ux__point_cards__name"
    drop_table :point_cards
  end
end
