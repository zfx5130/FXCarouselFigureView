# FXCarouselFigureView
无限轮播图.使用方法简单,创建视图,设置images数组,或者imageUrls, 调用show方法即可使用,有对应的参数,根据自己需求自己设置即可.可下载参考Demo.

###效果如下

![](https://github.com/zfx5130/FXCarouselFigureView/blob/master/image/demo.gif)

##安装
###1.CocoaPods

```
  1.在 Podfile 中添加 pod "FXCarouselFigureView"。
  2.执行 pod install 或 pod update。
  3.导入 <FXCarouselFigureView.h>。

```
###2.手动安装

```
  1.下载FXCarouselFigureView文件夹内的所有内容。
  2.将FXCarouselFigureView内的源文件添加(拖放)到你的工程。
  3.导入FXCarouselFigureView.h。

```


## 使用方式

```
	#import "FXCarouselFigureView.h"

    FXCarouselFigureView *figureView =
    [[FXCarouselFigureView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 280.0f) * 0.5f, 40.0f, 280.0f, 200.0f)];
    [self.view addSubview:figureView];
    figureView.currentPageIndicatorTintColor = [UIColor grayColor];
    figureView.pageIndicatorTintColor = [UIColor blackColor];
    figureView.contentMode = UIViewContentModeScaleToFill;
	figureView.dataSource = self;
    [figureView show];

```

####DataSource

```
/**
 *  the images
 *
 *  @param view self
 *
 *  @return images arrays
 */
- (NSArray<UIImage *> *)carouseFigureImageForFXCarouseFigureView:(FXCarouselFigureView *)view;

/**
 *  rolling image urls
 *
 *  @param view self
 *
 *  @return imageurls
 */
- (NSArray<NSString *> *)carouseFigureImageUrlsForFXCarouseFigureView:(FXCarouselFigureView *)view;

/**
 *  default rolling image, if you not set image, or you set the imageurl is not load image , the default image can replace it.,if you not set image , the default image is green color image.
 *
 *  @param view self
 *
 *  @return default image
 */
- (UIImage *)carouseFigureDefaultImageForFXCarouseFigureView:(FXCarouselFigureView *)view;

```

####Delegate

```
/**
 *  select the image will be execute this way,.
 *
 *  @param view  self
 *  @param index image index
 */
- (void)imageWasSelectForFXCarouseFigureView:(FXCarouselFigureView *)view
                                       index:(NSInteger)index;


```

####Property

```
/**
 *  set the image show ways, default is UIViewContentModeScaleToFill.
 */
@property(assign, nonatomic) UIViewContentMode contentMode;

/**
 * if you not show the pageControl, you can set is Yes. default is No.
 */
@property (assign, nonatomic) BOOL hiddenPageControl;

/**
 *  if the pageControl is show , you can set the pageControl Frame,
    default is the view bottom ,height is 40.0f.
 */
@property (assign, nonatomic) CGRect pageControlFrame;

/**
 *  the pageControl pageIndicatorTintColor, default is blue.
 */
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;

/**
 *  the pageControl currentPageIndicatorTintColor, default is red.
 */
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;

/**
 *  if you use this. you must be set the dataSource.
 */
@property (weak, nonatomic) id <FXCarouselFigureViewDataSource> dataSource;

```
