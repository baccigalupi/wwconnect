class CreateAuthenticationsAndProfiles < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :uid, unique: true, null: false
      t.string :email, unique: true, null: false

      t.string :provider

      t.string :token
      t.datetime :expires_at

      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :location
      t.string :image
      t.string :linkedin_url

      t.timestamps
    end

    create_table :roles do |t|
      t.integer :authentication_id
      t.string :type

      t.timestamps
    end

    add_index :roles, [:authentication_id, :type], unique: true
  end
end
