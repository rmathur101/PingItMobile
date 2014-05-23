class MapController < UIViewController
  def viewDidLoad
    super
    

    self.view.backgroundColor = UIColor.yellowColor
    # @window.backgroundColor = UIColor.blackColor

    # self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 2)

  end

def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("SeeIt!", image: "something", tag: 2)

    self
  end



end