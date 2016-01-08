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

- (NSArray<UIImage *> *)carouseFigureImageForFXCarouseFigureView:(FXCarouselFigureView *)view;

@end

@interface FXCarouselFigureView : UIView

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
 *  the view show.
 */
- (void)show;

@end