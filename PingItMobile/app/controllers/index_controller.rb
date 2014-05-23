class IndexController < UIViewController
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
    table_header_view.addSubview(@label)
    @label.textColor = UIColor.whiteColor


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
    # @data = ("A".."Z").to_a
    @data = ["This", "is", "an", "array", "of", "words", "that", "make", "a", "sentence", "and", "it", "is", "awesome"]
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
    cell.textLabel.text = @data[indexPath.row] + " and something"

    #adding acessorytypes to all cells 
    cell.accessoryType = UITableViewCellAccessoryDetailButton
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

    alert = UIAlertView.alloc.init

    alert.message = "#{@data[indexPath.row]} tapped!"
    alert.addButtonWithTitle "OK"
    alert.show
  end




end