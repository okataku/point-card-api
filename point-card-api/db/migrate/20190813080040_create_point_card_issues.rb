class CreatePointCardIssues < ActiveRecord::Migration[5.2]
  def up
    create_table :point_card_issues do |t|
      t.timestamps
      t.bigint :user_id, null: false
      t.bigint :point_card_id, null: false
      t.integer :no, null: false
      t.integer :point, null: false, default: 0
    end

    add_foreign_key :point_card_issues, :users,
      name: "fk__point_card_issues__users__user_id"

    add_foreign_key :point_card_issues, :point_cards,
      name: "fk__point_card_issues__point_cards__point_card_id"

    add_index :point_card_issues, [:user_id, :point_card_id],
      unique: true, name: "ux__point_card_issues__user_id__point_card_id"

    add_index :point_card_issues, [:point_card_id, :no],
      unique: true, name: "ux__point_card_issues__point_card_id__no"
  end

  def down
    remove_foreign_key :point_card_issues, name: "fk__point_card_issues__users__user_id"
    remove_foreign_key :point_card_issues, name: "fk__point_card_issues__point_cards__point_card_id"
    remove_index :point_card_issues, name: "ux__point_card_issues__user_id__point_card_id"
    remove_index :point_card_issues, name: "ux__point_card_issues__point_card_id__no"
    drop_table :point_card_issues
  end
end
