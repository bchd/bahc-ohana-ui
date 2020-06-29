class Flag
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :description
  attr_accessor :report_attributes

  def self.report_attributes_schema
    [
      {
        name: :hours_location_contact_info_incorrect,
        label: "The hours, location, or contact information is incorrect."
      },
      {
        name: :the_service_listed_are_incorrect,
        label: "Information listed on this resource page is incorrect."
      },
      {
        name: :other,
        label: "Other"
      },
      {
        name: :employee_of_the_org,
        label: "I am employee of this organization.",
        details_required: false
      },
      {
        name: :contact_me,
        label: "I'd like to be contacted by a CHARMcare team member to update this resource information.",
        details_required: false
      }
    ]
  end

  def self.details_required?(attr_name)
    puts attr_name
    get_schema_attribute_by_name(attr_name)[:details_required] != false
  end

  def self.get_schema_attribute_by_name(name)
    attribute = report_attributes_schema.find do |ar|
      ar[:name] == name
    end

    attribute
  end

  def self.report_attributes_in_order
    Flag.report_attributes_schema.collect(&:values).transpose[0]
  end

  def self.get_report_attribute_label_for(attr)
    attribute = report_attributes_schema.find do |ar|
      ar[:name].to_s.include?(attr)
    end

    attribute ? attribute[:label] : attr[0]
  end

end
