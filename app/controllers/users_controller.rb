class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users/appply.json
  #
  # @param name
  # @param gender
  # @param phone
  # @param department_id
  # @param js_code
  # @param userInfo
  # @return
  def appply
    if params[:id]

    else
      if params[:js_code]
        @openid = User.get_openid(params[:js_code])
        p @openid
        if @openid && User.find_by(openid: @openid)
          render :json => {"errcode"=>40163, "errmsg"=>"user has applyed, hints: [ req_id: n.0607th54 ]"}, :status => 200
        elsif @openid
          User.create!(user_apply_params)
          render :json => {"errcode"=>'20200', "errmsg"=>"success"}, :status => 200
        else
          render :json => {"errcode"=>'20404', "errmsg"=>"no openid"}, :status => 200
        end
      end
    end
  end

  # GET /users/applies.json
  def applies

  end


  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_apply_params
      {
        name: params[:name],
        gender: params[:gender],
        phone: params[:phone],
        openid: @openid,
        department_id: params[:department_id],
        remark: params[:userInfo],
        avatarUrl: params[:userInfo][:avatarUrl],
      }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :code, :nickName, :phone, :openid, :gender, :avatarUrl, :department_id, :remark)
    end
end
