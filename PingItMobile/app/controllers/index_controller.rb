class IndexController < UITableViewController
  def viewDidLoad
    super

    #initiating table
    @table = UITableView.alloc.initWithFrame(self.view.bounds)

    @table.separatorColor = UIColor.blackColor

    #creating view which will be the table header and giving it properities (background color, etc)
    table_header_view = UIView.alloc.initWithFrame([[0, 0], [300, 60]])
    table_header_view.backgroundColor = UIColor.blackColor

    #setting the tableHeadeView property equal to the table_header_view initialized above 
    @table.tableHeaderView = table_header_view




    #creating a label object and giving it properties and adding it as a subview of the table_header_view
    @label = UILabel.alloc.initWithFrame(CGRectZero) 
    @label.text = "Pings Near You"
    @label.sizeToFit 
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 15) 
    @label.textColor = UIColor.whiteColor
    table_header_view.addSubview(@label)


    # @table.backgroundView = nil



    # @table.backgroundColor = UIColor.redColor;
    # this_background = UIView.alloc.initWithFrame(self.view.bounds)
    # this_background.backgroundColor = UIColor.blackColor;
    @table.backgroundColor = UIColor.blackColor


    # self.view.backgroundColor = UIColor.redColor
    self.view.addSubview(@table)




    #data stuff
    @table.dataSource = self #set our controller as the table's dataSource
    @table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    

    #what pieces of data are going to go in our cells?
    #the name of the event,
    #the time until the start of the event
    #the miles away from your current location
    #checked, unchecked, or denied (in which it shouldn't even show up in the table)



    # @data = ("A".."Z").to_a
    # @data = ["This", "is", "an", "array", "of", "words", "that", "make", "a", "sentence", "and", "it", "is", "awesome"]

    @data = [["NAME1", "TIME1", "DISTANCE1"], ["NAME2", "TIME2", "DISTANCE2"], ["NAME3", "TIME3", "DISTANCE3"]]


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

    # @new_view = UIView.alloc.initWithFrame([[0, 0], [300, 60]])
    # @new_view.backgroundColor = UIColor.greenColor
    # @new_label = UILabel.alloc.initWithFrame(CGRectZero)
    # @new_label.text "This is a new page"
    # @new_label.sizeToFit
    # @new_label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 15) 
    # @new_view.addSubview()


    @this_map = MapController.alloc.initWithNibName(nil, bundle:nil)


    @new_view = ShowController.alloc.initWithNibName(nil, bundle:nil)



    puts "WHAT IS THIS???"
    p self
    p self.navigationController

    self.navigationController.pushViewController(@new_view, animated: true)
    

    # alert = UIAlertView.alloc.init
    # alert.message = "#{@data[indexPath.row]} tapped!"
    # alert.addButtonWithTitle "OK"
    # alert.show
  end




end