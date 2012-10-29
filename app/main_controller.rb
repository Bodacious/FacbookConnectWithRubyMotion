class MainController < UIViewController
  
  
  
  def viewDidLoad
    self.title = "RM Facebook Connect"
    self.view.backgroundColor = UIColor.whiteColor
    view.addSubview(textLabel)    
    view.addSubview(authButton)
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'sessionStateChanged:', name: FBSessionStateChangedNotification, object: nil)
    
    # Check the session for a cached token to show the proper authenticated
    # UI. However, since this is not user intitiated, do not show the login UX.
    appDelegate.openSessionWithAllowLoginUI(false)
  end

  def didReceiveMemoryWarning
    NSNotificationCenter.defaultCenter.removeObserver(self)
  end
    
  # ==============
  # = Properties =
  # ==============
  
  # The Sign-In/Sign Out button
  def authButton
    @authButton ||= begin
      _authButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      _authButton.frame = [[50, 200], [220, 44]]
      _authButton.setTitle("Sign in With Facebook", forState: UIControlStateNormal)
      _authButton.addTarget(self, action: "authButtonAction:", forControlEvents: UIControlEventTouchUpInside)
      _authButton
    end
  end
  
  # Default text to show in textLabel when not signed in
  DEFAULT_TEXT = "Sign in to show username"
  
  # A UILabel showing the user's username once signed in
  def textLabel
    @textLabel ||= begin
      _textLabel = UILabel.alloc.initWithFrame([[50, 140], [220, 44]])
      _textLabel.text = DEFAULT_TEXT
      _textLabel.textAlignment = UITextAlignmentCenter
      _textLabel.textColor = UIColor.lightGrayColor
      _textLabel
    end
  end
  
  
  # ===========
  # = Actions =
  # ===========
  
  # Helper method to access the app delegate 
  def appDelegate
    UIApplication.sharedApplication.delegate
  end
  
  # The action called when the auth button is tapped
  # 
  # If the user is authenticated, log out when the button is clicked.
  # If the user is not authenticated, log in when the button is clicked.
  #   
  # The user has initiated a login, so call the openSession method
  # and show the login UX if necessary.
  def authButtonAction(sender)
    if FBSession.activeSession.open?
      appDelegate.closeSession
    else
      appDelegate.openSessionWithAllowLoginUI(true)
    end
  end
  
  # ============================
  # = Private Instance Methods =
  # ============================
  
  private

  # Populate the textField with the user's username if successfully signed in
  def showUserInfo
    FBRequest.requestForMe.startWithCompletionHandler(lambda do |connection, user, error|
      if error.nil?
        NSLog("#{user.inspect}")
        textLabel.textColor = UIColor.blackColor
        textLabel.text = "#{user[:name]}"
      end
    end)
  end
  
  # Reset the textLable back to gray with DEFAULT_TEXT
  def resetTextLabel
    textLabel.textColor = UIColor.lightGrayColor
    textLabel.text      = DEFAULT_TEXT
  end
  
  # Called when the FBSessionStateChangedNotification is pushed out
  # Changed the text on the authButton and updates the textLabel
  def sessionStateChanged(notification)
    if FBSession.activeSession.open?
      showUserInfo
      authButton.setTitle("Sign out", forState: UIControlStateNormal)
    else
      resetTextLabel
      authButton.setTitle("Sign in with Facebook", forState: UIControlStateNormal)
    end
  end

end