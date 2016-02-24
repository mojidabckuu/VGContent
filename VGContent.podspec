#
# Be sure to run `pod lib lint VGContent.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VGContent"
  s.version          = "0.1.0"
  s.summary          = "Small DRY workaround on UITableView, UICollectionView, iCarousel delegates."
  s.homepage         = "https://github.com/mojidabckuu/VGContent"
  s.license          = 'MIT'
  s.author           = { "mojidabckuu" => "mojidabckuu.22.06.92@gmail.com" }
  s.source           = { :git => "https://github.com/mojidabckuu/VGContent.git", :tag => "#{s.version}"}

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'VGContent' => ['Pod/Assets/*.png']
  }

  s.dependency 'VGInfiniteControl'
  s.dependency 'iCarousel'
end
