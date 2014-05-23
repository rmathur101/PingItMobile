class AppDelegate

  ::FBSessionStateChangedNotification = "#{App.identifier}:FBSessionStateChangedNotification"

  # The extra permissions we're requesting from Facebook
  # By default, the basics are already provided https://developers.facebook.com/docs/reference/login/basic-info/
  FBPermissions = %w{ user_birthday user_hometown user_location }

  # ==============
  # = Properties =
  # ==============

  # The main controller for this app
  def controller
    @controller ||= MainController.new
  end

  # Wrap the main controller in a UINavigationController
  def navController
    @navController ||= UINavigationController.alloc.initWithRootViewController(controller)
  end

  # The main window object
  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  # =============
  # = Callbacks =
  # =============

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    authenticate
    # window.rootViewController = navController
    # window.makeKeyAndVisible
    true
  end

  def applicationDidBecomeActive(application)
    # We need to properly handle activation of the application with regards to SSO
    # (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    FBSession.activeSession.handleDidBecomeActive
  end

  def applicationWillTerminate(application)
    # Kill the Facebook session when the application terminates
    FBSession.activeSession.close
  end

  def authenticate
    # if FBSession.activeSession.open? #if else condition removed for easy access to landing page (no fb login)
      # Create Ping Form
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
                value: "Social"
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
              { # End Time Row
                title: "End",
                key: :end_time,
                type: :date,
                picker_mode: :time,
                value: '8:00 PM',
                input_accessory: :done #adds a Done button to the date picker               
              }
            ] 
          },
          { # Where Section
            title: "Where Are We Meeting?",
            rows: 
            [
              { # Address Row
                title: "Address",
                key: :address,
                type: :string
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

      # Tab Bar
      tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)

      # Tab Bar Items
      index_controller = IndexController.alloc.initWithNibName(nil, bundle:nil)
      map_controller = MapController.alloc.initWithNibName(nil, bundle:nil)
      create_controller = CreateController.alloc.initWithForm(create_form)

      tab_controller.viewControllers = [index_controller, map_controller, create_controller]
      window.rootViewController = tab_controller
      window.makeKeyAndVisible
    # else
    #   main_controller = MainController.alloc.initWithNibName(nil, bundle:nil)
    #   window.rootViewController = main_controller #goes to MainController      
    #   window.makeKeyAndVisible
    # end

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

    UIAlertView.alloc.initWithTitle("Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: nil).show if error
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

end
