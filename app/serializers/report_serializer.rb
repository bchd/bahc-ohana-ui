class ReportSerializer

  def initialize(report_attributes)
    @report_attributes = report_attributes
  end

  def serialize
    serialized_attributes = {}

    @report_attributes.each.with_index(1) do |attribute, index|
      serialized_attributes[index] = {
        prompt: Flag.get_report_attribute_label_for(attribute[0].to_sym),
        value: attribute[1],
      }
    end

    serialized_attributes
  end

end

