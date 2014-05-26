class IndexController < UIViewController
  def viewDidLoad
    super

    self.title = "Events"

    events_table = UITableView.alloc.initWithFrame(self.view.bounds)
    

    self.view.addSubview(events_table)


#-------------------------------------------------------time logic
    # p Time.iso8601(test_time)
    # 2014-05-24T21:41:09.165Z #the original time getting form the hash
    # 2014-05-24T21:41:165Z #the edited time to make it look more like the bubble wrap example
    # 2012-05-31T19:41:33Z #the example that bubble wrap gave us 
#-------------------------------------------------------------------------


# App::Persistence.delete('events') #USE THIS TO DELETE THE PERSISTENCE DATA 


$request_boolean = "false"


  # while $request_boolean == "false"
    Event.get_events do |event| #need to make sure that the program does not move on until we have a response back from this http request 
      p event   
      App::Persistence['events'] = event 
      $boolean_request = event
      p $request_boolean
      $request_boolean == "true"
    end
  # end

    @array_events = App::Persistence['events'] 
    # p @array_events



    #data stuff
    events_table.dataSource = self #set our controller as the table's dataSource
    events_table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    

    # @data = [["will", "this", "think"]]

    @data = []
    @array_events.each do |event_obj| 
      event_obj_array = []
      event_obj_array.push(event_obj[:title])

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

# semiphor (used for multi threading of stuff)

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

    self.navigationController.pushViewController(@new_view, animated: true)   
  end


end