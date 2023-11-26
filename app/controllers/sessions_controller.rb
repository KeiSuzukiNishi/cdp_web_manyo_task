class SessionsController < ApplicationController
    skip_before_action :login_required, only: [:new, :create]

    def new
    end

    def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in(user)
        flash[:alert] = t('notice.logined')
        redirect_to root_path
      else
        flash.now[:danger] = t('notice.wrong_email_password')
        render :new
      end
    end

    def destroy
      session.delete(:user_id)
      flash[:notice] = t('notice.logout')
      redirect_to new_session_path
    end
end