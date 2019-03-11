class UpdateAddressForClicks < ActiveRecord::Migration[5.2]
  def up
  	say_with_time "Updating Clicks..." do
		Click.all.each do |c|
		  c.save
		end
	end
  end
end
