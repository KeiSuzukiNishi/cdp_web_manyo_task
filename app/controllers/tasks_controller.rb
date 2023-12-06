class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :check_task_access, only: [:show, :edit]

    def new
        @task = Task.new
        @user_labels = current_user.labels
    end

    def create
        @task = Task.new(task_params)
        @task.user_id = current_user.id
        if @task.save
          redirect_to root_path, notice: t('notice.task_created')
        else
          render :new
        end
    end
    
    def index
      @tasks = current_user.tasks
      @tasks = @tasks.page(params[:page])
    
      if params[:sort_deadline_on] == "true"
        @tasks = @tasks.sorted_by_deadline
      elsif params[:sort_priority] == "true"
        @tasks = @tasks.sorted_by_priority
      else
        @tasks = @tasks.sorted_by_created_at
      end
    
      if params[:search].present?
        if params[:search][:title].present? && params[:search][:status].present? && params[:search][:label_id]
          @tasks = @tasks.search_title(params[:search][:title]).search_status(params[:search][:status]).search_labels(params[:search][:label_id])
          flash[:notice] = t('notice.searched_title_status_label') 
        elsif params[:search][:title].present? && params[:search][:status].present?
          @tasks = @tasks.search_title(params[:search][:title]).search_status(params[:search][:status])
          flash[:notice] = t('notice.searched_title_status') 
        elsif params[:search][:title].present? && params[:search][:label_id]
          @tasks = @tasks.search_title(params[:search][:title]).search_labels(params[:search][:label_id])
          flash[:notice] = t('notice.searched_title_label') 
        elsif params[:search][:status].present? && params[:search][:label_id]
          @tasks = @tasks.search_status(params[:search][:status]).search_labels(params[:search][:label_id])
          flash[:notice] = t('notice.searched_status_label') 
        elsif params[:search][:title].present?
          @tasks = @tasks.search_title(params[:search][:title])
          flash[:notice] = t('notice.searched_title') 
        elsif params[:search][:status].present?
          @tasks = @tasks.search_status(params[:search][:status])
          flash[:notice] = t('notice.searched_status') 
        elsif params[:search][:label_id].present?
          @tasks = @tasks.search_labels(params[:search][:label_id])
          flash[:notice] = t('notice.searched_label')
        end
      end
    end

    def show
      @task = Task.find(params[:id])
    end
    
    def edit
      @task = Task.find(params[:id])
      @user_labels = current_user.labels
    end

    def update
      @task = Task.find(params[:id])
      if @task.update(task_params)
        redirect_to task_path(@task.id), notice: t('notice.task_updated')
      else
        render :edit
      end
    end

    def destroy
      @task = Task.find(params[:id]) 
      if @task.destroy
        flash[:notice] = t('notice.task_destroyed')
      end
        redirect_to tasks_path
    end


      private
    
    def task_params
        params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
    end

    def set_task
      @task = Task.find(params[:id])
    end
  
    def check_task_access
      if @task.user != current_user
        flash[:alert] = "アクセス権限がありません"
        redirect_to tasks_path
      end
    end
end

