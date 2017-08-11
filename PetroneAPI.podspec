#
#  Be sure to run `pod spec lint PetroneAPI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "PetroneAPI"
  s.version      = "0.0.2"
  s.summary      = "PetroneAPI for iOS."
  s.homepage     = "https://github.com/petrone/PetroneAPI_swift"
  s.license      = { type: "MIT", file: "LICENSE" }
  s.author       = { "BYROBOT" => "dev@byrobot.co.kr" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/petrone/PetroneAPI_swift.git", :tag => "#{s.version}" , submodules: true}
  s.source_files  = "PetroneAPI", "PetroneAPI/**/*.{h,m,swift}"
  s.exclude_files = "PetroneAPI/Exclude"

  s.framework  = "CoreBluetooth"
end
