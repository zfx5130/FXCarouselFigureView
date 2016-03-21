Pod::Spec.new do |s|
  s.name         = "FXCarouselFigureView"
  s.version      = "1.1.2"
  s.summary      = "collectionView 完成的无限轮播图功能,支持传入images,或者imagesUrl,使用方便"
  s.homepage     = "https://github.com/zfx5130/FXCarouselFigureView"
  s.license      = "MIT"
  s.authors      = { 'thomas' => 'dui1cuo@126.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/zfx5130/FXCarouselFigureView.git", :tag => s.version }
  s.source_files = 'FXCarouselFigureView', 'FXCarouselFigureView/**/*.{h,m}'
  s.requires_arc = true
  s.dependency 'SDWebImage', '~> 3.7.4'

end
