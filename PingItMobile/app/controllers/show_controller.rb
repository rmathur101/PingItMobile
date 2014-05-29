class ShowController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.charcoal
    puts "SHOW INFO"
    p App::Persistence['show_info']


    @data = {}
    @data[:event_id] = App::Persistence['show_info'][:id]
    @data[:uid] = App::Persistence['current_uid']

    title_font = UIFont.fontWithName("GillSans-Bold", size: 24.0)
    text_font = UIFont.fontWithName("GillSans", size: 14.0)

    @event_title = UILabel.alloc.initWithFrame(CGRectMake(10, 10, 300, 200))
    @event_title.textColor = UIColor.offWhite
    @event_title.text = App::Persistence['show_info'][:title]
    @event_title.textAlignment = NSTextAlignmentCenter
    @event_title.font = title_font
    self.view.addSubview(@event_title)

    @event_time = UILabel.alloc.initWithFrame(CGRectMake(10, 40, 300, 200))
    @event_time.textColor = UIColor.offWhite
    start = (NSDate.dateWithString(App::Persistence['show_info'][:start_time])).strftime("%I:%M %p")
    ending = (NSDate.dateWithString(App::Persistence['show_info'][:end_time])).strftime("%I:%M %p")

    p "START TIME "
    p NSDate.dateWithString(App::Persistence['show_info'][:start_time])
    p "START TIME (getutc)"
    p (NSDate.dateWithString(App::Persistence['show_info'][:start_time])).getutc
    p "END TIME"
    p NSDate.dateWithString(App::Persistence['show_info'][:end_time])
    p "END TIME (getlocal)"
    p NSDate.dateWithString(App::Persistence['show_info'][:end_time]).getlocal

    @event_time.text = start + " - " + ending
    @event_time.font = text_font
    @event_time.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(@event_time)
    

    descrip_font = UIFont.fontWithName("GillSans-Italic", size: 16.0)
    @event_description = UILabel.alloc.initWithFrame(CGRectMake(10, 80, 300, 200))

    @event_description.text = App::Persistence['show_info'][:description]
    @event_description.textColor = UIColor.offWhite
    @event_description.font = descrip_font
    @event_description.textAlignment = NSTextAlignmentCenter
    @event_description.numberOfLines = 6
    self.view.addSubview(@event_description)

    p lat = (App::Persistence['show_info'][:latitude])
    p long = (App::Persistence['show_info'][:longitude])
    camera_position = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: 15 )
    window = CGRectMake(20, 270, 280, 170)
    mapView = GMSMapView.mapWithFrame(window, camera: camera_position)
    event_marker = GMSMarker.alloc.init
    event_marker.title = App::Persistence['show_info'][:title]
    event_marker.icon = UIImage.imageNamed("markers/user_marker.png")
    event_marker.position = CLLocationCoordinate2DMake(lat, long)
    event_marker.map = mapView
    self.view.addSubview(mapView)

    @event_address = UILabel.alloc.initWithFrame(CGRectMake(15, 140, 300, 200))
    @event_address.textColor = UIColor.offWhite
    @event_address.text = App::Persistence['show_info'][:address]
    @event_address.font = text_font
    @event_address.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(@event_address)

    # @event_status = UILabel.alloc.initWithFrame(CGRectMake(20, 170, 300, 200))
    # @event_status.text = App::Persistence['show_info'][:status]
    # self.view.addSubview(@event_status)


#------------------------------------------------------buttons

# buyButton.layer.cornerRadius = 2;
# buyButton.layer.borderWidth = 1;
# buyButton.layer.borderColor = [UIColor blueColor].CGColor;

# if attending_status.nil?
    @yes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)

    @yes_button.setTitle("GOING", forState: UIControlStateNormal)
    @yes_button.setTitleColor(UIColor.offWhite, forState: UIControlStateNormal)
    @yes_button.setTitleColor(UIColor.charcoal, forState: UIControlStateHighlighted)

    @yes_button.font = text_font

    # @yes_button.frame = [[10, 300], [250, 50]]
    @yes_button.backgroundColor = UIColor.colorWithRed(0.0, green: 0.99, blue: 0.0, alpha: 0.7)
    @yes_button.layer.cornerRadius = 5
    # @yes_button.layer.borderWidth = 2
    @yes_button.frame = CGRectMake(20, 460, 130, 35)
    @yes_button.addTarget(self, action: :select_yes, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@yes_button)

    @no_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @no_button.setTitle("NOT GOING", forState: UIControlStateNormal)
    @no_button.font = text_font
    @no_button.backgroundColor = UIColor.colorWithRed(0.99, green: 0.0, blue: 0.0, alpha: 0.7)
    @no_button.setTitleColor(UIColor.offWhite, forState: UIControlStateNormal)
    @no_button.setTitleColor(UIColor.charcoal, forState: UIControlStateHighlighted)
    @no_button.layer.cornerRadius = 5
    # @no_button.layer.borderWidth = 2
    @no_button.frame = CGRectMake(170, 460, 130, 35)
    @no_button.addTarget(self, action: :select_no, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@no_button)    
# else
    # put down a text label that says "Attending"
# end

    


#TO DO (SHOW)
    #title
    #start_time - #end_time
    #rsvp count
    #description
    #google image satic pic (status)
    #address
    #yes / no ---> this is going to require an http request 

  end

#------------------------------------------------------------------the alert box is rendered in the callback function of the rsvp request 
  def select_yes
    @data[:rsvp_status] = "attending"
    puts "@data HASH IS BELOW"
    p @data

    Event.send_rsvp_info(@data) do |event|
      @alert_box = UIAlertView.alloc.initWithTitle("Thanks!",
        message: "See you soon!",
        delegate: nil,
        cancelButtonTitle: "OK",
        otherButtonTitles: nil)
      puts "THIS IS RESPONSE FROM HTTP REQUEST IN SELECT_YES"
      p event 
      @alert_box.show
    end
  end

  def select_no
    @data[:rsvp_status] = "no"
    puts "@data HASH IS BELOW"
    p @data

    Event.send_rsvp_info(@data) do |event|
      @alert_box = UIAlertView.alloc.initWithTitle("Shucks!",
        message: "You won't be attending.",
        delegate: nil,
        cancelButtonTitle: "OK",
        otherButtonTitles: nil)
      puts "THIS IS RESPONSE FROM HTTP REQUEST IN SELECT_NO"
      p event      
      @alert_box.show
    end
  end

end