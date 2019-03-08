module ApplicationHelper

	def full_short_link(sl)

      base_url = request.protocol + request.host_with_port + "/"
      # Default Base Url
      base_url = "https://sho-url.herokuapp.com/" if base_url == ""

      return base_url+sl
	end

end
