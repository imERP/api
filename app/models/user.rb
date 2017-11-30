class User < ApplicationRecord
  belongs_to :department
  before_create :generate_code

  # APP_ID="wx3e69716c35f6f964"
  # APP_SECRET="aa84ef2be73938f00155f88c31387f4d"

  APP_ID="wx12639acd965bfb76"
  APP_SECRET="45af01e66a8e03afb4baa7722779cd18"






  def generate_code
    self.code = self.class.last.code.succ rescue "800801"
  end



  def self.get_openid(js_code="011tObHv1bEJL90RazHv1FyfHv1tObHJ")
	url = URI("https://api.weixin.qq.com/sns/jscode2session?appid=#{APP_ID}&secret=#{APP_SECRET}&js_code=#{js_code}&grant_type=authorization_code")
	res = Net::HTTP.get(url)
	return JSON.parse(res)["openid"]
  end
end
