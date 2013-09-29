Pod::Spec.new do |s|
  s.name = 'Robokit'
  s.version = '1.1.2'
  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }
  s.summary = 'The shared Robocat iOS toolkit'
  s.platform = :ios, "7.0"
  s.homepage = 'robo.cat'
  s.author = {
    'Ulrik Flænø Damm' => 'ulrik@robo.cat',
    'Kristian Andersen' => 'kristian@robo.cat'
  }
  s.source = {
    :git => 'https://github.com/robocat/Robokit.git',
    :tag => '1.1.2'
  }
  s.source_files = "Robokit/Source/*.{h,m}"
  s.resources = ['Robokit/Localizations/**', 'Robokit/Resources/**']
  s.frameworks = 'Accounts', 'Social', 'Foundation', 'UIKit', 'SystemConfiguration'
  s.requires_arc = true
  s.ios.vendored_frameworks = 'Frameworks/RevMobAds.framework'
end
