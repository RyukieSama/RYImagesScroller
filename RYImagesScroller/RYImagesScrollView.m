//
//  RYImagesScrollView.m
//  RYImagesScroller
//
//  Created by RongqingWang on 16/8/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import "RYImagesScrollView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "RYImagesScrollPageView.h"

static NSString *ID = @"imageCell";
static NSString *videoID = @"imageCellWithVideo";

@interface RYImagesScrollViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImageView *iv_image;
@property (nonatomic, strong) UIView *v_attach;
@property (nonatomic, strong) UIImage *placeHolderImage;

@end

@implementation RYImagesScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iv_image];
    [self.iv_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.iv_image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.placeHolderImage];
}

- (UIImageView *)iv_image {
    if (!_iv_image) {
        _iv_image = [[UIImageView alloc] init];
        _iv_image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iv_image;
}

- (void)setV_attach:(UIView *)v_attach {
    _v_attach = v_attach;
    [self.contentView addSubview:self.v_attach];
    [self.v_attach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

@interface RYImagesScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) RYImagesScrollPageView *pageControl;
@property (nonatomic, strong) UIPageControl *sysPageControl;
@property (nonatomic, assign) RYImageScrollerPageStyle pageStyle;

@end

@implementation RYImagesScrollView

- (instancetype)initWithFrame:(CGRect)frame pageStyle:(RYImageScrollerPageStyle)style {
    self = [super initWithFrame:frame];
    self.pageStyle = style;
    [self setUpUI];
    return self;
}

- (void)setUpUI {
    [self addSubview:self.cv_collectionView];
    [self.cv_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    if (self.pageStyle == RYImageScrollerPageStyleCustom) {
//        [self addSubview:self.pageControl];
//        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(0);
//            make.bottom.mas_equalTo(-12);
//        }];
    } else {
        [self addSubview:self.sysPageControl];
        [self.sysPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layout.itemSize = self.frame.size;
}

#pragma mark - set
- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs = imageURLs;
    if (_imageURLs.count < 2) {
        [self invalidateTimer];
        self.cv_collectionView.scrollEnabled = NO;
    } else {
        [self invalidateTimer];
        [self setupTimer];
        self.cv_collectionView.scrollEnabled = YES;
    }
    [self.cv_collectionView reloadData];
    
    if (self.pageStyle == RYImageScrollerPageStyleCustom) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-12);
        }];
        self.pageControl.totalCount = imageURLs.count;
        self.pageControl.currentIndex = self.currentIndex;
    } else {
        self.sysPageControl.numberOfPages = imageURLs.count;
        self.sysPageControl.currentPage = self.currentIndex;
    }
}

- (void)setAttachViewArr:(NSArray<UIView *> *)attachViewArr {
    _attachViewArr = attachViewArr;
    [self.cv_collectionView reloadData];
}

- (void)setAttachIndexArr:(NSArray<NSNumber *> *)attachIndexArr {
    _attachIndexArr = attachIndexArr;
    [self.cv_collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (self.pageStyle == RYImageScrollerPageStyleCustom) {
        self.pageControl.currentIndex = currentIndex;
    } else {
        self.sysPageControl.currentPage = currentIndex;
    }
}

#pragma mark - Timer
- (void)setupTimer {
    if (self.imageURLs.count <= 1) {
        return;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval
                                                      target:self
                                                    selector:@selector(automaticScroll)
                                                    userInfo:nil
                                                     repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.cv_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]
                                       atScrollPosition:UICollectionViewScrollPositionNone
                                               animated:NO];
    });
    NSInteger targetIndex = self.currentIndex + 1;
    if (targetIndex >= self.imageURLs.count) {
        [self.cv_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]
                                       atScrollPosition:UICollectionViewScrollPositionNone
                                               animated:YES];
        return;
    } else {
        [self.cv_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex-1 inSection:1]
                                       atScrollPosition:UICollectionViewScrollPositionNone
                                               animated:NO];
    }
    [self.cv_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:1]
                                   atScrollPosition:UICollectionViewScrollPositionNone
                                           animated:YES];
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)stopScroll {
    [self invalidateTimer];
}

- (void)restartScroll {
    if (self.timer) {
        return;
    }
    [self setupTimer];
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    NSLog(@"- [%@ dealloc]",[self class]);
    [self invalidateTimer];
    self.cv_collectionView.delegate = nil;
    self.cv_collectionView.dataSource = nil;
}

#pragma mark - lazyInit
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)cv_collectionView {
    if (!_cv_collectionView) {
        _cv_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _cv_collectionView.backgroundColor = [UIColor whiteColor];
        _cv_collectionView.pagingEnabled = YES;
        _cv_collectionView.showsHorizontalScrollIndicator = NO;
        _cv_collectionView.showsVerticalScrollIndicator = NO;
        _cv_collectionView.dataSource = self;
        _cv_collectionView.delegate = self;
        _cv_collectionView.scrollsToTop = NO;
        [_cv_collectionView registerClass:[RYImagesScrollViewCell class]
               forCellWithReuseIdentifier:ID];
        [_cv_collectionView registerClass:[RYImagesScrollViewCell class]
               forCellWithReuseIdentifier:videoID];
    }
    return _cv_collectionView;
}

- (RYImagesScrollPageView *)pageControl {
    if (!_pageControl) {
        _pageControl = [[RYImagesScrollPageView alloc] initWithNormalImage:self.normalPageImage currentImage:self.currentPageImage itemSpace:0 frame:CGRectZero];
    }
    return _pageControl;
}

- (UIPageControl *)sysPageControl {
    if (!_sysPageControl) {
        _sysPageControl = [[UIPageControl alloc] init];
    }
    return _sysPageControl;
}

#pragma mark - collectionDataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //含有内部自定义控件的cell
    NSInteger index = -1;
    for (NSNumber *num in self.attachIndexArr) {
        index++;
        if (num.integerValue == indexPath.row) {
            RYImagesScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoID forIndexPath:indexPath];
            cell.imageUrl = self.imageURLs[indexPath.row];
            cell.v_attach = self.attachViewArr[index];
            return cell;
        }
    }
    //正常cell
    RYImagesScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.imageUrl = self.imageURLs[indexPath.row];
    cell.iv_image.contentMode = self.contentMode ? self.contentMode : UIViewContentModeScaleAspectFill;
    cell.placeHolderImage = self.placeHolderImage;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.handler_imageClick) {
        self.handler_imageClick(@(indexPath.row));
    }
}

#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imageURLs.count) return;// 解决清除timer时偶尔会出现的问题
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollIndexFix];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self invalidateTimer];
    [self setupTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollIndexFix];
}

#pragma mark - 处理轮播index
- (void)scrollIndexFix {
    NSInteger index = self.cv_collectionView.contentOffset.x / self.cv_collectionView.frame.size.width;
    NSInteger indexMid = index % self.imageURLs.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:indexMid inSection:1];
    self.currentIndex = indexMid;
    [self.cv_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
    
    if (self.handler_scrollCallBack) {
        self.handler_scrollCallBack(@(indexMid));
    }
}

@end
