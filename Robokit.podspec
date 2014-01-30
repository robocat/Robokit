Pod::Spec.new do |s|
  s.name = 'Robokit'
  s.version = '1.1.11'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'The shared Robocat iOS toolkit'
  s.homepage = 'robo.cat'
  s.authors = { 'Ulrik Flænø Damm' => 'ulrik@robo.cat', 'Kristian Andersen' => 'kristian@robo.cat' }
  s.source = { :git => 'https://github.com/robocat/Robokit.git', :branch => :master }

  s.platform = :ios, "7.0"
  s.requires_arc = true
  
  s.subspec 'Shared' do |ss|
    ss.source_files =         'Robokit/Source/Shared/*.{h,m}','Robokit/Frameworks/*.h'
    ss.resources =            [ 'Robokit/Localizations/**',
                                'Robokit/Resources/RKRatingViewController.xcassets/**/*',
                                'Robokit/Resources/RKRatingViewController.storyboard',
                                'Robokit/Resources/RKFollowUsViewController.xcassets/**/*',
                                'Robokit/Resources/RKFollowUsViewController.storyboard',
                                'Robokit/Resources/RKFeedbackViewController.storyboard' ]
                                
    ss.preserve_paths =       'Robokit/Resources/RKRatingViewController.xcassets/*',
                              'Robokit/Resources/RKFollowUsViewController.xcassets/*'
    ss.frameworks =           'Accounts',
                              'Social',
                              'UIKit'
    ss.vendored_libraries =   'Robokit/Frameworks/libFlurry_4.2.4.a', 'Robokit/Frameworks/libTestFlight.a'
    ss.library = 'z'
    ss.preserve_paths =       'Robokit/Frameworks/libFlurry_4.2.4.a', 'Robokit/Frameworks/libTestFlight.a'
  end
  
  s.subspec 'IAP' do |ss|
    ss.dependency             'Robokit/Shared'
    
    ss.source_files =         'Robokit/Source/IAP/*.{h,m}'
    ss.frameworks =           'StoreKit'
  end

  s.subspec 'Ads' do |ss|
    ss.dependency             'Robokit/IAP'

    ss.source_files =         'Robokit/Source/Ads/*.{h,m}',
                              'Robokit/Frameworks/RevMobAds.framework/**/*.h'
    ss.frameworks =           'iAd',
							  'SystemConfiguration',
                              'AdSupport'

    ss.vendored_frameworks =  'Robokit/Frameworks/RevMobAds.framework'
    ss.resources =            [ 'Robokit/Resources/RKAdView.xcassets/**/*' ]
    ss.preserve_paths =       'Robokit/Resources/RKAdView.xcassets/*',
                              'Robokit/Frameworks/RevMobAds.framework/*'
  end

  s.subspec 'About' do |ss|
    ss.dependency             'Robokit/Shared'

    ss.source_files =         'Robokit/Source/About/*.{h,m}'
    ss.resources = [
                              'Robokit/Resources/RKAboutRobocatViewController.storyboard',
                              'Robokit/Resources/RKAboutRobocatViewController.xcassets/**/*',
							  'Robokit/Resources/RKAboutRobocatViewController.strings' ]
                              'Robokit/Frameworks/RevMobAds.framework/*'
    ss.preserve_paths =       'Robokit/Resources/RKAboutRobocatViewController.xcassets/*'
  end
  
  s.subspec 'Catnip' do |ss|
    ss.dependency             'Robokit/Shared'
    ss.dependency	          'RSEnvironment'
    ss.source_files =         'Robokit/Source/Catnip/*.{h,m}'
  end

end
