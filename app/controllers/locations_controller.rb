class LocationsController < ApplicationController
  include Cacheable
  

  def index
    # To enable Google Translation of keywords,
    # uncomment lines 9-10 and 18, and see documentation for
    # GOOGLE_TRANSLATE_API_KEY in config/application.example.yml.
    # translator = KeywordTranslator.new(params[:keyword], current_language, 'en')
    # params[:keyword] = translator.translated_keyword
    locations = Location.search(params).compact
    @filters = [params[:categories], params[:accessibility]].flatten
    @search = Search.new(locations, Ohanakapa.last_response, params)
    @keyword = params[:keyword]
    @main_category_selected = params[:main_category]

    # Populate the keyword search field with the original term
    # as typed by the user, not the translated word.
    # params[:keyword] = translator.original_keyword
    cache_page(locations) if locations.present?
  end

  def show
    id = params[:id].split('/').last
    @location = Location.get(id)

    if current_user.present?
      @current_user = current_user
      @current_user_id = current_user.id
      @favorite = current_user.favorites.any? do |f|
        f.resource_id == @location.id && f.resource_type == 'location'
      end
    else
      @favorite = false
      @current_user_id = 0
    end

    # @keywords = @location.services.map { |s| s[:keywords] }.flatten.compact.uniq
    @categories = @location.services.map { |s| s[:categories] }.flatten.compact.uniq
  end

  def get_subcategories_by_category
    permited = params.permit(:category_id)
    category_id = permited["category_id"]

    sub_cat_array = []
    sub_cat_array = helpers.subcategories_by_category(category_id)

    respond_to do |format|
      format.js { render :json => {sub_cat_array: sub_cat_array, category_title: helpers.category_filters_title(category_id)}.to_json }
    end
  end

end
