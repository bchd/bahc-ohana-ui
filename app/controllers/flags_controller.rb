class FlagsController < ApplicationController
  def new
    build_required_resources
  end

  def create
    flag_post_url = ENV['OHANA_API_ENDPOINT'] + '/flag'
    response = Faraday.post(flag_post_url, {flag: flag_params.to_json})

    if response.status == 200
      flash[:success] = 'Thank you for reporting this issue! We will reach out to you shortly.'
      redirect_to root_path
    else
      flash.now[:error] = 'Could not report this issue! Please try after sometime.'
      build_required_resources
      render :new
    end
  end

  private

  def flag_params
    params.require(:flag).permit(:resource_type, :resource_id, :description, :email)
  end

  def build_required_resources
    @resource_id = params[:resource_id] || params.dig(:flag, :resource_id)
    @resource_type = params[:resource_type] || params.dig(:flag, :resource_type)
    @resource = Location.get(@resource_id) if @resource_type == 'Location'

    @flag = Flag.new(
      email: params.dig(:flag, :email) || "",
      description: params.dig(:flag, :description) || ""
    )
  end
end
