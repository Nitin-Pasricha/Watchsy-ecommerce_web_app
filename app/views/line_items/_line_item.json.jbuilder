json.extract! line_item, :id, :store_id, :user_id, :qty, :created_at, :updated_at
json.url line_item_url(line_item, format: :json)
