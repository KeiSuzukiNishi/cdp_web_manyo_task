class Admin::UsersController < ApplicationController
    before_action :admin_required

    def index
        @users = User.all.includes(:tasks)
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        #　@user.admin = params[:user][:admin] == 'true'
        if @user.save
            # log_in(@user)
            redirect_to admin_users_path, notice: t('notice.admin_user_created')
        else
            render :new
        end
    end

    def show
        @user = User.find(params[:id])
        @tasks = @user.tasks
    end

    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        new_admin_value = params[:user][:admin] == 'false'
        Rails.logger.debug "new_admin_value: #{new_admin_value}"
        Rails.logger.debug "Current admin count: #{User.where(admin: true).count}"
      
        if new_admin_value && User.where(admin: true).count <= 1
          flash[:alert] = t('alert.last_admin_update')
          redirect_to admin_users_path
          return
        end
      
        if @user.update(user_params.merge(admin: new_admin_value))
          flash[:notice] = t('notice.admin_user_updated')
          redirect_to admin_users_path
        else
          render :edit
        end
      end

      #user = User.new(name: "admintest8", email: "admintest8@test.com", password: "admintest8", password_confirmation: "admintest8", admin: true)

    def destroy
    @user = User.find(params[:id])
    
    if @user.destroy_with_tasks
        flash[:success] = t('notice.admin_user_destroyed')
    else
        flash[:notice] = t('notice.')
    end

    redirect_to admin_users_path
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
end