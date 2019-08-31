class CreatePoints < ActiveRecord::Migration[5.2]
  def up
    create_table :points do |t|
      t.timestamps
      t.bigint :point_card_issue_id, null: false
      t.bigint :issued_by
      t.datetime :issued_at, null: false
      t.integer :total, null: false, defualt: 0
      t.integer :point, null: false, defualt: 0
      t.boolean :expired
      t.integer :expires_in
      t.datetime :expired_at
      t.integer :remaining_point
    end

    add_foreign_key :points, :users,
      column: :issued_by,
      primary_key: :id,
      name: "fk__points__users__issued_by"
    
    add_foreign_key :points, :point_card_issues,
      name: "fk__points__point_card_issues__point_card_issue_id"

    add_index :points, [:point_card_issue_id], name: "ix__points__point_card_issue_id"
  end

  def down
    remove_foreign_key :points, name: "fk__points__users__issued_by"
    remove_foreign_key :points, name: "fk__points__point_card_issues__point_card_issue_id"
    remove_index :points, name: "ix__points__point_card_issue_id"
    drop_table :points
  end
end
