# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


if Url.all.first.nil?
  ips = ["123.456.789.123", "333.456.444.123", "80.456.22.123", "55.12.33.123", "672.12.789.2"]

  f_url = Url.create(long_url: "http://www.google.com", short_link: "http://goo.com/gle")

  s_url = Url.create(long_url:"http://www.yahoo.com", short_link:"http://yah.com/oo")


  30.times do
    c = Click.new(ip_address: ips.sample, url_id:f_url.id)
    c.created_at = Date.today-rand(10000)
    c.save

    c2 = Click.new(ip_address: ips.sample, url_id:s_url.id)
    c2.created_at = Date.today-rand(10000)
    c2.save
  end 


end

