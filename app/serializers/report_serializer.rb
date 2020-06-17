class ReportSerializer

  def initialize(report_attributes)
    @report_attributes = report_attributes
  end

  def serialize
    serialized_attributes = {}

    @report_attributes.each_slice(2).with_index(1) do |sliced_attributes, index|
      selected_attribute = sliced_attributes[0]
      input_attribute = sliced_attributes[1]

      selected_attribute_key = selected_attribute[0]
      selected_attribute_value = selected_attribute[1]

      input_attribute_key = input_attribute[0]
      input_attribute_value = input_attribute[1]

      serialized_attributes[index] = {
        prompt: Flag.get_report_attribute_label_for(input_attribute_key),
        selected: selected_attribute_value,
        value: input_attribute_value
      }
    end

    serialized_attributes
  end

end

