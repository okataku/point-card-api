class CreatePointCollectUnits < ActiveRecord::Migration[5.2]
  def up
    create_table :point_collect_units do |t|
      t.timestamps
      t.bigint :point_card_id, null: false
      t.string :name, null: false
      t.text :description
      t.integer :point, null: false, default: 0
    end

    add_foreign_key :point_collect_units, :point_cards,
      name: "fk__point_collect_units__point_cards__point_card_id"
  end

  def down
    remove_foreign_key :point_collect_units, name: "fk__point_collect_units__point_cards__point_card_id"
    drop_table :point_collect_units
  end
end
