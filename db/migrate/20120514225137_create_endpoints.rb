class CreateEndpoints < ActiveRecord::Migration
  def change
    create_table :endpoints do |t|
      t.string :proxy_url, :limit => 256

      t.timestamps
    end
  end
end
