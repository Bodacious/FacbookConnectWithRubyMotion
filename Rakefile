# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'FacebookApp'

  app.frameworks    = ["UIKit", "Foundation", 'AdSupport', 'Accounts', 'Social']
  app.weak_frameworks += %w{ AdSupport Accounts Social }

  app.pods do
    pod 'Facebook-iOS-SDK', '~> 3.1.1'
  end

  app.device_family          = :iphone
  app.interface_orientations = [:portrait]

  raise "Please add your app ID in the two lines below" # <= remove this once you've added your app ID
  # Required for Facebook SDK
  app.info_plist['FacebookAppID'] = '<your app ID here>'
  app.info_plist['URL types'] = { 'URL Schemes' => 'fb<your app ID here>'}
end
