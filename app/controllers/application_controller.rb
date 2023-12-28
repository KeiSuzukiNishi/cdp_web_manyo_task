class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required
  # before_action :logout_required, only: [:new, :create]

  private

  def login_required
    unless current_user
      flash[:alert] = t('notice.login_required')
      redirect_to new_session_path
    end
  end

  def admin_required
    unless current_user&.admin?
      flash[:alert] = t('notice.admin_cannot_access')
      redirect_to tasks_path
    end
  end

  def logout_required
    if logged_in?
    # if (controller_name == 'sessions' && action_name == 'new' || controller_name == 'users' && action_name == 'new')
      flash[:alert] = t('notice.logout_required')
      redirect_to tasks_path
    end
  end
  
  def is_task_registration_action?
    controller_name == 'tasks' && action_name == 'new' && request.post?
  end

  def is_admin_controller?
    controller_path.starts_with?('admin/')
  end
end