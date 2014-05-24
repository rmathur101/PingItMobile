class MapController < UIViewController
  def viewDidLoad
    super
    # CUSTOM COLORS
    candyAppleRed = UIColor.colorWithRed(0.93, green: 0.13, blue: 0.14, alpha: 1.0)
    canvasYellow = UIColor.colorWithRed(1.0, green: 0.89, blue: 0.51, alpha: 1.0)
    offWhite = UIColor.colorWithRed(0.98, green: 0.98, blue: 0.99, alpha: 1.0)
    charcoal = UIColor.colorWithRed(0.2, green: 0.18, blue: 0.17, alpha: 1.0)
    forestGreen = UIColor.colorWithRed(0.05, green: 0.49, blue: 0.37, alpha: 1.0)

    self.view.backgroundColor = canvasYellow
    
    device_has_location_services_enabled = BW::Location.enabled?
    if device_has_location_services_enabled 
      BW::Location.get do |result|
        p result[:from].coordinate if result[:from].coordinate
        p result[:to].coordinate if result[:to].coordinate
      end
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    @map = UIImage.imageNamed('map.png')
    @mapSel = UIImage.imageNamed('map-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('PingIt', image: @map, tag: 2)
    self.tabBarItem.setFinishedSelectedImage(@mapSel, withFinishedUnselectedImage:@map)
    self
  end

end