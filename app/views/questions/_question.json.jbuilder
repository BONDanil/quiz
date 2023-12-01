json.extract! question, :id, :text, :answer, :category_id, :user_id, :created_at, :updated_at
json.url question_url(question, format: :json)
