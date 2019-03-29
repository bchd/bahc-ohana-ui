module FilterCategoriesHelper

  @@filter_categories = Ohanakapa.categories.select(&:filter?).sort_by { |a| a[:taxonomy_id] }.map(&:to_h)

  def filter_tree
    nested_hash = Hash[@@filter_categories.map { |e| [e[:id], e.merge(children: [])] }]
    nested_hash.each do |id, item|
      parent = nested_hash[item[:parent_id]]
      parent[:children] << item if parent
    end
    nested_hash.select { |id, item| item[:filter_parent] }.values
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
    cats
  end

  def parent_filter(category)
    cat_family = category[:taxonomy_id].split('-').first
    @@filter_categories.select { |c| c[:taxonomy_id].include?(cat_family) && c[:filter_parent] }.first
  end

  def depth_offset(category)
    category ? category[:taxonomy_id].scan("-").count : 0
  end

  def class_name_for(category)
    return 'depth0 checkbox' if category[:filter_parent]

    "hide depth#{category[:depth] - depth_offset(parent_filter(category))} checkbox"
  end

  def checkbox_and_label(category)
    if category[:filter_parent]
      concat(label_tag_for(category))
      concat(checkbox_tag_for(category))
    else
      concat(checkbox_tag_for(category))
      concat(label_tag_for(category))
    end
  end

  def checkbox_tag_for(category)
    check_box_tag(
      "categories",
      category[:id],
      false,
      id: "category_#{category[:taxonomy_id]}"
    )
  end

  def label_tag_for(category)
    label_tag "category_#{category[:taxonomy_id]}", category[:name]
  end

end
