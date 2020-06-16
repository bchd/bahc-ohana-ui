module FlagHelper

  def checkbox_name(name)
    return name if name == :employee_of_the_org

    "#{name}_checkbox"
  end
  
end
