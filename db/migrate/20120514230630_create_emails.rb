class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :endpoint
      
      t.timestamps
    end
    add_index :emails, [:endpoint_id, :created_at]
  end
end
