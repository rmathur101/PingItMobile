class IndexController < UIViewController
  def viewDidLoad
    super
    self.title = "Events"
    events_table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.backgroundColor = UIColor.canvasYellow

    events_table.separatorColor = UIColor.charcoal
    events_table.backgroundColor = UIColor.offWhite 
    events_table.sectionIndexTrackingBackgroundColor = UIColor.candyAppleRed
    self.view.addSubview(events_table)

    @data = []
     
    timer = EM.add_periodic_timer 5.0 do
      lat = App::Persistence["user_latitude"]
      long = App::Persistence["user_longitude"]
      if lat && long
        puts "THIS TIMER IS WORKING"

        @user_position = CLLocation.alloc.initWithLatitude(lat, longitude: long) #this is hardcoded but will be updatd on phone using the App::Persistence

        info = {latitude: lat, longitude: long, uid: App::Persistence['current_uid']}
        Event.get_events(info) do |events|

          @data = []
          App::Persistence['events'] = events
          unordered_events = events[:pingas_active_in_radius] + events[:pingas_pending_in_radius] + events[:pingas_outside_radius]

          @events_arr = unordered_events.sort_by do |hash|
            (NSDate.dateWithString(hash[:start_time])).timeIntervalSinceReferenceDate
          end

          # p @events_arr



          # different = NSDate.dateWithString(event_time) - NSDate.date.timeIntervalSinceReferenceDate


          @events_arr.each do |event_obj|

            @event_position = CLLocation.alloc.initWithLatitude(event_obj[:latitude], longitude: event_obj[:longitude])
            distance_meters = @user_position.distanceFromLocation(@event_position)
            distance_miles = (distance_meters / 1609).round(2)
            
            #-------------------------------Attending Events-----------------------------------
            #if the event is like really near by I can send a request to the controller with the uid, the event id, and I can check to see if this event has an RSVP on it for attending - if it does then I can change the status to the attending on that user pinga and then we will have that in the data base 
            #--------------------------------------------------------------------------------------
            
            now_date = NSDate.date#no description
            event_time = event_obj[:start_time]
            # p "current time #{now_date}"
            # p "event start time #{event_time}"
            # p NSDate.dateWithString(event_time)
            # p now_date.strftime("%I:%M%p")
            # p (NSDate.dateWithString(event_time)).strftime("%I:%M %p")
            convert_event_time = (NSDate.dateWithString(event_time)).timeIntervalSinceReferenceDate #DON'T THINK I NEED TO CONVERT TO DATE WITH STRING
            convert_event_time_no_interval = NSDate.dateWithString(event_time)
            # p "This is event time: #{convert_event_time_no_interval} with dateWithString"
            difference = convert_event_time - NSDate.date.timeIntervalSinceReferenceDate
            # p "This is difference: #{difference}"
            hours = (difference / 60 / 60 ).floor
            # p "This is hours: #{hours}"
            min = ((difference - (hours * 60 * 60)) / 60).floor 

            event_obj_array = []
            event_obj_array.push(event_obj[:title])
            event_obj_array.push("#{hours}hr#{min}min")
            event_obj_array.push("#{distance_miles} miles")
            @data.push(event_obj_array)  
          end
          events_table.reloadData
        end
      end
    end

    #data stuff 
    events_table.dataSource = self #set our controller as the table's dataSource
    events_table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
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
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end
    #this is presupposing that the format of thedata is an array of arrays
    cell.textLabel.text = @data[indexPath.row][0]
    # cell.detailTextLabel.text = @data[indexPath.row[1] + " " + @data[indexPath.row][2]

    cell.detailTextLabel.text = "#{@data[indexPath.row][2]}    #{@data[indexPath.row][1]}"
    #adding acessorytypes to all cells 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed('markers/user_marker.png')
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

    App::Persistence['show_info'] = @events_arr[indexPath.row] 

    self.navigationController.pushViewController(@new_view, animated: true)   
  end

  def request_events
  end


end