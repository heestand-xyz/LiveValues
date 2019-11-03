Pod::Spec.new do |spec|

  spec.name         = "LiveValues"
  spec.version      = "1.1.4"

  spec.summary      = "Live Values for iOS & macOS"
  spec.description  = <<-DESC
  					          a collection of live value types for realtime apps.
                      DESC

  spec.homepage     = "http://hexagons.se"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Hexagons" => "anton@hexagons.se" }
  spec.social_media_url   = "https://twitter.com/anton_hexagons"

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"
  spec.tvos.deployment_target = "11.0"
  
  spec.swift_version = '5.0'
  
  spec.source       = { :git => "https://github.com/hexagons/LiveValues.git", :branch => "master", :tag => "#{spec.version}" }

  spec.source_files  = "Source", "Source/**/*.swift"

  spec.ios.exclude_files = "Source/Data/OSC.swift"

  spec.osx.exclude_files = "Source/Data/Motion.swift",
                           "Source/Data/OSC.swift"

  spec.tvos.exclude_files = "Source/Data/Motion.swift",
                            "Source/Data/OSC.swift",
                            "Source/Data/MIDI.swift",
                            "Source/Data/MIDIAssistant.swift"

  #spec.ios.dependency 'OSCKit'
  #spec.osx.dependency 'OSCKit'

end
