class IndexController < UIViewController
  def viewDidLoad
    super

    
    self.view.backgroundColor = UIColor.redColor
    # @window.backgroundColor = UIColor.blackColor

    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)

  end

def initWithNibName(name, bundle: bundle)
    super
    # self.title = "PingIt"
    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem:image:tag: (a custom image can go here (needs to be a 30x30 black and transparent icon))

    self.tabBarItem = UITabBarItem.alloc.initWithTitle("PingIt!", image: "something", tag: 1)

    self
end



end