Pod::Spec.new do |s|
  s.name             = 'RaHPlateKeyboard'
  s.version          = '1.0.1'
  s.summary          = '5'

  s.homepage         = 'http://git.minstone.com.cn'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CageLin' => 'linkq@minstone.com.cn' }
  s.source           = { :git => 'http://git.minstone.com.cn/mobile/modu/ios-components.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Classes/**/*'
  s.resource = 'Assets/**/*'
  s.frameworks = 'UIKit'
  s.dependency "Masonry"
  s.dependency "SVProgressHUD"
  s.static_framework = true
end
