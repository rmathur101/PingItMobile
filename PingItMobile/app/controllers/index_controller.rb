class IndexController < UIViewController
  def viewDidLoad
    super
    self.title = "Events"
    events_table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.backgroundColor = UIColor.canvasYellow
    # initiating table
    events_table.separatorColor = UIColor.charcoal
    events_table.backgroundColor = UIColor.offWhite 
    events_table.sectionIndexTrackingBackgroundColor = UIColor.candyAppleRed
    self.view.addSubview(events_table)



    # puts "PERSISTED USER LAT LONG INFO"
    # p App::Persistence["user_latitude"] #THIS IS WHAT IS CAUSING THE GEO TO PRINTED OUT REPEAT
    # p App::Persistence["user_longitude"]


  

    @data = []

        # lat = App::Persistence["user_latitude"]
        # long = App::Persistence["user_longitude"]
     
    timer = EM.add_periodic_timer 5.0 do
      lat = App::Persistence["user_latitude"]
      long = App::Persistence["user_longitude"]
      if lat && long
        puts "THIS TIMER IS WORKING"


        # lat = 41.889911
        # long = -87.637657 
        #@user_position = CLLocation.alloc.initWithLatitude(lat, longitude: long)
        @user_position = CLLocation.alloc.initWithLatitude(lat, longitude: long) #this is hardcoded but will be updatd on phone using the App::Persistence

        info = {latitude: lat, longitude: long, uid: App::Persistence['current_uid']}
        Event.get_events(info) do |events|
          # p events
          @data = []
          App::Persistence['events'] = events
          events_arr = events[:pingas_active_in_radius] + events[:pingas_pending_in_radius] 
          events_arr.each do |event_obj|
            event_obj_array = []
            event_obj_array.push(event_obj[:title])

            @event_position = CLLocation.alloc.initWithLatitude(event_obj[:latitude], longitude: event_obj[:longitude])
            distance_meters = @user_position.distanceFromLocation(@event_position)
            distance_miles = (distance_meters / 1609).round(2)
            # p event_obj[:address]
            # p "USER LAT LONG: #{lat} #{long}"
            # p "EVENT LAT LONG: #{event_obj[:latitude]} #{event_obj[:longitude]}"
            # p "DISTANCE METERS: #{distance_meters}"
            # p "DISTANCE MILES #{distance_miles}"
            # puts ""
            
            now_date = NSDate.date#no description
            event_time = event_obj[:start_time]
            convert_event_time = (NSDate.dateWithString(event_time)).timeIntervalSinceReferenceDate #DON'T THINK I NEED TO CONVERT TO DATE WITH STRING
            convert_event_time_no_interval = NSDate.dateWithString(event_time)
            # p "This is event time: #{convert_event_time_no_interval} with dateWithString"
            difference = convert_event_time - NSDate.date.timeIntervalSinceReferenceDate
            # p "This is difference: #{difference}"
            hours = (difference / 60 / 60 ).floor
            # p "This is hours: #{hours}"
            min = ((difference - (hours * 60 * 60)) / 60).floor 

            event_obj_array.push("#{hours}hr#{min}min")
            event_obj_array.push("#{distance_miles} miles")

            @data.push(event_obj_array)  
          end
          events_table.reloadData
        end
      end
    end


#------------------------------------------------------------------------------------------------------------
    #@user_position = CLLocation.alloc.initWithLatitude(lat, longitude: long)

    # # App::Persistence.delete('events') #USE THIS TO DELETE THE PERSISTENCE DATA 
    # @data = []
    # Event.get_events do |events| #need to make sure that the program does not move on until we have a response back from this http request 
    #   # p "these are the events i am getting from the web app"
    #   # p events   
    #   App::Persistence['events'] = events 
    #   @array_events = App::Persistence['events'] 
    #   p events
    #   events.each do |event_obj|
    #     event_obj_array = []
    #     event_obj_array.push(event_obj[:title])
    #     @array_events = App::Persistence['events'] 
    #     # p @array_events
    #     @event_position = CLLocation.alloc.initWithLatitude(event_obj[:latitude], longitude: event_obj[:longitude])
    #     distance_meters = @user_position.distanceFromLocation(@event_position)
    #     distance_miles = (distance_meters / 1609).round(2)
    #     # p event_obj[:address]
    #     # p "USER LAT LONG: #{lat} #{long}"
    #     # p "EVENT LAT LONG: #{event_obj[:latitude]} #{event_obj[:longitude]}"
    #     # p "DISTANCE METERS: #{distance_meters}"
    #     # p "DISTANCE MILES #{distance_miles}"
    #     # puts ""
        
    #     now_date = NSDate.date#no description
    #     # p "This is current time: #{now_date}"
    #     event_time = event_obj[:start_time]
    #     # p event_time
    #     # p NSDate.dateWithString(event_time)
    #     convert_event_time = (NSDate.dateWithString(event_time)).timeIntervalSinceReferenceDate #DON'T THINK I NEED TO CONVERT TO DATE WITH STRING
    #     convert_event_time_no_interval = NSDate.dateWithString(event_time)
    #     # p "This is event time: #{convert_event_time_no_interval} with dateWithString"
    #     difference = convert_event_time - NSDate.date.timeIntervalSinceReferenceDate
    #     # p "This is difference: #{difference}"
    #     hours = (difference / 60 / 60 ).floor
    #     # p "This is hours: #{hours}"
    #     min = ((difference - (hours * 60 * 60)) / 60).floor 

    #     event_obj_array.push("#{hours}hr#{min}min")
    #     event_obj_array.push("#{distance_miles} miles")
    #     @data.push(event_obj_array)   
    #   end
    #   events_table.reloadData
    # end
  #---------------------------------------------------------------
  

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

    @array_events = App::Persistence['events'] #probably can convert this and the next line into one
    App::Persistence['show_info'] = @array_events[indexPath.row] 
    # App::Persistence['show_info'] = event_obj_array[indexPath.row] 

    self.navigationController.pushViewController(@new_view, animated: true)   
  end

  def request_events
  end


end