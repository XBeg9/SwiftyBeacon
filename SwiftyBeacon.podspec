Pod::Spec.new do |s|

  s.name         = "SwiftyBeacon"
  s.version      = "0.1.5"
  s.license      = "MIT"
  s.summary      = "SwiftyBeacon is an iBeacon manager which will save you time."
  s.homepage     = "https://github.com/XBeg9/SwiftyBeacon"
  s.source       = { :git => "https://github.com/XBeg9/SwiftyBeacon.git", :tag => s.version }
  
  s.author             = { "Fedya Skitsko" => "fedya@skitsko.com" }
  s.social_media_url   = "http://twitter.com/skitsko"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.source_files = 'Source/*.swift'
  
  s.requires_arc = true
end
