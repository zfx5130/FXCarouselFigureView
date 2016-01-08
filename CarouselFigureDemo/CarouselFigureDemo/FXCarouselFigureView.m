//
//  InfiniteCarouselFigureView.m
//  CarouselFigureDemo
//
//  Created by dev on 16/1/8.
//  Copyright © 2016年 thomas. All rights reserved.
//


#import "FXCarouselFigureView.h"

static NSString *const kResueIdentifierCarouseFigureViewCell =
@"kResueIdentifierCarouseFigureViewCell";
static const NSUInteger kCarouseFigureSectionCount = 50;
static const CGFloat kDefaultPageControlHeight = 40.0f;

@interface CarouseFigureViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CarouseFigureViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:self.imageView];
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}

@end


@interface FXCarouselFigureView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
@property (copy, nonatomic) NSArray *images;

@end

@implementation FXCarouselFigureView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setters

- (void)setContentMode:(UIViewContentMode)contentMode {
    _contentMode = contentMode;
    [self.collectionView reloadData];
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl {
    _hiddenPageControl = hiddenPageControl;
    self.pageControl.hidden = hiddenPageControl;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    self.pageControl.frame = pageControlFrame;
    [self.pageControl layoutIfNeeded];
    [self.pageControl layoutSubviews];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - Private

- (void)setupViews {
    [self setupCollectionView];
    [self setupPageControl];
    [self addTimer];
}

- (NSArray *)images {
    if (!_images) {
        if ([self.dataSource respondsToSelector:@selector(carouseFigureImageForFXCarouseFigureView:)]) {
            _images =  [self.dataSource carouseFigureImageForFXCarouseFigureView:self];
        }
    }
    return _images;
}

- (void)setupCollectionView {
    CGRect frame = self.bounds;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame),
                                     CGRectGetHeight(frame));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.hidden = YES;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[CarouseFigureViewCell class]
            forCellWithReuseIdentifier:kResueIdentifierCarouseFigureViewCell];
}

- (void)setupPageControl {
    CGRect frame = self.frame;
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0.0f,
                                        frame.size.height - kDefaultPageControlHeight,
                                        frame.size.width,
                                        kDefaultPageControlHeight);
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages = [self.images count];
    self.pageControl.enabled = NO;
    self.pageControl.hidden = YES;
    [self addSubview:self.pageControl];
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(nextPage)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer
                              forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Public

- (void)show {
    self.pageControl.numberOfPages = [self.images count];
    [self.collectionView reloadData];
    self.pageControl.hidden = NO;
    self.collectionView.hidden = NO;
}

#pragma mark - Handlers 

- (void)nextPage {
    
    if (![self.images count]) {
        return;
    }
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset =
    [NSIndexPath indexPathForItem:currentIndexPath.item
                        inSection:kCarouseFigureSectionCount * 0.5f];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == [self.images count]) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem
                                                     inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:YES];
}

#pragma mark- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return kCarouseFigureSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouseFigureViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:kResueIdentifierCarouseFigureViewCell
                                              forIndexPath:indexPath];
    cell.imageView.contentMode = self.contentMode;
    cell.imageView.image = self.images[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % [self.images count];
    self.pageControl.currentPage = page;
}


@end
