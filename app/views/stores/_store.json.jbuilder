json.extract! store, :id, :product_id, :name, :category, :description, :gender, :colour, :price, :created_at, :updated_at
json.url store_url(store, format: :json)
