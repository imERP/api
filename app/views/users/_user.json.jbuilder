json.extract! user, :id, :name, :code, :nickName, :phone, :openid, :gender, :avatarUrl, :department_id, :remark, :created_at, :updated_at
json.url user_url(user, format: :json)
