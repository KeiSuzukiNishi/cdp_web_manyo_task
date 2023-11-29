class LabelsController < ApplicationController

    def index
        @labels = Label.all
        @labels = Label.all.page(params[:page])
    end

    def new
        @label = Label.new
    end

    def create
        @label = Label.new(label_params)
        if @label.save
            redirect_to labels_path
        else
            render :new
        end
    end
    
    def edit
        @label = Label.find(params[:id])
    end

    def update
        @label = Label.find(params[:id])
        if @label.update(label_params)
          redirect_to labels_path, notice: t('notice.label_updated')
        else
          render :edit
        end
    end


    def show
        @label = Label.find(params[:id])
    end

    def destroy
        @label = Label.find(params[:id]) 
        if @label.destroy
            flash[:notice] = t('notice.label_destroyed')
        end
        redirect_to labels_path
    end

    private
    
    def label_params
        params.require(:label).permit(:name)
    end

end
