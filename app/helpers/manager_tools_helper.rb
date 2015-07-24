module ManagerToolsHelper
  
  BONUS_FINE_REGEX = /\$\d+|\d+\$/
  
  def format_field(field)
    if field.is_a? Float
      field.modulo(1) == 0 ? field.round : field
    else
      field
    end
  end
  
  def parse_excel_file(file)
    excel_file = Roo::Excelx.new(file.path)
    excel_hash = {}
    excel_file.sheets.each_with_index do |sheet, index|
      excel_file.default_sheet = excel_file.sheets[index]
      unless excel_file.to_s == "nil"
        excel_hash[sheet] = delete_extra_lines excel_file.to_a
        excel_hash[sheet][0][0] = "Name"
      end
    end
    excel_hash
  end
  
  def delete_extra_lines(excel_array)
    excel_array.delete_if { |el| el.compact.count < 2 || el.first && el.first.to_s.include?("orms of") }
  end
  
  def format_table_fields(excel_array)
    excel_array.flatten.each do |el|
      unless el.nil?
        el.to_s.gsub!(/[\n]/, " ")
        el.strip! unless el.is_a? Float
      end
    end
    excel_array
  end
  
  def transform_excel_data_to_hash(excel_array)
    (excel_array - [excel_array.first]).map do |row|
      hash = {}
      excel_array.first.each_with_index do |key, index|
        hash[key] = format_field(row[index]) unless row[index].nil? || row[index].blank?
      end
      hash
    end
  end
  
  def generate_canned(employee, month, norm, signature)
    return "INSUFFICIENT DATA" if employee["To be paid"].nil? || employee["Working Shifts"].nil?
    
    canned = "Hello " + employee["Name"].split.first + ",\n\n"
    canned << "Please find your salary report for " + month + ".\n\n"
    
    shifts = []
    shifts << "You had " + employee["Working Shifts"].to_s + " working shifts in " + month
    shifts << employee["Sick"].to_s + " #{employee["Sick"] > 1 ? "days" : "day"} of sick leave" if employee["Sick"]
    shifts << employee["Unpaid"].to_s + " #{employee["Unpaid"] > 1 ? "shifts were" : "shift was"} taken as unpaid vacation" if employee["Unpaid"]
    shifts << employee["Vacations"].to_s + " #{employee["Vacations"] > 1 ? "days" : "day"} of paid vacation" if employee["Vacations"]
    if shifts.count > 1
      canned << shifts[0..-2].join(", ") + " and " + shifts.last + "."
    else
      canned << shifts.first + "."
    end
    
    shifts = []
    shifts << employee["Night Shifts"].to_s + " night #{"shift".pluralize(employee["Night Shifts"])} which will be paid at 1.5 rate" if employee["Night Shifts"] && employee["Night Shifts"].to_f != 0
    shifts << employee["Overtimes x 2"].to_s + " double-paid #{"overshift".pluralize(employee["Overtimes x 2"])}" if employee["Overtimes x 2"]
    shifts << employee["Shifts x 2"].to_s + " double-paid #{"shift".pluralize(employee["Shifts x 2"])} from our Lviv office" if employee["Shifts x 2"]
    if shifts.count > 0
      shifts.first.split(" ").first.to_i > 1 ? canned << " There were " : canned << " There was "
      if shifts.count > 1
        canned << shifts[0..-2].join(", ") + " and " + shifts.last + ".\n\n"
      else
        canned << shifts.first << ".\n\n"
      end
    else
      canned << "\n\n"
    end
    
    bonus = calculate_bonus employee["To be paid"]
    bonus = format_field bonus
    
    canned << "This makes it your full salary "
    unless bonus.is_a? String || bonus == 0
      canned << "plus #{bonus} additional regular #{"shift".pluralize(bonus)} " if bonus > 0
      canned << "excluding #{bonus * -1} regular #{"shift".pluralize(bonus)} " if bonus < 0
    end
    canned << bonus + " " if bonus.is_a? String
    canned << "to be paid. "
    canned << "You can calculate the cost of your regular shift by dividing your monthly wages by the number of working shifts "
    canned << "(the norm for #{month} was #{norm} #{"shift".pluralize(norm.to_i)}).\n\n"
    
    if employee["Additional Responsibilities"] && employee["Additional Responsibilities"].match(BONUS_FINE_REGEX)
      canned << "Additionally you will get a #{employee["Additional Responsibilities"].gsub("+", "")}.\n\n"
    end
    
    if employee["Additional Tasks/Comments"] && employee["Additional Tasks/Comments"].match(BONUS_FINE_REGEX)
      canned << "Also, you will get a #{employee["Additional Tasks/Comments"].match(BONUS_FINE_REGEX).to_s} bonus for ...\n\n"
    end
    
    canned << "Unfortunately, there will be a #{employee["Fines"].match(BONUS_FINE_REGEX).to_s} fine for ...\n\n" if employee["Fines"] && employee["Fines"].match(BONUS_FINE_REGEX)
    
    canned << "Please let me know in case of any question (no matter whether it is organizational or a procedure related one)."
    canned << "\n\n#{signature}" unless signature.blank?
    canned
  end
  
  def calculate_bonus(to_be_paid)
    if to_be_paid.is_a? String
      return "INVALID FORMAT" if to_be_paid.split(" ").count != 3
      to_be_paid.split[1] == "-" ? to_be_paid.split[2].to_f * -1 : to_be_paid.split[2].to_f
    elsif to_be_paid.is_a? Float
      to_be_paid
    elsif to_be_paid.is_a? Fixnum
      to_be_paid
    else
      "INVALID FORMAT"
    end
  end
  
  def convert_staff_people(people)
    people.map { |el| el[:id].to_s + ': ' + el[:name] + ' - ' + el[:email] }.join("\n")
  end
  
  def generate_welcome_canned(people)
    canned = "Hello everyone,\n\n"
    canned << "We are glad to see you in our team. We want to congratulate you on the successful completion of the final test and wish you good luck with the supervision. "
    canned << "We hope you will become a long term asset to our team and will grow and develop together with Namecheap.\n\n"
    canned += "Regards,\n" + current_user.name + "\nGeneral Manager\nCustomer Support Team\nNamecheap.com"
  end
  
end