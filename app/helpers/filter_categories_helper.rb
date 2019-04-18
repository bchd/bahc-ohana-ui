module FilterCategoriesHelper
  def filter_categories
    @filter_categories ||= Ohanakapa.categories.select(&:filter?).sort_by { |a| a[:taxonomy_id] }.map(&:to_h)
  end

  def filter_tree
    nested_hash = Hash[filter_categories.map { |e| [e[:id], e.merge(children: [])] }]
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
    filter_categories.select { |c| c[:taxonomy_id].include?(cat_family) && c[:filter_parent] }.first
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
      label_tag "category_#{category[:taxonomy_id]}", category[:name], class: 'parent-category-label'
    else
      label_tag "category_#{category[:taxonomy_id]}", category[:name], class: 'filter-category-label'
    end
  end
end
