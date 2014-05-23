class ShowController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.greenColor
    # self.






  end

  # def initWithNibName(name, bundle: bundle)
  #   super
  #   self.tabBarItem = UITabBarItem.alloc.initWithTitle("MakeIt!", image: "something", tag: 3)
  #   self
  # end

  def initWithParams(params = {})
    init()
    self.stuff1 = params[:stuff1]
    self.stuff2 = params[:stuff2]

  end



end