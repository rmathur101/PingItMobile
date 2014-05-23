class IndexController < UIViewController
  def viewDidLoad
    super
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    # @table.backgroundColor = UIColor.blackColor

    table_header_view = UIView.alloc.initWithFrame([[0, 0], [300, 60]])
    table_header_view.backgroundColor = UIColor.blueColor

    @table.tableHeaderView = table_header_view


    @label = UILabel.alloc.initWithFrame(CGRectZero) 

    @label.text = "Pings Near You"

    @label.sizeToFit 

    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 15) 
    table_header_view.addSubview(@label)








    self.view.backgroundColor = UIColor.redColor
    self.view.addSubview(@table)
    # @window.backgroundColor = UIColor.blackColor
    @table.dataSource = self #set our controller as the table's dataSource
    @table.delegate = self #delegate has to do with how the table looks and how the user interacts with it
    @data = ("A".."Z").to_a
  end

  def initWithNibName(name, bundle: bundle)
      super
      # self.title = "PingIt"
      # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
      # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem:image:tag: (a custom image can go here (needs to be a 30x30 black and transparent icon))
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
    cell.textLabel.text = @data[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section) #this is just the count of the data
    #return the number of rows
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath) #this is what runs when you pick one of the rows within the table 
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    alert = UIAlertView.alloc.init

    alert.message = "#{@data[indexPath.row]} tapped!"
    alert.addButtonWithTitle "OK"
    alert.show
  end



end