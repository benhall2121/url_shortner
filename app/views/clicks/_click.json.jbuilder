json.extract! click, :id, :ip_address, :url_id, :created_at, :updated_at
json.url click_url(click, format: :json)
