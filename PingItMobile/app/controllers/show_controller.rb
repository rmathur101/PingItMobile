class ShowController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.greenColor
    # self.
    p App::Persistence['show_info']

    # App::Persistence['show_info'][:title]
    # App::Persistence['show_info'][:description]
    # App::Persistence['show_info'][:address]
    # App::Persistence['show_info'][:status]
    # App::Persistence['show_info'][:start_time]



    @event_label = UILabel.alloc.initWithFrame(CGRectZero)
    @event_label.text = App::Persistence['show_info'][:title]
    @event_label.sizeToFit
    @event_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 7)
    self.view.addSubview(@event_label)




    





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