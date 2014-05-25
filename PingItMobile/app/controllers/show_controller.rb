class ShowController < UIViewController
  def viewDidLoad
    super
    canvasYellow = UIColor.colorWithRed(1.0, green: 0.89, blue: 0.51, alpha: 1.0)

    self.view.backgroundColor = canvasYellow
    # self.
    p App::Persistence['show_info']

    # App::Persistence['show_info'][:title]
    # App::Persistence['show_info'][:description]
    # App::Persistence['show_info'][:address]
    # App::Persistence['show_info'][:status]
    # App::Persistence['show_info'][:start_time]




    # (CGRectMake(10, 10, 100, 100)


    @event_title = UILabel.alloc.initWithFrame(CGRectMake(20, 40, 300, 200))
    @event_title.text = App::Persistence['show_info'][:title]
    # @event_title.sizeToFit
    # @event_title.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 7)
    self.view.addSubview(@event_title)

    @event_description = UILabel.alloc.initWithFrame(CGRectMake(20, 70, 300, 200))
    @event_description.text = App::Persistence['show_info'][:description]
    # @event_description.sizeToFit
    # @event_description.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 6)
    self.view.addSubview(@event_description)

    @event_address = UILabel.alloc.initWithFrame(CGRectMake(20, 100, 300, 200))
    @event_address.text = App::Persistence['show_info'][:address]
    # @event_address.sizeToFit
    # @event_address.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 5)
    self.view.addSubview(@event_address)

    @event_status = UILabel.alloc.initWithFrame(CGRectMake(20, 130, 300, 200))
    @event_status.text = App::Persistence['show_info'][:status]
    # @event_status.sizeToFit
    # @event_status.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4)
    self.view.addSubview(@event_status)

    @event_start = UILabel.alloc.initWithFrame(CGRectMake(20, 160, 300, 200))
    @event_start.text = App::Persistence['show_info'][:start_time]
    # @event_start.sizeToFit
    # @event_start.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3)
    self.view.addSubview(@event_start)






    





    #title
    #description
    #google image ICEBOX
    #address
    #rsvp count
    #yes / no ---> this is going to require an http request 
    #status
    #start_time



  end
end