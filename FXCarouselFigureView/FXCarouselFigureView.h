//
//  InfiniteCarouselFigureView.h
//  CarouselFigureDemo
//
//  Created by dev on 16/1/8.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXCarouselFigureView;
@protocol FXCarouselFigureViewDataSource <NSObject>

/**
 *  rolling images
 *
 *  @param view self
 *
 *  @return images
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

@end

@protocol FXCarouselFigureViewDelegate <NSObject>

/**
 *  select the image will be execute this way,.
 *
 *  @param view  self
 *  @param index image index
 */
- (void)imageWasSelectForFXCarouseFigureView:(FXCarouselFigureView *)view
                                       index:(NSInteger)index;

@end

@interface FXCarouselFigureView : UIView

/**
 *  can auto carousel, default is YES
 */
@property (assign, nonatomic) BOOL canAutoCarousel;


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

/**
 *  the carouselFigureViewDelegate
 */
@property (weak, nonatomic) id <FXCarouselFigureViewDelegate> delegate;

/**
 *  the view show.
 */
- (void)show;

@end
