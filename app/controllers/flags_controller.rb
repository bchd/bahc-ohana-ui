class FlagsController < ApplicationController
  def new
    @resource_id = params[:resource_id]
    @resource_type = params[:resource_type]
    if @resource_type ==-'Location'
      @resource = Location.get(@resource_id)
    end
    @flag = Flag.new
  end

  def create
    flag_post_url = ENV['OHANA_API_ENDPOINT'] + '/flag'
    response = Faraday.post(flag_post_url, {flag: flag_params.to_json})
    if response.status == 200
      flash[:success] = 'Thank you for reporting this issue! We will reach out to you shortly.'
      redirect_to root_path
    end
  end

  private

  def flag_params
    params.require(:flag).permit(:resource_type, :resource_id, :description, :email)
  end
end
