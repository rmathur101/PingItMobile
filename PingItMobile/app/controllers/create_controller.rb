module Formotion
  class Form < Formotion::Base
    def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
      cell.textLabel.textColor = UIColor.charcoal
      cell.backgroundColor = UIColor.canvasYellow
    end
  end
end

class CreateController < Formotion::FormController
  attr_accessor :form

  def viewDidLoad
    super
    
    self.view.backgroundColor = UIColor.charcoal

    # ON FORM SUBMIT BLOCK
    self.form.on_submit do |form|
      form.active_row && form.active_row.text_field.resignFirstResponder

      #storing the create event data here 
      new_event_data = form.render

      p "FORMOTION CREATE EVENT DATA"
      p new_event_data

      new_event_data[:start_time] =  (NSDate.dateWithTimeIntervalSince1970(new_event_data[:start_time])).strftime("%I:%M%p")

      new_event_data[:uid] = App::Persistence['current_uid']
      
      Event.create_event(new_event_data) do |event|
        p "THIS IS CALLBACK AFTER THE CREATE_EVENT HTTP REQUEST IS MADE"
        p event
      end
      #-------------------------------------------------------------------------------------


      alert = UIAlertView.alloc.init
      # alert.title = "@form.render"
      # alert.message = @form.render.to_s
      alert.title = "Sweet!"
      alert.message = "Your event was Pinged to the database."
      alert.addButtonWithTitle("OK")
      alert.show
    end

  end

  def initWithNibName(name, bundle: bundle)
    super
    @ping = UIImage.imageNamed('ping.png')
    # @pingSel = UIImage.imageNamed('ping-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('PingIt', image: @ping, tag: 3)
        # self.tabBarItem.setTintColor(UIColor.candyAppleRed)

    # self.tabBarItem.setFinishedSelectedImage(@pingSel, withFinishedUnselectedImage:@ping)
    self
  end

  def submit
    @form.submit
  end

end