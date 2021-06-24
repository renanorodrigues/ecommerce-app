module Admin::V1
  class UsersController < ApiController
    before_action :set_user, only: [:update, :destroy]

    def index
      @users = User.all
    end

    def create
      @user = User.new(user_params)
      save_user!
    end

    def update
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user.destroy!
    rescue
      render_error(fields: @user.errors.messages, status: :no_content)
    end

    private

    def user_params 
      return {} unless params.has_key?(:user)
      params.require(:user).permit(:id, :name, :email, :password, :profile)
    end

    def set_user
      @user = User.find_by_id(params[:id])
    end

    def save_user!
      @user.save!
      render :show
    rescue
      render_error(fields: @user.errors.messages)
    end
  end
end
