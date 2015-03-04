module ManagerToolsHelper
  
  def format_field(field)
    if field.is_a? Float
      field.modulo(1) == 0 ? field.round : field
    else
      field
    end
  end
  
  def generate_canned(employee, month, norm, signature)
    canned = "Hello " + employee["Name"].split.first + ",\n\n"
    canned << "Please find your work report for " + month + ".\n\n"
    
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
    
    bonus = if !employee["To be paid"] || employee["To be paid"] == 0
      "INVALID FORMAT"
    else
      if employee["To be paid"].split.count != 3
        "INVALID FORMAT"
      else
        employee["To be paid"].split[1] == "-" ? employee["To be paid"].split[2].to_f * -1 : employee["To be paid"].split[2].to_f
      end
    end
    bonus = format_field(bonus)
    
    canned << "This makes your full salary "
    unless bonus.is_a? String || bonus == 0
      canned << "plus #{bonus} additional regular #{"shift".pluralize(bonus)} " if bonus > 0
      canned << "excluding #{bonus} regular #{"shift".pluralize(bonus)} " if bonus < 0
    end
    canned << bonus + " " if bonus.is_a? String
    canned << "to be paid. "
    canned << "You can calculate the cost of your regular shift by dividing your monthly wages by the number of working shifts "
    canned << "(the norm for #{month} was #{norm} #{"shift".pluralize(norm.to_i)}).\n\n"
    
    canned << "Unfortunately, there will be a #{employee["Fines"].match(/\$[[:alnum:]]+/).to_s} fine for ...\n\n" if employee["Fines"]
    
    canned << "Please let me know in case of any question (no matter whether it is organizational or a procedure related one).\n\n"
    canned << signature
  end
  
end