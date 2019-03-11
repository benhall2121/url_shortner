class AddLocationToClick < ActiveRecord::Migration[5.2]
  def change
    add_column :clicks, :address, :string, :default => ""
    add_column :clicks, :city, :string, :default => ""
    add_column :clicks, :state, :string, :default => ""
    add_column :clicks, :zip, :string, :default => ""

    add_column :clicks, :latitude, :float, :default => ""
    add_column :clicks, :longitude, :float, :default => ""
  end
end
