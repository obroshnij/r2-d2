class Nav
  
  NAVS = [
    {
      name:       'Tools',
      url:        '#/tools',
      icon:       'fi-widget',
      auth:       false,
      navs_name:  'tools_navs',
      child_navs: [
        {
          name:   'Whois',
          url:    '#/tools/whois',
          icon:   'fa fa-fw fa-file-o'
        }, {
          name:   'Bulk Whois',
          url:    '/whois',
          icon:   'fa fa-fw fa-files-o'
        }, {
          name:   'Data Extractor',
          url:    '#/tools/data_extractor',
          icon:   'fa fa-fw fa-search'
        }, {
          name:   'Lists Compare Tool',
          url:    '#/tools/lists_diff',
          icon:   'fa fa-fw fa-list'
        }
      ]
    }, {
      name:       'Legal & Abuse',
      url:        '#/legal',
      icon:       'fi-sheriff-badge',
      auth:       true,
      navs_name:  'legal_navs',
      child_navs: [
        {
          name:   'Hosting Abuse',
          url:    '#/legal/hosting_abuse',
          icon:   'fa fa-fw fa-server',
          klass:  Legal::HostingAbuse
        }
      ]
    }
  ]
  
  attr_accessor :child_navs, :navs_name, :klass, :auth, :json
  
  def self.accessible_by_as_json ability
    navs = accessible_by ability
    
    result = navs.each_with_object({}) do |nav, hash|
      hash[nav.navs_name] = nav.child_navs.map(&:json)
    end
    
    main_navs = []
    navs.each do |nav|
      main_navs << { divider: true }
      main_navs << nav.json
    end
    main_navs << { divider: true }
    
    result['main_navs'] = main_navs
    
    result
  end
  
  def self.accessible_by ability
    navs = all.each do |nav|
      nav.child_navs.delete_if { |child_nav| child_nav.auth && ability.cannot?(:read, child_nav.klass) }
    end
    
    navs.delete_if { |nav| nav.child_navs.blank? }
  end
  
  def self.all
    NAVS.map { |nav| self.new nav }
  end
  
  def initialize options
    @json       = options.slice :name, :url, :icon
    @auth       = options[:auth]
    @klass      = options[:klass]
    @child_navs = init_child_navs(options[:child_navs]) if options[:child_navs]
    @navs_name  = options[:navs_name]
  end
  
  def init_child_navs child_navs
    child_navs.map do |child|
      child[:auth] = @auth if child[:auth].nil?
      Nav.new child
    end
  end
  
end