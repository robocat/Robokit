Pod::Spec.new do |s|
  s.name = 'Robokit'
  s.version = '1.1.3'
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
    :tag => '1.1.3'
  }
  s.source_files = 'Robokit/Source/*.{h,m}', 'Robokit/Frameworks/RevMobAds.framework/Headers/*.h'
  s.resources = ['Robokit/Localizations/**', 'Robokit/Resources/**']
  s.frameworks = 'Accounts', 'Social', 'Foundation', 'UIKit', 'SystemConfiguration', 'RevMobAds'
  s.requires_arc = true
  s.preserve_paths = 'Robokit/Frameworks/RevMobAds.framework/*'
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/RevMobAds"' }
end
