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
      GMSServices.provideAPIKey(UIViewController.maps_api_key)

      BW::Location.get do |result|
        coordinate = result[:from].coordinate if result[:from]
        coordinate = result[:to].coordinate if result[:to]
        # position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)

        # camera = GMSCameraPosition.cameraWithLatitude( coordinate.latitude, longitude: coordinate.longitude, zoom: 13 )
        # @mapView = GMSMapView.mapWithFrame( CGRectMake(0, 40, self.view.frame.width, self.view.frame.width)
        # lat = textLabel(coordinate.latitude, 20, 370)
        # long = textLabel(coordinate.longitude, 20, 390)
        
        # marker = GMSMarker.markerWithPosition( position )
        # marker.map = @mapView;

        # self.view.addSubview(@mapView)
        # self.view.addSubview(lat)
        # self.view.addSubview(long)


      end
    else
      # Display Alert
      alert = UIAlertView.alloc.init
      alert.title = "Attention"
      alert.message = "Please go into settings and enable location"
      alert.addButtonWithTitle("OK")
      alert.show
    end
    
    # GMSServices.provideAPIKey(UIViewController.maps_api_key)
    # @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = DirectionController.new #GoogleMapsController.new

    # CAMERA
    # camera = GMSCameraPosition.cameraWithLatitude( 37.778376, longitude: -122.409853, zoom: 13 );
    # GRectMake(0,0, 10, 25)

    # @mapView = GMSMapView.mapWithFrame( CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.width), camera:camera )
    # @mapView.delegate = self

    # MARKER
    # marker = GMSMarker.alloc.init
    # marker.position = CLLocationCoordinate2DMake(47.592011,-122.313043)
    # marker.title = "Shinjuku"
    # marker.snippet = "Japan"
    # marker.map = @map_view

    # self.view.addSubview(@mapView)
    # @lat = textLabel("lat", 20, 370)
    # @long = textLabel("long", 20, 390)
    # self.view.addSubview(@lat)
    # self.view.addSubview(@long)

    # position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    # marker = GMSMarker.markerWithPosition( position )
    # marker.map = @mapView;


  end

  def textLabel(text, from_left, from_top)
    textLabel = begin
      _textLabel = UILabel.alloc.initWithFrame([[from_left, from_top], [200, 44]])
      _textLabel.text = text
      _textLabel.textAlignment = UITextAlignmentCenter
      _textLabel.textColor = UIColor.lightGrayColor
      _textLabel
    end
  end

  def initWithNibName(name, bundle: bundle)
    super
    @map = UIImage.imageNamed('map.png')
    @mapSel = UIImage.imageNamed('map-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Map', image: @map, tag: 2)
    self.tabBarItem.setFinishedSelectedImage(@mapSel, withFinishedUnselectedImage:@map)
    self
  end

end