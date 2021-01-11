module FilterCategoriesHelper

  def fetch_categories
    @categories ||= Ohanakapa.categories
  end

  def filter_categories
    categories ||= Ohanakapa.categories.select(&:filter?).sort_by { |a| a[:taxonomy_id] }.map(&:to_h)
    filters = categories << accessibility_filters
    @filter_categories = filters.flatten
  end

  def categories_for_select
    fetch_categories if @categories.nil?
    @categories.select { |cat| cat[:depth] == 0  and cat[:type] == "service" }.flatten.uniq.map{ |cat| [cat.name, cat.id]}
  end

  def category_name_by_id(category_id)
    categories_for_select.select{ |x| x[1] == category_id.to_i }.first.first
  end

  def category_filters_title(category_id)
    category_name = category_name_by_id(category_id)
    "#{category_name} #{t('labels.filters.category_filter_title')}"
  end

  def subcategories_by_category(category_id)
    fetch_categories if @categories.nil?
    @categories.select { |cat| cat[:depth] == 1  and cat[:type] == "service" and cat[:parent_id] == category_id.to_i }.flatten.uniq.map{ |cat| [cat.name, cat.id] }
  end 

  def filter_tree
    filter_categories if @filter_categories.nil?
    nested_hash = Hash[@filter_categories.map { |e| [e[:id], e.merge(children: [])] }]
    # rubocop:disable Performance/HashEachMethods
    nested_hash.each do |_id, item|
      parent = nested_hash[item[:parent_id]]
      parent[:children] << item if parent
    end
    # rubocop:enable Performance/HashEachMethods
    nested_hash.select { |_id, item| item[:filter_parent] }.values
  end

  def nested_categories(categories)
    safe_join(cats_and_subcats(categories).map do |category, children|
      content_tag(:ul) do
        concat(content_tag(:li, class: class_name_for(category)) do
          checkbox_and_label(category)
          concat(nested_categories(children))
        end)
      end
    end)
  end

  def cats_and_subcats(categories)
    cats = []
    categories.each do |array|
      cats.push([array, array[:children]])
    end
    cats.sort_by { |e| e.first[:filter_priority] }
  end

  def parent_filter(category)
    cat_family = category[:taxonomy_id].split('-').first
    @filter_categories.select { |c| c[:taxonomy_id].include?(cat_family) && c[:filter_parent] }.first
  end

  def depth_offset(category)
    category ? category[:taxonomy_id].scan('-').count : 0
  end

  def class_name_for(category)
    return 'depth0 checkbox filter-category-label' if category[:filter_parent]

    "hide depth#{category[:depth] - depth_offset(parent_filter(category))} checkbox filter-category-item"
  end

  def checkbox_and_label(category)
    if category[:filter_parent]
      concat(header_div(category))
    else
      concat(checkbox_tag_for(category))
      concat(label_tag_for(category))
    end
  end

  def checkbox_tag_for(category)
    if category[:type] == 'accessibility'
      return check_box_tag(
        'accessibility[]',
        category[:query],
        @filters&.include?(category[:query]),
        id: "category_#{category[:taxonomy_id]}"
      )
    end
    check_box_tag(
      'categories[]',
      category[:id],
      @filters&.include?(category[:id].to_s),
      id: "category_#{category[:taxonomy_id]}"
    )
  end

  def dropdown_button
    content_tag(:div, class: 'filter-dropdown-closed') do
      fa_icon 'chevron-right'
    end
  end

  def header_div(category)
    content_tag(:div, class: "category_#{category[:taxonomy_id]} parent-category-label-container") do
      concat(label_tag_for(category))
      concat(dropdown_button)
    end
  end

  def label_tag_for(category)
    if category[:filter_parent]
      label_tag "category_#{category[:taxonomy_id]}", category[:name], class: 'parent-category-label', title: category[:name]
    else
      label_tag "category_#{category[:taxonomy_id]}", category[:name], class: 'filter-category-label', title: category[:name]
    end
  end

  def accessibility_filters
    [
      {
        :id=>518,
        :depth=>1,
        :taxonomy_id=>"99",
        :name=>"Accessibility",
        :parent_id=>nil,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>true,
        :filter_priority=>90
      },
      {
        :id=>519,
        :depth=>2,
        :taxonomy_id=>"99-01",
        :name=>"Interpreter For The Deaf Or TTY",
        :parent_id=>518,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>false,
        :filter_priority=>0,
        :query => 'deaf_interpreter'
      },
      {
        :id=>520,
        :depth=>2,
        :taxonomy_id=>"99-02",
        :name=>"Disabled Parking Available",
        :parent_id=>518,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>false,
        :filter_priority=>0,
        :query=> 'disabled_parking'
      },
      {
        :id=>521,
        :depth=>2,
        :taxonomy_id=>"99-03",
        :name=>"Ramp Available",
        :parent_id=>518,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>false,
        :filter_priority=>0,
         :query=> 'ramp'
      },
      {
        :id=>522,
        :depth=>2,
        :taxonomy_id=>"99-04",
        :name=>"Information In Braille Or Audio Format",
        :parent_id=>518,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>false,
        :filter_priority=>0,
        :query=> 'tape_braille'
      },
      {
        :id=>523,
        :depth=>2,
        :taxonomy_id=>"99-05",
        :name=>"Wheelchair Accessible",
        :parent_id=>518,
        :type=>"accessibility",
        :filter=>true,
        :filter_parent=>false,
        :filter_priority=>0,
        :query=> 'wheelchair'
      }]
  end
end

