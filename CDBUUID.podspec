#
# Be sure to run `pod lib lint CDBUUID.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

@version = "1.0.1"

Pod::Spec.new do |s|
  s.name             = "CDBUUID"
  s.version          = @version
  s.summary          = "The CDBUUID provides methods for generating compact, unique ids"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = "The CDBUUID class provides methods for generating compact, unique ids.
  It based on `Identify` class of https://github.com/weaver/Identify
  but with removed ASIdentifierManager which has issue when submitting to the app store
  Ids are encoded as urlsafe base64 (letters, numbers, underscores, dashes),
  any `=` padding is stripped off, and they are given a single character
  prefix."

  s.homepage         = "https://github.com/truebucha/CDBUUID"
  s.license          = 'MIT'
  s.author           = { "truebucha" => "truebucha@gmail.com" }
  s.source           = { :git => "https://github.com/truebucha/CDBUUID.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/truebucha'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'

  s.source_files = 'CDBUUID/Classes/**/*'

end
