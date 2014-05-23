class CreateController < UIViewController
  def viewDidLoad
    super

    
    self.view.backgroundColor = UIColor.orangeColor
    # @window.backgroundColor = UIColor.blackColor

    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 3)


  end

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("MakeIt!", image: "something", tag: 3)
    self
  end



end