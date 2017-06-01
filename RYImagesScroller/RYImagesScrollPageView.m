//
//  RYImagesScrollPageView.m
//  Pods
//
//  Created by RongqingWang on 2017/4/11.
//
//

#import "RYImagesScrollPageView.h"
#import "Masonry.h"
#import "RYImageScrollViewPageCell.h"

static NSString *cellId = @"asdasdads";

@interface RYImagesScrollPageView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 非当前展示页的分页图片  仅在 RYImageScrollerPageStyleCustom 下生效
 */
@property (nonatomic, strong) UIImage *normalPageImage;
/**
 当前页的分页图片   仅在 RYImageScrollerPageStyleCustom 下生效
 */
@property (nonatomic, strong) UIImage *currentPageImage;
/**
 分页间隔
 */
@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, strong) UICollectionView *cvPage;

@property (nonatomic, assign) CGSize itemSize;

@end

@implementation RYImagesScrollPageView

- (instancetype)initWithNormalImage:(UIImage *)normalImage currentImage:(UIImage *)currentImage itemSpace:(CGFloat)itemSpace frame:(CGRect)frame {
    //TODO: 计算下需要多宽
    self = [super initWithFrame:frame];
    self.normalPageImage = normalImage;
    self.currentPageImage = currentImage;
    self.itemSpace = itemSpace;
    self.itemSize = normalImage.size;
    [self setupUI];
    return self;
}

- (void)setupUI {
    [self addSubview:self.cvPage];
    [self.cvPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.itemSize.height+4);
    }];
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.itemSize.width * self.totalCount + self.itemSpace * (self.totalCount-1));
    }];
    [self.cvPage reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.cvPage reloadData];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYImageScrollViewPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (indexPath.item == self.currentIndex) {
        cell.image = self.currentPageImage;
    } else {
        cell.image = self.normalPageImage;
    }
    return cell;
}

#pragma mark - lazy
- (CGFloat)itemSpace {
    if (!_itemSpace) {
        _itemSpace = 4;
    }
    return _itemSpace;
}

- (UICollectionView *)cvPage {
    if (!_cvPage) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.itemSize;
        layout.minimumLineSpacing = self.itemSpace;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _cvPage = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cvPage.delegate = self;
        _cvPage.dataSource = self;
        _cvPage.showsHorizontalScrollIndicator = NO;
        _cvPage.showsVerticalScrollIndicator = NO;
        _cvPage.backgroundColor = [UIColor clearColor];
        _cvPage.scrollEnabled = NO;
        [_cvPage registerClass:[RYImageScrollViewPageCell class] forCellWithReuseIdentifier:cellId];
    }
    return _cvPage;
}

@end
