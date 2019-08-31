class CreatePointCardCollaborators < ActiveRecord::Migration[5.2]
  def up
    create_table :point_card_collaborators do |t|
      t.timestamps
      t.bigint :point_card_id, null: false
      t.bigint :user_id, null: false
      t.string :permission, null: false
    end

    add_foreign_key :point_card_collaborators, :point_cards,
      name: "fk__point_card_collaborators__point_cards__point_card_id"

    add_foreign_key :point_card_collaborators, :users,
      name: "fk__point_card_collaborators__users__user_id"

    add_index :point_card_collaborators, [:point_card_id, :user_id],
      unique: true, name: "ux__point_card_collaborators__point_card_id__user_id"

    add_index :point_card_collaborators, [:user_id],
      name: "ix__point_card_collaborators__user_id"
  end

  def down
    remove_foreign_key :point_card_collaborators, name: "fk__point_card_collaborators__point_cards__point_card_id"
    remove_foreign_key :point_card_collaborators, name: "fk__point_card_collaborators__users__user_id"
    remove_index :point_card_collaborators, name: "ux__point_card_collaborators__point_card_id__user_id"
    remove_index :point_card_collaborators, name: "ix__point_card_collaborators__user_id"
    drop_table :point_card_collaborators
  end
end
