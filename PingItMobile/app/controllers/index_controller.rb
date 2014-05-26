class IndexController < UIViewController
  def viewDidLoad
    super
    self.title = "Events"

    events_table = UITableView.alloc.initWithFrame(self.view.bounds)

    # events_table.backgroundView = self.view

    self.view.backgroundColor = UIColor.canvasYellow
    # initiating table
    events_table.separatorColor = UIColor.charcoal
    events_table.backgroundColor = UIColor.offWhite 
    events_table.sectionIndexTrackingBackgroundColor = UIColor.candyAppleRed

    

    self.view.addSubview(events_table)

#-------------------------------------------------------time logic
    # p Time.iso8601(test_time)
    # 2014-05-24T21:41:09.165Z #the original time getting form the hash
    # 2014-05-24T21:41:165Z #the edited time to make it look more like the bubble wrap example
    # 2012-05-31T19:41:33Z #the example that bubble wrap gave us 
#-------------------------------------------------------------------------


    # App::Persistence.delete('events') #USE THIS TO DELETE THE PERSISTENCE DATA 

    @data = []

    Event.get_events do |events| #need to make sure that the program does not move on until we have a response back from this http request 
      p "these are the events i am getting from the web app"
      p events   
      App::Persistence['events'] = events 
      @array_events = App::Persistence['events'] 
      # # $request_boolean == "true"
      events.each do |event_obj|
        event_obj_array = []
        event_obj_array.push(event_obj[:title])
        
        









        # p "THE CURRENT DATETIME"
        # current_time =  NSDate.date.timeIntervalSinceReferenceDate
        # p current_time
        

        event_time = event_obj[:start_time]
        convert_event_time = (NSDate.dateWithString(event_time)).timeIntervalSinceReferenceDate
        # p "THE CONVERTED START TIME"
        # p convert_event_time 
      
        # difference = convert_event_time - NSDate.date
        # p difference
        #if difference >= 0 #checking to make sure the time is in the future
        # end 

        # event_obj_array.push(time_until_event.to_s)
        event_obj_array.push("Time")
        event_obj_array.push("Distance")
        @data.push(event_obj_array)   
      end
      # p @array_events
      events_table.reloadData
    end

    #data stuff
    events_table.dataSource = self #set our controller as the table's dataSource
    events_table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    

    # @data = [["will", "this", "think"]]


  end

  def get_events
    Event.get_events do |event| #need to make sure that the program does not move on until we have a response back from this http request 
      p "INSIDE GET_EVENTS"
      App::Persistence['events'] = event 
      $boolean_request = event
    end
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

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section) #this is just the count of the data
    #return the number of rows
    @data.count
  end


  #if a row was selected 
  def tableView(tableView, didSelectRowAtIndexPath: indexPath) #this is what runs when you pick one of the rows within the table 
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    @new_view = ShowController.alloc.initWithNibName(nil, bundle:nil)

    App::Persistence['show_info'] = @array_events[indexPath.row] 
    # App::Persistence['show_info'] = event_obj_array[indexPath.row] 


    self.navigationController.pushViewController(@new_view, animated: true)   
  end


end