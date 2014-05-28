class MapController < UIViewController
  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.canvasYellow
    
    device_has_location_services_enabled = BW::Location.enabled?
    if device_has_location_services_enabled 
      GMSServices.provideAPIKey(UIViewController.maps_api_key)
      camera_position = GMSCameraPosition.cameraWithLatitude(41.889911, longitude: -87.637657, zoom: 14 )
      mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera_position)
      
      user_marker = GMSMarker.alloc.init
      user_marker.title = "You"
      # user_marker.title = user.name
      user_marker.map = mapView

      dbc_position = CLLocationCoordinate2DMake(41.889911, -87.637657)

      user_circle = GMSCircle.circleWithPosition(dbc_position, radius: 800)
      # user_circle = GMSCircle.circleWithPosition(dbc_position, radius: user.listening_radius)
      user_circle.map = mapView
      user_circle.fillColor = UIColor.colorWithRed(0.05, green: 0.49, blue: 0.37, alpha: 0.2)
      user_circle.strokeColor = UIColor.clearColor

      # DRAW EVENTS ON MAP
      Event.draw_on_map(mapView)


      #set the user radius using an http request ##############################################


      uid = App::Persistence['current_uid']
      radius = 20
      user_info = {uid: uid, radius: radius}
      User.set_radius(user_info) do |event|
        puts "RESPONSE FROM SET RADIUS"
        p event
      end


      BW::Location.get do |result|
        coordinate = result[:from].coordinate if result[:from]
        coordinate = result[:to].coordinate if result[:to]

        # "THESE ARE THE EVENTS THAT ARE LOADED FROM THE SERVER!!!!!!"
        # p events = App::Persistence['events']
        # if events
        #   puts "ACTIVE EVENTS"
        #   p active_events = events[:pingas_active_in_radius]
        #   puts "PENDING EVENTS"
        #   p pending_events = events[:pingas_pending_in_radius]
        #   puts "OUTSIDE EVENTS"
        #   p outside_events = events[:pingas_outside_radius]


        #   # some_array = [8,9,10]
        #   # App::Persistence["already_marked"] = {}

        #   active_events.each do |event|
        #     # this_hash = App::Persistence["already_marked"]
        #     # if this_hash.has_key?(event[:id]) == false
        #       puts "placing an active event"
        #       ping_marker = GMSMarker.alloc.init
        #       ping_marker.title = event[:title]
        #       ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
        #       ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
        #       ping_marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor)
        #       ping_marker.map = mapView

        #       # another_array = App::Persistence["already_marked"]
        #       # another_array.push(event[:id])
        #       # App::Persistence["already_marked"][event[:id]] = "yes"
        #     # end

        #   end

        #   pending_events.each do |event|
        #     # this_array = App::Persistence["already_marked"]
        #     # if this_array.include?(event[:id]) == false
        #       ping_marker = GMSMarker.alloc.init
        #       ping_marker.title = event[:title]
        #       ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
        #       ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
        #       ping_marker.icon = GMSMarker.markerImageWithColor(UIColor.canvasYellow)
        #       ping_marker.map = mapView
        #       # another_array = App::Persistence["already_marked"]
        #       # another_array.push(event[:id])
        #       # App::Persistence["already_marked"] = another_array 
        #     # end
        #   end

        #   outside_events.each do |event|
        #     # this_array = App::Persistence["already_marked"]
        #     # if this_array.include?(event[:id]) == false
        #       p "GETTING AN OUTSIDE EVENT"
        #       ping_marker = GMSMarker.alloc.init
        #       ping_marker.title = event[:title]
        #       ping_marker.snippet = "#{event[:start_time]} -- #{event[:description]}"
        #       ping_marker.position = CLLocationCoordinate2DMake(event[:latitude], event[:longitude])
        #       ping_marker.icon = GMSMarker.markerImageWithColor(UIColor.whiteColor)
        #       ping_marker.map = mapView
        #       # another_array = App::Persistence["already_marked"]
        #       # another_array.push(event[:id])
        #       # App::Persistence["already_marked"] = another_array 
        #     # end
        #     # puts "ALREADY MARKED ARRAY"
        #     # p App::Persistence["already_marked"]
        #   end

  # marker of different color
  # marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
  # marker of different icon image
  # marker.icon = [UIImage imageNamed:@"house"];
  # ping_marker.icon = "#{event[:status]}_#{event[:category].png}"
          #   # ping_marker.appearAnimation = kGMSMarkerAnimationPop
          #   # kGMSMarkerAnimationDrop? How to get animations in iOS?


          if coordinate
            # puts "Coordinate: #{coordinate}"
            
            lat = coordinate.latitude
            long = coordinate.longitude

            App::Persistence["user_latitude"] = lat
            App::Persistence["user_longitude"] = long

            user_position = CLLocationCoordinate2DMake(lat, long)
            user_marker.position = user_position

            user_circle.position = user_position

            # current_zoom = mapView.camera.zoom
            # camera_position = GMSCameraUpdate.setCamera(GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: current_zoom))
            # mapView.moveCamera(camera_position)
          else
            puts "No result from Location.get"
          end

          self.view = mapView
        # end
        # mapView.clear
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
    # # @mapView.delegate = self
    # {"id"=>3, 
    #   "end_time"=>"2014-05-27 16:37:34 +0000", 
    #   "duration"=>1, 
    #   "title"=>"Chipotile $1 Burritos", 
    #   "description"=>"This is crazy", 
    #   "longitude"=>-87.6351791, 
    #   "creator_id"=>1, 
    #   "address"=>"233 W Lake St Chicago, IL 60606", 
    #   "latitude"=>41.8855285644531, 
    #   "created_at"=>"2014-05-27T13:57:34.186Z", 
    #   "start_time"=>"2014-05-27 15:37:34 +0000", 
    #   "updated_at"=>"2014-05-27T15:56:08.318Z", 
    #   "category_id"=>5, 
    #   "distance"=>0.328356504440308, 
    #   "status"=>"active", 
    #   "bearing"=>"150.500355945692"}]

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