class User < ApplicationRecord
  belongs_to :department
  before_create :generate_code

  scope :applying, -> { where(state:0)}
  scope :approved, -> { where(state:1)}

  # APP_ID="wx3e69716c35f6f964"
  # APP_SECRET="aa84ef2be73938f00155f88c31387f4d"

  APP_ID="wx8ead5086e1e601dc"
  APP_SECRET="9ea72235423ebc16aea68070bd4f752e"


  def generate_code
    self.code = self.class.last.code.succ rescue "800801"
  end

  def department_users
    department.users.approved
  end

  # User.get_openid
  def self.get_openid(js_code="071OBWZq0ocasq1568Zq0CJEZq0OBWZy")
	url = URI("https://api.weixin.qq.com/sns/jscode2session?appid=#{APP_ID}&secret=#{APP_SECRET}&js_code=#{js_code}&grant_type=authorization_code")
	res = Net::HTTP.get(url)
	return JSON.parse(res)["openid"]
  end

  def base_info
    {
      id: id,
      name: name,
      code: code,
      nickName: nickName,
      phone: phone,
      gender: gender,
      avatarUrl: avatarUrl,
      department_id: department_id,
      department: (department.name rescue ''),
      remark: remark,
      state: state,
      is_admin: is_admin,
    }
  end
end
