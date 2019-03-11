class UpdateAddressForClicks < ActiveRecord::Migration[5.2]
  def change
	Click.all.each do |c|
	  c.save
	end
  end
end
