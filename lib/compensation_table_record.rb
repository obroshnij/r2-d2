class CompensationTableRecord

  def self.parse
    xlsx = Roo::Spreadsheet.open('path to table')

    start_row = 2103
    end_row = xlsx.sheet('Responses').last_row

    (start_row..end_row).map do |line|

      compensation = CompensationTableRecord.new xlsx.sheet('Responses').row(line), line

      if compensation.yellow_cell? || compensation.service_compensated_include_old? || compensation.created_at.nil?
        my_logger.warn("Can not create compensation from #{line}")
        next
      end

      domain_compensation = Domains::Compensation.new(
                                                      created_at:             compensation.created_at,
                                                      product_compensated_id: compensation.product_compensated_id,
                                                      service_compensated_id: compensation.service_compensated_id,
                                                      compensation_amount:    compensation.compensation_amount,
                                                      discount_recurring:     compensation.discount_recurring,
                                                      compensation_type_id:   compensation.compensation_type_id,
                                                      issue_level_id:         compensation.issue_level_id,
                                                      comments:               compensation.comments,
                                                      client_satisfied:       compensation.client_satisfied,
                                                      department:             compensation.department,
                                                      reference_item:         compensation.reference_item,
                                                      reference_id:           compensation.reference_id,
                                                      status:                 0,
                                                      hosting_type_id:        compensation.hosting_type_id,
                                                      submitted_by_id:        compensation.submitted_by_id,
     )
     my_logger.info("Creating compensation from line #{line}") if domain_compensation.save

    end
  end

  def initialize(row, line_num)
    @row = row
    @line_num = line_num
  end

  def created_at
    return nil unless @row[0].present?
    @row[0]
  end

  def product_compensated_id
    return nil unless @row[2].present?
    val = @row[2].strip
    val = 'Credit (funds added to account balance)' if val =~ /^Credit/
    @product_compensated_id = Domains::Compensation::NamecheapProduct.find_by_name(val).id
  end

  def yellow_cell?
    return nil unless @row[3].present?
    @row[3]&.include?('fee')
  end

  def service_compensated_include_old?
    return true if @row[3] == 'RapidSSL Wildcard' || (@row[3].present? && @row[3].include?('Comodo')) || @row[3] == 'Basic Hosting' || @row[3] == 'OX business' || @row[3] == 'Onepager' || @row[3] == 'Thawte SSL123' || @row[3] == 'True BusinessID with EV Multi Domain' || @row[3] == 'RapidSSL' || @row[3] == 'Quickssl' || @row[3] == '50 tier pricing' || @row[3] == '"GeoTrust True BusinessID' || @row[3] == 'TrueBusiness ID with EV Multi-Domain' || @row[3] == 'Emergency Assitance' || @row[3] == '50 active domains' || @row[3] == 'Basic Hosting' || @row[3] == 'Onepager' || @row[3] == 'Credit' || @row[3] == 'GeoTrust QuickSSL Premium' || @row[3] == 'special tierr for the account' || @row[3] == 'QuickSSL Premium' || @row[3] == 'GeoTrust True BusinessID'
  end

  def service_compensated_id
    val = @row[3].try(:strip)
    return nil if product_compensated_id == 6 || product_compensated_id == 5 || val == 'whoisguard'
    val = 'Value 4G' if val == 'value'
    val = 'Additional Mailbox' if val == 'Additional mailbox'
    val = 'VPS 1 - Xen' if val == 'VPS 1- XEN' || val == 'VPS 1 -Xen' || val == 'VPS 1-Xen' || val == 'VPS 1-XEN' || val == 'VPS 1 XEN' || val == 'VPS1-XEN'
    val = 'VPS 3 - Xen' if val == 'VPS 3- XEN' || val == 'VPS 3 -Xen' || val == 'VPS 3-Xen' || val == 'VPS 3-XEN' || val == 'VPS 3 XEN'
    val = 'VPS 2 - Xen' if val == 'VPS 2- XEN' || val == 'VPS 2 -Xen' || val == 'VPS 2-Xen' || val == 'VPS 2-XEN' || val == 'VPS 2 XEN'
    val = 'InstantSSL'  if val == 'instantssl'
    val = 'PositiveSSL' if val == 'Positive SSL'
    val = 'Ultimate 4G' if val == 'Ultimate 4 G'
    val = 'VPS Lite - Xen' if val == 'VPS Lite'
    val = 'PositiveSSL' if val == 'Positive SSL' || val == 'PossitiveSSL'
    val = 'Business' if val == 'Business Plan'
    val = 'Business SSD' if val == 'BusinessSSD'
    val = 'Level 3 Reseller' if val == 'Level3 Reseller' || val == 'Level 3 Reseller 2011'
    val = 'Level 1 Reseller' if val == 'Level1 Reseller' || val == 'Level 1 Reseller 2011'

    service_compencated = Domains::Compensation::NamecheapService.find_by_name(val)
    @service_compencated_id = service_compencated.id unless service_compencated.nil?
  end

  def hosting_type_id
    service_compensated_id.nil? ? nil : Domains::Compensation::NamecheapService.find(service_compensated_id).hosting_type_id
  end

  def compensation_amount
    @row[5]
  end

  def discount_recurring
    return nil unless @row[6].present?
    @row[6] == 'No' ? false : true
  end

  def compensation_type_id
    return nil unless @row[7].present?
    pattern = /\b(?:#{ Regexp.union(["Discount", "Free item", "Service prolongation", "Refund", "Fee concession", "Credit", "Tier pricing assignment"]).source })\b/
    @compensation_type_id = Domains::Compensation::CompensationType.find_by_name(@row[7].scan(pattern)).id
  end

  def issue_level_id
    return nil unless @row[8].present?
    Domains::Compensation::IssueLevel.all.map{|el| return el.id if el.name[0] == @row[8][0] }
  end

  def comments
    @row[9]
  end

  def client_satisfied
    return nil unless @row[10].present?
    @row[10] == 'No' ? false : true
  end

  def department
    @row[12]
  end

  def reference_item
    @row[13]
  end

  def reference_id
    @row[14]
  end

  def qa_comments
    @row[18]
  end

  def delivered
    @row[17]
  end

  def used_correctly
    return nil unless @row[16].present?
    @row[16].split[2] == 'incorrectly)' ? false : true
  end

  def status
    return 0 unless @row[16].present?
    @row[16].split[0] == 'Yes' ? 1 : 2
  end

  def submitted_by_id
    return nil unless @row[11].present?
    user = @row[11].strip
    user = 'Ekaterina Onyfrei'    if user == 'Kate O.'
    user = 'Bogdan Biloshytskiy'  if user == 'Bogdan B'
    user = 'Evgeniy Zaryanov'     if user == 'Eugene' || user == 'Eugene Z' || user == 'Eugene Z.'
    user = 'Alexey Kalutskikh'    if user == 'Alexey Kalutskikh (alexey.ka)'
    user = 'Eugenia Kanavets'     if user == 'Eugenia Kanavets (Kanavets) #151'
    user = 'Alexandr Momot'       if user == 'Alex Momot'
    user = 'Alexander Grebenkov'  if user == 'Alex Grebenkov'
    user = 'Anna Kharkovskaya'    if user == 'Anna Kh.'
    user = 'Anton Lysykh'         if user == 'Anton L.'
    user = 'Ekaterina Levitskaya' if user == 'Kate L'
    user = 'Maria Priadko'        if user == 'Maria Priadkoetrovskaya'
    user = 'Lena P'               if user == 'Elena Pakhomova'
    user = 'Stanislav Katsion'    if user == 'Stanislav Katsionatsion'
    user = 'Alina Skripka'        if user == 'Alina.Skripka'
    user = 'Olga Biletskaya'      if user == 'Olga Biletska'
    user = 'Maria Priadko'        if user == 'Maria Priadkorytkina'
    user = 'Stas Sotnikov'        if user == 'Stanislav Sotnikov'
    user = 'Alexandra Kravchuk'   if user == 'Alexandra Kr.'
    user = 'Alexandra Kramarenko' if user == 'Alexandra K.'
    user = 'Olga Semykhat'        if user == 'Olga Se' || user == 'Olga Se.'
    user = 'Victoria Burma'       if user == 'Victoria BUrma'
    user = 'Alexandr Akimenko'    if user == 'Alexander A'
    user = 'Anastasiya Shevtsova' if user == 'Stacey Sh'
    user = 'Julia Serdechnaya'    if user == 'Julia.Serdechanya'
    user = 'Marina Novichenko'    if user == 'Marina N.'
    user = 'Elena Pakhomova'      if user == 'Lena P'
    user = 'Christina Oliynik'    if user == 'Chrisitna Oliynik'
    user = 'Alexandr Chernokun'   if user == 'Alexander Chernokun'

    r2d2_user = User.find_by_name(user) || User.find_by_name(user.gsub(/[.]/, '')) || User.find_by_name(user.gsub(/  /, ' '))
    @user_id = r2d2_user.id
  end

  def self.my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/parse_table.log")
  end
end