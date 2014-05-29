class ShowController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.canvasYellow

    p App::Persistence['show_info']


    @data = {}
    @data[:event_id] = App::Persistence['show_info'][:id]
    @data[:uid] = App::Persistence['current_uid']

    title_font = UIFont.fontWithName("GillSans-Bold", size: 24.0)
    text_font = UIFont.fontWithName("Helvetica", size: 14.0)

    @event_title = UILabel.alloc.initWithFrame(CGRectMake(10, 10, 300, 200))
    @event_title.text = App::Persistence['show_info'][:title]
    @event_title.textAlignment = NSTextAlignmentCenter
    @event_title.font = title_font
    self.view.addSubview(@event_title)

    @event_time = UILabel.alloc.initWithFrame(CGRectMake(10, 40, 300, 200))
    start = (NSDate.dateWithString(App::Persistence['show_info'][:start_time])).strftime("%I:%M %p")
    ending = (NSDate.dateWithString(App::Persistence['show_info'][:end_time])).strftime("%I:%M %p")
    @event_time.text = start + " - " + ending
    @event_time.font = text_font
    @event_time.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(@event_time)
    

    descrip_font = UIFont.fontWithName("Helvetica-LightOblique", size: 16.0)
    @event_description = UILabel.alloc.initWithFrame(CGRectMake(10, 80, 300, 200))
    @event_description.text = App::Persistence['show_info'][:description]
    @event_description.font = descrip_font
    @event_description.textAlignment = NSTextAlignmentLeft
    self.view.addSubview(@event_description)


    @event_address = UILabel.alloc.initWithFrame(CGRectMake(20, 140, 300, 200))
    @event_address.text = App::Persistence['show_info'][:address]
    @event_address.font = text_font
    @event_address.textAlignment = NSTextAlignmentCenter
    self.view.addSubview(@event_address)

    @event_status = UILabel.alloc.initWithFrame(CGRectMake(20, 170, 300, 200))
    @event_status.text = App::Persistence['show_info'][:status]
    self.view.addSubview(@event_status)


#------------------------------------------------------buttons

# buyButton.layer.cornerRadius = 2;
# buyButton.layer.borderWidth = 1;
# buyButton.layer.borderColor = [UIColor blueColor].CGColor;

    @yes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @yes_button.setTitle("YES", forState: UIControlStateNormal)
    # @yes_button.frame = [[10, 300], [250, 50]]
    @yes_button.backgroundColor = UIColor.whiteColor
    @yes_button.layer.cornerRadius = 5
    @yes_button.layer.borderWidth = 2
    @yes_button.frame = CGRectMake(10, 460, 130, 35)
    @yes_button.addTarget(self, action: :select_yes, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@yes_button)

    @no_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @no_button.setTitle("NO", forState: UIControlStateNormal)
    @no_button.backgroundColor = UIColor.whiteColor
    @no_button.layer.cornerRadius = 5
    @no_button.layer.borderWidth = 2
    @no_button.frame = CGRectMake(180, 460, 130, 35)
    @no_button.addTarget(self, action: :select_no, forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(@no_button)    


    


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
        cancelButtonTitle: "ok",
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
      @alert_box = UIAlertView.alloc.initWithTitle("...",
        message: "You suck and I hate you.",
        delegate: nil,
        cancelButtonTitle: "ok",
        otherButtonTitles: nil)
      puts "THIS IS RESPONSE FROM HTTP REQUEST IN SELECT_NO"
      p event      
      @alert_box.show
    end
  end

end