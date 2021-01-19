class Location
  # Calls the search endpoint of the Ohana API.
  #
  # @param params [Hash] Search options.
  # @return [Array] Array of locations.
  def self.search(params = {})
    search_params = params.dup
    if !params["categories"]
      search_params["categories"] = params["main_category_id"]
    else
      search_params["categories"] = params["categories_ids"]
    end
    Ohanakapa.search('search', search_params)
  end

  # Calls the locations/{id} endpoint of the Ohana API.
  # Fetches a single location by id.
  #
  # @param id [String] Location id.
  # @return [Sawyer::Resource] Hash of location details.
  def self.get(id)
    Ohanakapa.location(id)
  end
end
