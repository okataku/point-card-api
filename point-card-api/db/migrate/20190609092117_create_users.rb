class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.timestamps
      t.boolean :admin, null: false, default: false
      t.string :uid, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name
      t.string :gender
      t.date :date_of_birth
    end

    add_index :users, :uid, unique: true, name: 'ux__users__uid'
    add_index :users, :email, unique: true, name: 'ux__users__email'
  end

  def down
    remove_index :users, name: "ux__users__uid"
    remove_index :users, name: "ux__users__email"
    drop_table :users
  end
end
