//
//  RYImagesScrollView.h
//  RYImagesScroller
//
//  Created by RongqingWang on 16/8/6.
//  Copyright © 2016年 RongqingWang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageScrollHandler)(id obj);

typedef NS_ENUM(NSInteger, RYImageScrollerPageStyle) {
    /**
     系统分页样式
     */
    RYImageScrollerPageStyleNormal = 99,
    /**
     用户自定义分页样式
     */
    RYImageScrollerPageStyleCustom = 100
};

@interface RYImagesScrollView : UIView

/**
 初始化方法   并设置分页样式
 
 @param style 分页样式
 */
- (instancetype)initWithFrame:(CGRect)frame pageStyle:(RYImageScrollerPageStyle)style;

/**
 停止滚动
 */
- (void)stopScroll;

/**
 重新开始滚动
 */
- (void)restartScroll;

/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray <NSString *> *imageURLs;
/**
 *  需要添加辅助view的序号数组 与 attachViewArr 一一对应
 */
@property (nonatomic, strong) NSArray <NSNumber *> *attachIndexArr;
/**
 *  辅助View数组
 */
@property (nonatomic, strong) NSArray <UIView *> *attachViewArr;
@property (nonatomic, strong) UICollectionView *cv_collectionView;
/**
 *  滚动时间间隔 0s不滚动
 */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/**
 *  默认 UIViewContentModeScaleAspectFill
 */
@property (nonatomic, assign) UIViewContentMode contentMode;
/**
 非当前展示页的分页图片  仅在 RYImageScrollerPageStyleCustom 下生效
 */
@property (nonatomic, strong) UIImage *normalPageImage;
/**
 当前页的分页图片   仅在 RYImageScrollerPageStyleCustom 下生效
 */
@property (nonatomic, strong) UIImage *currentPageImage;
/**
 加载图片的占位图
 */
@property (nonatomic, strong) UIImage *placeHolderImage;
/**
 *  点击图片的回调
 */
@property (nonatomic, copy) ImageScrollHandler handler_imageClick;
/**
 *  每次滚动完的回调
 */
@property (nonatomic, copy) ImageScrollHandler handler_scrollCallBack;
/**
 指定当前位置
 */
@property (nonatomic, assign) NSInteger scrollToPage;

@end
