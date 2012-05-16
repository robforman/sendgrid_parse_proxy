class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :endpoint

      t.string :message_id, :limit => 256
      t.string :from, :limit => 256
      t.string :to, :limit => 256
      t.string :subject, :limit => 256
      t.boolean :sent, :null => false
      t.text :error_message

      t.timestamps
    end
    add_index :emails, [:endpoint_id, :created_at]
  end
end
