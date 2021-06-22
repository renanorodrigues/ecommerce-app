module Admin::V1
  class SystemRequirementsController < ApiController
    before_action :set_system_requirement, only: [:update, :destroy]

    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirement = SystemRequirement.new(system_requirement_params)
      system_requirement_save!
    end

    def update
      @system_requirement.attributes = system_requirement_params
      system_requirement_save!
    end

    def destroy
      @system_requirement.destroy!
    rescue
      render_error(fields: @system_requirement.errors.messages, status: :no_content)
    end

    private
    
    def system_requirement_params
      return {} unless params.has_key?(:system_requirements)
      params.require(:system_requirements).permit(:id, :name, :storage, :processor, :memory, :video_board, :operational_system, :game_id)
    end

    def system_requirement_save!
      @system_requirement.save!
      render :show
    rescue
      render_error(fields: @system_requirement.errors.messages)
    end

    def set_system_requirement
      @system_requirement = SystemRequirement.find_by_id(params[:id])
    end
  end
end
