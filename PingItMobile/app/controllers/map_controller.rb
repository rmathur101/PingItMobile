class MapController < UIViewController
  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.canvasYellow
    
    device_has_location_services_enabled = BW::Location.enabled?
    if device_has_location_services_enabled 
      GMSServices.provideAPIKey(UIViewController.maps_api_key)
      camera_position = GMSCameraPosition.cameraWithLatitude(41.889911, longitude: -87.637657, zoom: 15 )
      mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera_position)
      
      user_marker = GMSMarker.alloc.init
      user_marker.title = "You"
      user_marker.map = mapView

      BW::Location.get do |result|
        coordinate = result[:from].coordinate if result[:from]
        coordinate = result[:to].coordinate if result[:to]

        if coordinate
          puts "Coordinate: #{coordinate}"
          
          lat = coordinate.latitude
          long = coordinate.longitude

          App::Persistence["user_latitude"] = lat
          App::Persistence["user_longitude"] = long

          user_position = CLLocationCoordinate2DMake(lat, long)
          user_marker.position = user_position

          current_zoom = mapView.camera.zoom

          camera_position = GMSCameraUpdate.setCamera(GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: current_zoom))
          mapView.moveCamera(camera_position)
        else
          puts "No result from Location.get"
        end
        # Drop events onto the map








        self.view = mapView
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