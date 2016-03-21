//
//  InfiniteCarouselFigureView.m
//  CarouselFigureDemo
//
//  Created by dev on 16/1/8.
//  Copyright © 2016年 thomas. All rights reserved.
//


#import "FXCarouselFigureView.h"
#import <SDWebImage/SDWebImageManager.h>

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
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *topConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *heightConstraint =
    [NSLayoutConstraint constraintWithItem:self.imageView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0f
                                  constant:0.0f];
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
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
@property (copy, nonatomic) NSArray *imageUrls;
@property (strong, nonatomic) UIImage *defaultImage;

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
    [self.pageControl setNeedsLayout];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setCanAutoCarousel:(BOOL)canAutoCarousel {
    _canAutoCarousel = canAutoCarousel;
    if (!_canAutoCarousel) {
        [self removeTimer];
    }
}

#pragma mark - Private

- (void)setupViews {
    self.canAutoCarousel = YES;
    [self setupCollectionView];
    [self setupPageControl];
    if (self.canAutoCarousel) {
        [self addTimer];
    }
}

- (NSArray *)images {
    if (!_images) {
        if ([self.imageUrls count]) {
            NSMutableArray *imagesTemp = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < [self.imageUrls count]; i++) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:self.imageUrls[i] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        imagesTemp[i] = image;
                    } else if (!image && error) {
                        image = self.defaultImage;
                    }
                    imagesTemp[i] = image;
                    self.images = [imagesTemp copy];
                }];
            }
        } else {
            if ([self.dataSource respondsToSelector:@selector(carouseFigureImageForFXCarouseFigureView:)]) {
                _images =  [self.dataSource carouseFigureImageForFXCarouseFigureView:self];
            }
        }
    }
    return _images;
}


- (NSArray *)imageUrls {
    if (!_imageUrls) {
        if ([self.dataSource respondsToSelector:@selector(carouseFigureImageUrlsForFXCarouseFigureView:)]) {
            _imageUrls = [self.dataSource carouseFigureImageUrlsForFXCarouseFigureView:self];
        }
    }
    return _imageUrls;
}

- (UIImage *)defaultImage {
    if (!_defaultImage) {
        if ([self.dataSource respondsToSelector:@selector(carouseFigureDefaultImageForFXCarouseFigureView:)]) {
            _defaultImage = [self.dataSource carouseFigureDefaultImageForFXCarouseFigureView:self];
        } else {
            _defaultImage = [self imageWithColor:[UIColor greenColor]
                                            size:CGSizeMake(1.0f, 1.0f)];
        }
    }
    return _defaultImage;
}

- (void)setupCollectionView {
    CGRect frame = self.bounds;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame),
                                     CGRectGetHeight(frame));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:flowLayout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.hidden = YES;
    [self addSubview:self.collectionView];
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *topConstraint =
    [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:0.0f];
    NSLayoutConstraint *heightConstraint =
    [NSLayoutConstraint constraintWithItem:self.collectionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0f
                                  constant:0.0f];
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
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

#pragma mark - default image

- (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){.size = size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Public

- (void)show {
    self.pageControl.numberOfPages = [self.images count];
    [self.collectionView reloadData];
    self.collectionView.hidden = NO;
    self.pageControl.hidden = self.hiddenPageControl;
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

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(imageWasSelectForFXCarouseFigureView:index:)]) {
        [self.delegate imageWasSelectForFXCarouseFigureView:self index:(indexPath.item + 1)];
    }
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
    if (self.canAutoCarousel) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.canAutoCarousel) {
        [self addTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (int) (scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % [self.images count];
    self.pageControl.currentPage = page;
}


@end
