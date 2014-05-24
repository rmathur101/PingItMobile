class CreateController < Formotion::FormController
  attr_accessor :form

  def viewDidLoad
    super
    
    # CUSTOM COLORS
    candyAppleRed = UIColor.colorWithRed(0.93, green: 0.13, blue: 0.14, alpha: 1.0)
    canvasYellow = UIColor.colorWithRed(1.0, green: 0.89, blue: 0.51, alpha: 1.0)
    offWhite = UIColor.colorWithRed(0.98, green: 0.98, blue: 0.99, alpha: 1.0)
    charcoal = UIColor.colorWithRed(0.2, green: 0.18, blue: 0.17, alpha: 1.0)
    forestGreen = UIColor.colorWithRed(0.05, green: 0.49, blue: 0.37, alpha: 1.0)

    @defaults = NSUserDefaults.standardUserDefaults
    frame = UIScreen.mainScreen.applicationFrame
    origin = frame.origin
    size = frame.size

    self.view.backgroundColor = canvasYellow

    # ON FORM SUBMIT BLOCK
    self.form.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder

      #storing the create event data here 
      new_event_data = form.render


      what_data = {} #no data in what_data 
      #----------------------------------------------------------------testing http requests
      # Event.get_events do |event|
      #   p "THIS IS CALLBACK AFTER THE GET_EVENTS HTTP REQUEST IS MADE"
      #   p event
      # end

      Event.create_event(new_event_data) do |event|
        p "THIS IS CALLBACK AFTER THE CREATE_EVENT HTTP REQUEST IS MADE"
        p event
      end
      #-------------------------------------------------------------------------------------


      alert = UIAlertView.alloc.init
      alert.title = "@form.render"
      alert.message = @form.render.to_s
      alert.addButtonWithTitle("OK")
      alert.show
    end

  end

  def initWithNibName(name, bundle: bundle)
    super
    @ping = UIImage.imageNamed('ping.png')
    @pingSel = UIImage.imageNamed('ping-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('PingIt', image: @ping, tag: 3)
    self.tabBarItem.setFinishedSelectedImage(@pingSel, withFinishedUnselectedImage:@ping)
    self
  end

  def submit
    @form.submit
  end

end