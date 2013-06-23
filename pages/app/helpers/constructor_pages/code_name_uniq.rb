module ConstructorPages
  module CodeNameUniq
    def code_name_uniqueness
      errors.add(:base, :code_name_already_in_use) unless Page.check_code_name(code_name) and check_code_name(code_name)
    end
  end
end