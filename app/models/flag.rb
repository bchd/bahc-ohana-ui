class Flag
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :description
  attr_accessor :report_attributes

  # Keep this method consistent with API app too (in Flag model)
  def self.report_attributes_schema
    [
      {
        name: :hours_location_contact_info_incorrect,
        label: "Hours, Location, Contact info incorrect"
      },
      {
        name: :the_service_listed_are_incorrect,
        label: "The services listed are incorrect"
      },
      {
        name: :the_eligibility_how_to_access_or_waht_to_bring_is_incorrect,
        label: "The eligibility, how to access, or what to bring is incorrect"
      },
      {
        name: :other,
        label: "Other"
      },
      {
        name: :employee_of_the_org,
        label: "I am employee of the org"
      }
    ]
  end

  def self.report_attributes_in_order
    Flag.report_attributes_schema.collect(&:values).transpose[0]
  end
  
  def self.get_report_attribute_label_for(attr)
    attribute = report_attributes_schema.find do |ar|
      ar[:name] == attr
    end

    attribute ? attribute[:label] : attr[0]
  end

end
