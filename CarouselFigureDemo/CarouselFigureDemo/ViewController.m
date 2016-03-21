//
//  ViewController.m
//  CarouselFigureDemo
//
//  Created by dev on 16/1/8.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "ViewController.h"

#import "FXCarouselFigureView.h"

@interface ViewController ()
<FXCarouselFigureViewDataSource,
FXCarouselFigureViewDelegate>

@property (weak, nonatomic) IBOutlet FXCarouselFigureView *carouseFigureView;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupCarouselFigureDataSourceWithFigureView:self.carouseFigureView];
//    self.carouseFigureView.canAutoCarousel = NO;
    [self.carouseFigureView show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setupViews {
    
    FXCarouselFigureView *figureView =
    [[FXCarouselFigureView alloc] initWithFrame:CGRectMake(20.0f, 40.0f, CGRectGetWidth(self.view.frame) - 20.0f * 2, 200.0f)];
    [self.view addSubview:figureView];
    figureView.currentPageIndicatorTintColor = [UIColor grayColor];
    figureView.pageIndicatorTintColor = [UIColor blackColor];
    figureView.contentMode = UIViewContentModeScaleToFill;
    figureView.hiddenPageControl = YES;
//    figureView.canAutoCarousel = NO;
    [self setupCarouselFigureDataSourceWithFigureView:figureView];
    [figureView show];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(CGRectGetMinX(figureView.frame), CGRectGetMaxY(figureView.frame) + 5.0f, 280.0f, 20.0f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"手动视图创建", @"手动创建视图");
    [self.view addSubview:label];
    
}

- (void)setupCarouselFigureDataSourceWithFigureView:(FXCarouselFigureView *)figure {
    figure.dataSource = self;
    figure.delegate = self;
}

#pragma mark - FXCarouselFigureViewdataSource

- (NSArray<UIImage *> *)carouseFigureImageForFXCarouseFigureView:(FXCarouselFigureView *)view {
    NSArray *images = @[
                        [UIImage imageNamed:@"topic_schedule_level_1"],
                        [UIImage imageNamed:@"topic_schedule_level_2"],
                        [UIImage imageNamed:@"topic_schedule_level_3"],
                        [UIImage imageNamed:@"topic_schedule_level_4"],
                        [UIImage imageNamed:@"topic_schedule_level_5"],
                        ];
    return images;
}

#pragma mark - FXCarouselFigureViewDelegage

- (void)imageWasSelectForFXCarouseFigureView:(FXCarouselFigureView *)view
                                       index:(NSInteger)index {
    NSLog(@"select image index ::%@", @(index));
}


@end
