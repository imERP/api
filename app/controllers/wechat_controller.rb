class WechatController < ActionController::Base
  protect_from_forgery with: :null_session

  # GET /wechat/users/list.json
  def list
    if params[:id]
      @user = User.find_by(id: params[:id])
      if @user.is_admin?
        @users = User.approved
        render :json => {"errcode": 20200, "errmsg"=>"success", data: @users.map { |e| e.base_info  }}, :status => 200
      else
        @users = @user.department_users
        render :json => {"errcode": 20200, "errmsg"=>"success", data: @users.map { |e| e.base_info  }}, :status => 200
      end
    else
        render :json => {"errcode": 20501, "errmsg"=>"no ability"}, :status => 200
    end
  end

  # POST /wechat/login.json
  # 判断是否已登录
  # @param js_code
  def login
    if params[:js_code]
      @openid = User.get_openid(params[:js_code])
      # p @openid
      if @openid && @user = User.find_by(openid: @openid)
        render :json => {"errcode": 20200, "errmsg"=>"user exists", user:@user.base_info}, :status => 200
      elsif @openid
        render :json => {"errcode": 20200, "errmsg"=>"openid exists"}, :status => 200
      else
        render :json => {"errcode": 20404, "errmsg"=>"no openid"}, :status => 200
      end
    end
  end

  # POST /wechat/users/update.json
  # 更新信息
  # @param id
  # @param name
  # @param gender
  # @param phone

  def update
    if params[:id]
      @user = User.find_by(id: params[:id])
      if @user
         if @user.update(update_params)
            render :json => {"errcode": 20200, "errmsg"=>"operate success", user:@user.base_info}, :status => 200
         else
            render :json => {"errcode": 20500, "errmsg"=>"server errors"}, :status => 200
         end
      else
        render :json => {"errcode": 20404, "errmsg"=>"no openid"}, :status => 200
      end
    end
  end

  # POST /wechat/users/delete.json
  # 删除信息
  # @param id

  def delete
    if params[:id]
      @user = User.find_by(id: params[:id])
      if @user.destroy
        render :json => {"errcode": 20200, "errmsg"=>"operate success"}, :status => 200
      else
        render :json => {"errcode": 20400, "errmsg"=>"server error"}, :status => 200
      end
    end
  end

  # POST /wechat/users/appply.json
  #
  # @param name
  # @param gender
  # @param phone
  # @param department_id
  # @param js_code
  # @param userInfo
  # @return

  # POST /wechat/users/appply/appply.json
  # 通过或拒绝申请, 通过状态/state改为1 拒绝删除该申请
  # @param id
  # @param approved true / false
  def appply
    if params[:id]
        @user = User.find(params[:id])
        if @user && params[:approved] == true
            @user.update(state:1)
            render :json => {"errcode": 20200, "errmsg"=>"operate success"}, :status => 200
        elsif @user && params[:approved] == false
            @user.update(state:0)
            render :json => {"errcode": 20200, "errmsg"=>"operate success"}, :status => 200
        elsif @user && params[:approved] == 2
            @user.update(state:2)
            render :json => {"errcode": 20200, "errmsg"=>"operate success"}, :status => 200
        elsif @user
            render :json => {"errcode": 20500, "errmsg"=>"approved not ok"}, :status => 200
        else
            render :json => {"errcode": 20404, "errmsg"=>"no this user"}, :status => 200
        end
    else
      if params[:js_code]
        @openid = User.get_openid(params[:js_code])
        # p @openid
        if @openid && User.find_by(openid: @openid)
          render :json => {"errcode": 40163, "errmsg"=>"user has applyed"}, :status => 200
        elsif @openid
          @user = User.create!(user_apply_params)
          @user.update(is_admin: true)
          render :json => {"errcode": 20200, "errmsg"=>"success"}, :status => 200
        else
          render :json => {"errcode": 20404, "errmsg"=>"no openid"}, :status => 200
        end
      end
    end
  end

  # GET /wechat/users/applies.json
  def applies
    @users = User.applying
    render :json => {"errcode": 20200, "errmsg"=>"success", data: @users.map { |e| e.base_info  }}, :status => 200
  end

  private
  def update_params
    {
      name: params[:name],
      gender: params[:gender],
      phone: params[:phone],
    }
  end

    def user_apply_params
      {
        name: params[:name],
        gender: params[:gender],
        phone: params[:phone],
        openid: @openid,
        department_id: params[:department_id],
        remark: params[:userInfo],
        nickName: params[:userInfo][:nickName],
        avatarUrl: params[:userInfo][:avatarUrl],
      }
    end


end
