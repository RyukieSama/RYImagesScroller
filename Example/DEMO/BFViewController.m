//
//  BFViewController.m
//  DEMO
//
//  Created by Ryukie on 04/10/2017.
//  Copyright (c) 2017 Ryukie. All rights reserved.
//

#import "BFViewController.h"
#import "RYImagesScrollView.h"

@interface BFViewController ()

@property (nonatomic, strong) RYImagesScrollView *svImages;

@end

@implementation BFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    
    self.svImages.imageURLs = @[
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531818350790.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531897388821.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531754597727.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531459990792.png",
                            @"http://cc.cocimg.com/api/uploads/20170407/1491531504501824.jpg"
                            ];
    
    self.svImages.attachIndexArr = @[
                                     @0,
                                     @2
                                     ];
    
    self.svImages.attachViewArr = @[
                                    [[UISwitch alloc] init],
                                    [[UISlider alloc] init]
                                    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    [self.view addSubview:self.svImages];
}

- (RYImagesScrollView *)svImages {
    if (!_svImages) {
        _svImages = [[RYImagesScrollView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*3/7) pageStyle:RYImageScrollerPageStyleCustom];
        _svImages.autoScrollTimeInterval = 4.0f;
        _svImages.contentMode = UIViewContentModeScaleAspectFill;
        _svImages.normalPageImage = [UIImage imageNamed:@"outdoor_icon_carousel"];
        _svImages.currentPageImage = [UIImage imageNamed:@"outdoor_icon_carousel_selected"];
    }
    return _svImages;
}

@end
