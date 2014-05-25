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



    Event.get_events do |event|
      p "THIS IS CALLBACK AFTER THE GET_EVENTS HTTP REQUEST IS MADE"
      p event[0]

      event.each do |this_event|
        new_event =  Event.new(this_event)
        p new_event

      end

    end

    puts "ALL EVENTS"
    p Event.all




    # p lots_of_data 
    # puts "THIS IS AN EXAMPLE OF THE DATETIME THAT I AM GETTING FROM THE WEBAPP"
    # p (@event_information[0]).start_time

    # puts "THIS IS THE DATE THAT I AM GETTING FROM THE PHONE"
    # p NSDate.date
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
    @data = [["Name1", "Time1", "Distance1"], ["Name2", "Time2", "Distance2"], ["Name3", "Time3", "Distance3"]]


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




end