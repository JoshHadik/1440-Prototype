# Responsible for collecting information and rendering views for the basic activity log actions including new, show, edit, create, update, and destroy.
class ActivityLogsController < ApplicationController
  before_action :authenticate_user!

  before_action :only_allow_owner!, only: [
    :show, :edit, :update, :destroy
  ]

  def new
    @activity_log = new_activity_log
  end

  def show
    @activity_log = current_activity_log
  end

  def edit
    @activity_log = current_activity_log
  end

  def create
    @activity_log = new_activity_log(with: activity_log_params)

    respond_to do |format|
      if current_user.save_activity_log(@activity_log)
        format.html do
          redirect_to @activity_log, notice: 'Activity log was successfully created.'
        end
      else
        format.html do
          render :new
        end
      end
    end
  end

  def update
    @activity_log = current_activity_log

    respond_to do |format|
      if @activity_log.update(activity_log_params)
        format.html do
          redirect_to @activity_log, notice: 'Activity log was successfully updated.'
        end
      else
        format.html do
          render :edit
        end
      end
    end
  end

  def destroy
    @activity_log = current_activity_log

    @activity_log.destroy
    respond_to do |format|
      format.html do
        redirect_to root_path, notice: "Activity log was successfully deleted"
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_log_params
    params.require(:activity_log).permit(:started_at, :ended_at, :label)
  end

  # Check that current user is owner of activity log or redirect somewhere else.
  def only_allow_owner!
    unless current_activity_log.belongs_to? current_user
      redirect_to root_path
    end
  end

  # Return current activity log based on the URL.
  def current_activity_log
    ActivityLog.find(params[:id])
  end

  # Create a new activity log with optional starting attributes.
  def new_activity_log(with: {})
    ActivityLog.new(with)
  end
end
