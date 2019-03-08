class CreateClicks < ActiveRecord::Migration[5.2]
  def change
    create_table :clicks do |t|
      t.string :ip_address
      t.integer :url_id

      t.timestamps
    end
  end
end
