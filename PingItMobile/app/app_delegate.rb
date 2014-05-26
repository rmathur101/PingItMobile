# Reopen and extend
class UIViewController
  def self.maps_api_key
    "AIzaSyD2lvh7HdRhNbDSyRvNOsph4boJOiuKNW4"
  end
  # Helper method to access the app delegate
  def appDelegate
    UIApplication.sharedApplication.delegate
  end
end

# Add Colors...
class UIColor
  def self.candyAppleRed 
    UIColor.colorWithRed(0.93, green: 0.13, blue: 0.14, alpha: 1.0)
  end
  def self.canvasYellow
    UIColor.colorWithRed(1.0, green: 0.89, blue: 0.51, alpha: 1.0)
  end
  def self.offWhite
    UIColor.colorWithRed(0.98, green: 0.98, blue: 0.99, alpha: 1.0)
  end
  def self.charcoal
    UIColor.colorWithRed(0.2, green: 0.18, blue: 0.17, alpha: 1.0)
  end
  def self.forestGreen
    UIColor.colorWithRed(0.05, green: 0.49, blue: 0.37, alpha: 1.0)
  end
end

class AppDelegate

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end
  GOOGLE_MAP_API_KEY = "AIzaSyD2lvh7HdRhNbDSyRvNOsph4boJOiuKNW4"

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
    map_controller = MapController.alloc.initWithNibName(nil, bundle: nil)
    create_controller = CreateController.alloc.initWithForm(create_form)
    @index_controller = IndexController.alloc.initWithNibName(nil, bundle: nil)
    @index_nav_controller = UINavigationController.alloc.initWithRootViewController(@index_controller)
    
    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [map_controller, @index_nav_controller, create_controller]
    tab_controller.selectedIndex = 1

    window.rootViewController = tab_controller
    window.makeKeyAndVisible
  end

  def create_form
    create_form = Formotion::Form.new({
      title: "PingIt",
      sections: 
      [
        { # What Section
          title: "What's Going On?",
          rows: 
          [
            { # Title Row
              title: "Name",
              key: :title,
              type: :string,
              placeholder: 'My Event',
              auto_correction: :no,
              auto_capitalization: :words
            },
            { # Description Row
              title: "Description",
              key: :description,
              type: :text,
              row_height: 75,
              placeholder: 'Event Description',
              auto_correction: :yes,
              auto_capitalization: :sentences
            },
            { # Category Row
              title: "Category",
              key: :category,
              type: :picker,
              items: ["Social", "Sports", "Food", "Entertainment", "Deal", "Other"],
              value: "Social",
              input_accessory: :done #adds a Done button to the category picker     
            }
          ]
        },
        { # When Section
          title: "When Is It Happening?",
          rows: 
          [
            { # Start Time Row
              title: "Start",
              key: :start_time,
              type: :date,
              picker_mode: :time,
              value: '6:00 PM',
              input_accessory: :done #adds a Done button to the date picker
            },
            { # Duration Row
              title: "Duration",
              key: :duration,
              type: :picker,
              items: ["1", "2", "3", "4", "5", "6"],
              value: "1",
              input_accessory: :done
            }
            # { # End Time Row
            #   title: "End",
            #   key: :end_time,
            #   type: :date,
            #   picker_mode: :time,
            #   value: '8:00 PM',
            #   input_accessory: :done #adds a Done button to the date picker               
            # }
          ] 
        },
        { # Where Section
          title: "Where Are We Meeting?",
          rows: 
          [
            { # Address Row
              title: "Address",
              key: :address,
              type: :string,
              input_accessory: :done #adds a Done button to the address input     
            },
            # { # Map with Pin???
            #   title: "Ping It!",
            #   type: :static
            # },
            { # Submit form
              title: "Ping It!",
              type: :submit
            }
          ]
        }
      ]
    })
  end

end
