class CreateUsers < ActiveRecord::Migration[8.0]
  create_enum :user_role, [ "member", "coach" ]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.enum :role, enum_type: "user_role", default: "member", null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
