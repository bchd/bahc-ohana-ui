class Flag
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :description
  attr_accessor :report_attributes
end
