# Reopen and extend
class UIViewController
  def self.maps_api_key
    "AIzaSyD2lvh7HdRhNbDSyRvNOsph4boJOiuKNW4"
  end
  # Helper method to access the app delegate
  # def appDelegate
  #   UIApplication.sharedApplication.delegate
  # end
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

::FBSessionStateChangedNotification = "5ZYPULWM24.com.herokuapp.pingit:FBSessionStateChangedNotification"
  
# The extra permissions we're requesting from Facebook
# By default, the basics are already provided https://developers.facebook.com/docs/reference/login/basic-info/
FBPermissions = %w{ user_birthday user_hometown user_location }

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def facebook_controller
    @facebook_controller ||= FacebookController.alloc.initWithNibName(nil, bundle: nil)
  end

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
    window.makeKeyAndVisible
    auth_with_facebook
  end

  def auth_with_facebook
    if FBSession.activeSession.open?
      puts "Logged In!"
      p user = facebook_controller.user
      p user_id = user[:id]
      p @@accessToken = FBSession.activeSession.accessToken
      p @@expirationDate = FBSession.activeSession.expirationDate
      # ---- Check if user exists in database




  # create_table "users", force: true do |t|
  #   t.string   "oauth_token"
  #   t.datetime "oauth_expires_at"
  #   t.float    "latitude"
  #   t.float    "longitude"
  #   t.datetime "created_at"
  #   t.datetime "updated_at"
  #   t.string   "name"
  #   t.string   "provider"
  #   t.string   "uid"
  #   t.string   "ip_address"
  #   t.float    "listening_radius"
  # end



      #----- if not, create user 
      user_hash = {uid: user_id, oauth_expires_at: @@expirationDate, oauth_token: @@accessToken, name: user[:name], provider: "facebook" }
      # user_hash = {uid: user_id, oauth_token: @@accessToken, name: user[:name], provider: "facebook", listening_radius: 1}


      User.verify_or_create_user(user_hash) do |response|
        # if response[:user_exists] == "false"
          # create a new user
          # puts "A user with id #{user_id} and name #{user.name} does NOT EXIST"
        # end
        # puts "A user with id #{user_id} and name #{user.name} EXISTS!"
      end
        map_controller = MapController.alloc.initWithNibName(nil, bundle: nil)
        create_controller = CreateController.alloc.initWithForm(create_form)
        @index_controller = IndexController.alloc.initWithNibName(nil, bundle: nil)
        @index_nav_controller = UINavigationController.alloc.initWithRootViewController(@index_controller)
        
        tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
        tab_controller.viewControllers = [map_controller, @index_nav_controller, create_controller]
        tab_controller.selectedIndex = 1

        window.rootViewController = tab_controller
      # puts "user_already_exists #{user_already_exists}"
      # # User.already_exists?(user_id) do |response|
      # #   p response
      # #   # create a new user in the database  
      # #   puts "User with uid #{user_id} already exists!"
      # # end


    else
      window.rootViewController = facebook_controller
    end
  end

  # def user
  #   facebook_controller.return_user
  #   @@user ||= facebook_controller.user
  #   return @@user
  # end

  def applicationDidBecomeActive(application)
    # We need to properly handle activation of the application with regards to SSO
    # (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    FBSession.activeSession.handleDidBecomeActive
  end
  
  def applicationWillTerminate(application)
    # Kill the Facebook session when the application terminates
    FBSession.activeSession.close
  end
  
  # ===========================================================================================================
  # = Facebook Methods - https://developers.facebook.com/docs/howtos/login-with-facebook-using-ios-sdk/#setup =
  # ===========================================================================================================

  # Callback for session changes.
  # If the statei s FBSessionStateOpen, do nothing...
  # If the state is FBSessionStateClosed or FBSessionStateClosedLoginFailed, close the Facebook session
  # 
  # Pushes out a FBSessionStateChangedNotification to any objects who are observing
  # 
  # Finally, if there's an error object, shows an alert dialogue with the error description 
  def sessionStateChanged(session, state: state, error: error)
    case state
    when FBSessionStateOpen
      unless error
        # We have a valid session
        NSLog("User session found")
      end
    when FBSessionStateClosed, FBSessionStateClosedLoginFailed
      FBSession.activeSession.closeAndClearTokenInformation
    end

    NSNotificationCenter.defaultCenter.postNotificationName(FBSessionStateChangedNotification, object: session)

    # UIAlertView.alloc.initWithTitle("Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show if error
    UIAlertView.alloc.initWithTitle("We're Sorry", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show if error
  end


  # Opens a Facebook session and optionally shows the login UX.
  def openSessionWithAllowLoginUI(allowLoginUI)
    completionBlock = Proc.new do |session, state, error|
      sessionStateChanged(session, state: state, error: error)
    end
    FBSession.openActiveSessionWithReadPermissions(FBPermissions, allowLoginUI: allowLoginUI, completionHandler: completionBlock)
  end
  
  # If we have a valid session at the time of openURL call, we handle
  # Facebook transitions by passing the url argument to handleOpenURL (< iOS 6)
  # 
  # Returns a Boolean value
  def application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    # attempt to extract a token from the url
    FBSession.activeSession.handleOpenURL(url)
  end  

  # Close the Facebook session when done
  def closeSession
    FBSession.activeSession.closeAndClearTokenInformation
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
              input_accessory: :done, #adds a Done button to the date picker
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
