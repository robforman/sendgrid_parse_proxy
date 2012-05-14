class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.references :email

      t.string :key, :limit => 256
      t.text :value

      t.timestamps
    end
    add_index :params, :email_id
  end
end
