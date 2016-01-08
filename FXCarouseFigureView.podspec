Pod::Spec.new do |s|
  s.name         = "FXCarouseFigureView"
  s.version      = "1.0.1"
  s.summary      = "if you want to arc4random set circle int you view, you can use it"
  s.homepage     = "https://github.com/zfx5130/FXCarouselFigureView"
  s.license      = "MIT"
  s.authors      = { 'thomas' => 'dui1cuo@126.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zfx5130/FXCarouselFigureView", :tag => s.version }
  s.source_files = 'FXCarouselFigureView', 'FXCarouselFigureView/**/*.{h,m}'
  s.requires_arc = true
end
