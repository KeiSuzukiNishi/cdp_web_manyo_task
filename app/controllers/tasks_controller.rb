class TasksController < ApplicationController
    def new
        @task = Task.new
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
        if params[:search][:title].present? && params[:search][:status].present?
          @tasks = @tasks.search_title(params[:search][:title]).search_status(params[:search][:status])
          flash[:notice] = t('notice.searched_title_status') 
        elsif params[:search][:title].present?
          @tasks = @tasks.search_title(params[:search][:title])
          flash[:notice] = t('notice.searched_title') 
        elsif params[:search][:status].present?
          @tasks = @tasks.search_status(params[:search][:status])
          flash[:notice] = t('notice.searched_status') 
        end
      end
    end

    def show
      @task = Task.find(params[:id])
    end
    
    def edit
      @task = Task.find(params[:id])
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
        params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end
end
