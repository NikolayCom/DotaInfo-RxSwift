# External

def external_pods
  
# Rx
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RxSwiftExt'
  pod 'RxCocoa'

# Constraints
  pod 'SnapKit'

# Load image
  pod 'SDWebImage'

# Initialization
  pod 'Then'

# Network 
  pod 'Alamofire'

# Loader 
  pod 'PKHUD'
end

# Development

def developmet_pods
  pod "Core", :path => "./Modules/Core"
  pod "UseCases", :path => "./Modules/UseCases"
  pod "Models", :path => "./Modules/Models"
  pod "HeroInfo", :path => "./Modules/HeroInfo"
  pod "Extensions", :path => "./Modules/Extensions"
end

# Targerts
use_frameworks!
inhibit_all_warnings!
platform :ios, '15.0'

target 'DotaInfo' do
  external_pods
  developmet_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
