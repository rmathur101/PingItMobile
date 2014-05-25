class IndexController < UITableViewController
  def viewDidLoad
    super

    #initiating table
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.separatorColor = UIColor.blackColor
    @table.backgroundColor = UIColor.blackColor
    self.view.addSubview(@table)
    self.title = "Pings near you!"
    self.view.backgroundColor = UIColor.blackColor

#--------------------------------------------PARSING THE EVENT DATA FROM HEROKU IN A FORM FOR PHONE APP

#QUESTIONS
#------------------------------------
#How to clear the App:Persistence???
# NSUserDefaults.resetStandardUserDefaults (was hoping that this was going to delete the things that were in APP::Peristence)  

Event.get_events do |event|
  App::Persistence['events'] = event 
end

array_events = App::Persistence['events'] 
p array_events
test_time = array_events[0][:start_time]
p test_time
new_test_time = test_time.gsub(/\.\d*/, "")
# p new_test_time
converted_ruby_date = Time.iso8601(new_test_time)
motion_date = NSDate.date

p converted_ruby_date
p motion_date

difference = motion_date - converted_ruby_date 
p difference/60/60

# p Time.iso8601(test_time)
# 2014-05-24T21:41:09.165Z #the original time getting form the hash
# 2014-05-24T21:41:165Z #the edited time to make it look more like the bubble wrap example
# 2012-05-31T19:41:33Z #the example that bubble wrap gave us 



    #----------------------------------------------------------------------------

    #data stuff
    @table.dataSource = self #set our controller as the table's dataSource
    @table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    

    #what pieces of data are going to go in our cells?
    #the name of the event,
    #the time until the start of the event
    #the miles away from your current location
    #checked, unchecked, or denied (in which it shouldn't even show up in the table)

    # @data = ("A".."Z").to_a
    # @data = [["Name1", "Time1", "Distance1"], ["Name2", "Time2", "Distance2"], ["Name3", "Time3", "Distance3"]]

    @data = []
    array_events.each do |event_obj| 
      event_obj_array = []
      event_obj_array.push(event_obj[:title])

      event_time = event_obj[:start_time]
      convert_event_time = Time.iso8601(event_time.gsub(/\.\d*/, ""))
      difference = convert_event_time - NSDate.date
      time_until_event = (difference/60/60).round
      event_obj_array.push(time_until_event.to_s)
      

      # event_obj_array.push("Time")

      event_obj_array.push("Distance")
      @data.push(event_obj_array)   
    end

    #TODO
    #--------------------------
    #distinguish old events from new events before they are pulled down from the server
    #show both the hours and minutes to the event 


  end

  def initWithNibName(name, bundle: bundle)
      super
      self.tabBarItem = UITabBarItem.alloc.initWithTitle("PingIt!", image: "something", tag: 1)
      self
  end

  # Methods to conform to TableView delegate protocol
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

    
    @new_view = ShowController.alloc.initWithNibName(nil, bundle:nil)


    self.navigationController.pushViewController(@new_view, animated: true)
    

    # alert = UIAlertView.alloc.init
    # alert.message = "#{@data[indexPath.row]} tapped!"
    # alert.addButtonWithTitle "OK"
    # alert.show
  end

  def return_this_thing(event)
    this_event = event
    return this_event
  end




end