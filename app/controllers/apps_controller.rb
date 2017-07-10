class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy]

  def index
    @apps = App.all
  end

  def show
  end

  def new
    @app = App.new
  end

  def create
    @app = App.new(app_params)

    if @app.save
      redirect_to @app, notice: 'Application was created'
    else
      render :new
    end
  end

  private

  def set_app
    @app = App.find(params[:id])
  end

  def app_params
    params.require(:app).permit(:name, :url)
  end
end