Pod::Spec.new do |s|
  s.name         = "FXCarouselFigureView"
  s.version      = "1.0.2"
  s.summary      = "this is carouseFigureView."
  s.homepage     = "https://github.com/zfx5130/FXCarouselFigureView"
  s.license      = "MIT"
  s.authors      = { 'thomas' => 'dui1cuo@126.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/zfx5130/FXCarouselFigureView", :tag => s.version }
  s.source_files = 'FXCarouselFigureView', 'FXCarouselFigureView/**/*.{h,m}'
  s.requires_arc = true
end
