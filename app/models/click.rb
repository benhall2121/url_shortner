class Click < ApplicationRecord
	belongs_to :url

	geocoded_by :ip_address do |obj,results|
        if geo = results.first
            #customize as you want
            obj.address  = geo.address
            obj.city    = geo.city
            obj.zip     = geo.postal_code
            obj.state   = geo.state
            obj.latitude   = geo.latitude
            obj.longitude   = geo.longitude
        end
    end
	after_validation :geocode

    def full_address
      add = self.address if !self.address.nil?
      add += " " if !add.blank?
      add += self.city if !self.city.nil?
      add += ", " if !add.blank? && !self.city.blank?
      add += self.state if !self.state.nil?
      add += " " if !add.blank?
      add += self.zip if !self.zip.nil?
    end	

    def google_map_link
    	self.latitude.nil? ? "" : "https://maps.google.com/maps?q="+self.latitude.to_s+","+self.longitude.to_s+"&hl=es;z=14&amp;" 
    end
end
