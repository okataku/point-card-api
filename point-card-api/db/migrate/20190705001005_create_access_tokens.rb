class CreateAccessTokens < ActiveRecord::Migration[5.2]
  def up
    create_table :access_tokens, id: :string do |t|
      t.timestamps
      t.bigint  :user_id, null: false
      t.text    :access_token, null: false
      t.integer :issued_at, null: false
      t.integer :expires_in, null: false
      t.integer :expire_time, null: false
      t.string  :refresh_token, null: false
      t.integer :refresh_token_expires_in, null: false
      t.integer :refresh_token_expire_time, null: false
      t.integer :refresh_count, null: false, default: 0
    end

    add_index :access_tokens, :refresh_token,
      unique: true,
      name: "ux__access_tokens__refresh_token"

    add_foreign_key :access_tokens, :users,
      name: "fk__access_tokens__users__user_id"
  end

  def down
    remove_index :access_tokens, name: "ux__access_tokens__refresh_token"
    remove_foreign_key :access_tokens, name: "fk__access_tokens__users__user_id"
    drop_table :access_tokens
  end
end
