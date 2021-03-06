#
#  Be sure to run `pod spec lint AZPagedCardCollection.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AZPagedCollectionViewContainer"
  s.version      = "0.0.1"
  s.summary      = "custom paging view with collectionview flow layout."
  s.description  = <<-DESC
  suport vertival and horizontal paging with simple setting...
                   DESC
  s.homepage     = "https://github.com/cnwhao/AZPagedCollectionViewContainer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "cnwhao" => "cnwhao@163.com" }
  s.platform     = :ios, '8.0'
  s.swift_version= "5.0"
  s.source       = { :git => "https://github.com/cnwhao/AZPagedCollectionViewContainer.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.swift"
  # s.resource  = "Sources/hcdCachePlayer.bundle"
  s.frameworks = "UIKit" , "Foundation"
  s.requires_arc = true
  # s.dependency "Snapkit"
end
