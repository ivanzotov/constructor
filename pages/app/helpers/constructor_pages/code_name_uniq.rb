module ConstructorPages
  module CodeNameUniq
    def code_name_uniqueness
      unless Page.check_code_name(code_name) and check_code_name(code_name)
        errors.add(:base, t(:code_name_already_in_use))
      end
    end
  end
end