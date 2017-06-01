# RYImagesScroller
## install
`pod 'RYImagesScroller'`

## 图片轮播
> 支持自定义分页图片
> 支持自定义蒙版视图

## 效果展示
![IMG_1675](http://ohfpqyfi7.bkt.clouddn.com/IMG_1675.PNG)
![IMG_1676](http://ohfpqyfi7.bkt.clouddn.com/IMG_1676.PNG)

上图效果示例代码:
上图在第一个和第三个添加了一个开关和滑动条

``` swift

_svImages = [[RYImagesScrollView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*3/7) pageStyle:RYImageScrollerPageStyleCustom];
        _svImages.autoScrollTimeInterval = 4.0f;
        _svImages.contentMode = UIViewContentModeScaleAspectFill;
        _svImages.normalPageImage = [UIImage imageNamed:@"outdoor_icon_carousel"];
        _svImages.currentPageImage = [UIImage imageNamed:@"outdoor_icon_carousel_selected"];

self.svImages.imageURLs = @[
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531818350790.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531897388821.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531754597727.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531459990792.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531504501824.jpg"
                            ];
    
    //这里的意思是在第一页和第三页 添加自定义蒙版视图
    self.svImages.attachIndexArr = @[
                                     @0,
                                     @2
                                     ];
    //这里的意思是在第一页和第三页的 添加自定义蒙版视图数组   蒙版会自适应轮播控件的大小  如果需要自定义位置  最好用一个背景透明的容器装下
    self.svImages.attachViewArr = @[
                                    [[UISwitch alloc] init],
                                    [[UISlider alloc] init]
                                    ];
```

### 方法：

初始化:

``` swift
/**
 初始化方法   并设置分页样式

 @param style 分页样式
 */
- (instancetype)initWithFrame:(CGRect)frame pageStyle:(RYImageScrollerPageStyle)style;

```

分页样式

``` swift
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
```

其他参数

``` swift
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
/**
 *  滚动时间间隔   默认2s
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
 *  点击图片的回调
 */
@property (nonatomic, copy) ImageScrollHandler handler_imageClick;
/**
 *  每次滚动完的回调
 */
@property (nonatomic, copy) ImageScrollHandler handler_scrollCallBack;
```




