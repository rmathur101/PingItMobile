class IndexController < UIViewController
  def viewDidLoad
    super

    self.title = "Events"

    events_table = UITableView.alloc.initWithFrame(self.view.bounds)
    # events_table.backgroundView = self.view

    # self.view.backgroundColor = canvasYellow
    # initiating table
    # events_table.separatorColor = UIViewController.charcoal
    # events_table.backgroundColor = UIViewController.canvasYellow 
    # events_table.sectionIndexTrackingBackgroundColor = UIViewController.candyAppleRed
    
    # self.view.addSubview(events_table)

    self.view.addSubview(events_table)

#QUESTIONS
#------------------------------------
#How to clear the App:Persistence???
# NSUserDefaults.resetStandardUserDefaults (was hoping that this was going to delete the things that were in APP::Peristence)  

# p Time.iso8601(test_time)
# 2014-05-24T21:41:09.165Z #the original time getting form the hash
# 2014-05-24T21:41:165Z #the edited time to make it look more like the bubble wrap example
# 2012-05-31T19:41:33Z #the example that bubble wrap gave us 


    # App::Persistence.delete('events') #USE THIS TO DELETE THE PERSISTENCE DATA 

    Event.get_events do |event| #need to make sure that the program does not move on until we have a response back from this http request 
      # p event
      # testing =  event[0]
      # p testing
      # testing[:duration] = "this is the duration now"
      # p testing

      # puts "THESE ARE THE EVENTS I AM GETTING BACK"
      App::Persistence['events'] = event 
      # p App::Persistence['events']
    end


    @array_events = App::Persistence['events'] 
    p @array_events

#----------------------------------------------------------------------------

    #data stuff
    events_table.dataSource = self #set our controller as the table's dataSource
    events_table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    



    #what pieces of data are going to go in our cells?
    #the name of the event,
    #the time until the start of the event
    #the miles away from your current location
    #checked, unchecked, or denied (in which it shouldn't even show up in the table)


    # @data = [["will", "this", "think"]]



    @data = []
    @array_events.each do |event_obj| 
      event_obj_array = []
      event_obj_array.push(event_obj[:title])
      # p event_obj[:title]

      #working out the time to be displayed on index---------------------------------------------------------------
      event_time = event_obj[:start_time]
      # p event_obj[:start_time]
      convert_event_time = Time.iso8601(event_time.gsub(/\.\d*/, ""))
      # p convert_event_time 
      difference = convert_event_time - NSDate.date
      # p NSDate.date
      # if difference >= 0
      # p difference
      #if difference >= 0 #checking to make sure the time is in the future
      # end 
        time_until_event = (difference/60/60).round
        event_obj_array.push(time_until_event.to_s)
        # event_obj_array.push("Time")
        event_obj_array.push("Distance")
        @data.push(event_obj_array)   
      #--------------------------------------------------------------------------------------------------------------
    end





    #TODO
    #--------------------------
    #distinguish old events from new events before they are pulled down from the server
    #show both the hours and minutes to the event 


    #data stuff
    # events_table.dataSource = self #set our controller as the table's dataSource
    # events_table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    

    #what pieces of data are going to go in our cells?
    #the name of the event,
    #the time until the start of the event
    #the miles away from your current location
    #checked, unchecked, or denied (in which it shouldn't even show up in the table)

    # @data = ("A".."Z").to_a
    # @data = [["Name1", "Time1", "Distance1"], ["Name2", "Time2", "Distance2"], ["Name3", "Time3", "Distance3"]]
    # self.addSubview(my_table)
  end

  def initWithNibName(name, bundle: bundle)
    super
    @event = UIImage.imageNamed('event.png')
    @eventSel = UIImage.imageNamed('event-select.png')
    self.tabBarItem = UITabBarItem.alloc.initWithTitle('Event', image: @event, tag: 1)
    self.tabBarItem.setFinishedSelectedImage(@eventSel, withFinishedUnselectedImage:@event)
    self
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath) #special method for picking out cell
    #return the UITableViewCell for the row
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    #this is presupposing that the format of thedata is an array of arrays
    cell.textLabel.text = @data[indexPath.row][0] + " " + @data[indexPath.row][1] + " " + @data[indexPath.row][2]

    #adding acessorytypes to all cells 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    # cell.accessoryType = UITableViewCellAccessoryCheckmark
    # UITableViewCellAccessoryDisclosureIndicator
    # UITableViewCellAccessoryDetailDisclosureButton
    # UITableViewCellAccessoryDetailButton
    # UITableViewCellAccessoryCheckmark

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section) #this is just the count of the data
    #return the number of rows
    @data.count
  end


  #if a row was selected 
  def tableView(tableView, didSelectRowAtIndexPath: indexPath) #this is what runs when you pick one of the rows within the table 
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    p indexPath.row

    
    @new_view = ShowController.alloc.initWithNibName(nil, bundle:nil)
    puts "will this give me a cell?"

    # p @array_events[indexPath.row]

    App::Persistence['show_info'] = @array_events[indexPath.row] 


    self.navigationController.pushViewController(@new_view, animated: true)
    

    # alert = UIAlertView.alloc.init
    # alert.message = "#{@data[indexPath.row]} tapped!"
    # alert.addButtonWithTitle "OK"
    # alert.show
  end


end