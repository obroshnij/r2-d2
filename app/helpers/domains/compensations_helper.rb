module Domains
  module CompensationsHelper

    def qa? compensation
      current_ability.can? :qa_check, compensation
    end

  end
end
