class Click < ApplicationRecord
	belongs_to :url

	geocoded_by :ip_address
	after_validation :geocode, :if => :ip_address_changed?
end
