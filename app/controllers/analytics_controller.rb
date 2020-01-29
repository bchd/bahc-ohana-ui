class AnalyticsController < ApplicationController
  respond_to :json
  def all
    @visits = Ahoy::Visit.all.to_json

    respond_with @visits
  end
end
