//
//  YCHomePageHeaderView.m
//
//  Created by Sunshine on 15/10/30.
//  Copyright (c) 2015年 YotrolZ. All rights reserved.
//

#import "YCHomePageHeaderView.h"
#import "YCSquareButton.h"
#import "YCHomePageHeaderTagView.h"
#import "ZDSTagsView.h"
#import "YCCircleModel.h"
#import "GroupTypeViewController.h"
#import "UIView+ViewController.h"


@interface YCHomePageHeaderView()

/** <#属性名称#> */
@property (nonatomic, strong)YCHomePageHeaderTagView *tagView1;

/** <#属性名称#> */
@property (nonatomic, strong)YCHomePageHeaderTagView *tagView2;

/** <#属性名称#> */
@property (nonatomic, strong)ZDSTagsView *tagsView;

/** <#属性名称#> */
@property (nonatomic, assign)CGFloat btnHeight;

@end

@implementation YCHomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


/**
 *  存放所有圈子数据
 */
//- (NSArray *)circleArr {
//
//    if (_circleArr == nil) {
//        _circleArr = [NSArray array];
//    }
//    return _circleArr;
//}

- (void)setup {
    
    self.backgroundColor = [UIColor whiteColor];

    YCHomePageHeaderTagView *tagView1 = [[YCHomePageHeaderTagView alloc] init];
    tagView1.imageV.image = [UIImage imageNamed:@"qz-28"];
    tagView1.label.text = @"圈子";
    tagView1.backgroundColor = [WWTolls colorWithHexString:@"efefef"];
    
    self.tagView1 = tagView1;
    
    [self addSubview:tagView1];
    
    
//    NSArray *titles = @[@"瘦成女神", @"减出健康", @"达人驾到", @"身材锻造", @"我是80后", @"学生党", @"运动不止", @"低卡饮食"];

    // 一行最多4列
    int maxCols = 4;

    // 边间距
    CGFloat marginLR = 23;
    CGFloat marginTB = 15;
    
    // 中间间隙
    CGFloat marginX = 25;
    
    // 中间间隙
    CGFloat marginY = 10;
    
    // 宽度和高度
    CGFloat buttonW = ( SCREEN_WIDTH - marginLR * 2 - marginX * (maxCols - 1) )/ maxCols;
//    float buttonH = buttonW + 10;
    CGSize size =[@"哈哈哈哈哈哈" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    CGFloat buttonH = buttonW + 10 + size.height;
    
    self.btnHeight = buttonH;
    
    for (int i = 0; i < self.circleArr.count; i++) {
//        
//        
//        NSLog(@"%@", self.circleArr);
//
//        NSString *title = titles[i];
//        
//        NSString *imageName = [NSString stringWithFormat:@"index_first_%d", i];
//        NSString *selImageName = [NSString stringWithFormat:@"index_s_first_%d", i];
//        
//        
        YCCircleModel *moadel = self.circleArr[i];
        
        
        YCSquareButton *button = [YCSquareButton squareButtonWithCircleModel:moadel];
        [button addTarget:self action:@selector(goToType:) forControlEvents:UIControlEventTouchUpInside];
        
//        YCSquareButton *button = [YCSquareButton squareButtonWithTitle:title imageName:imageName selImageName:selImageName];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        button.x = marginLR + col * (buttonW + marginX);
//        button.y = row * buttonH + marginY + tagView1.height;
        button.y = marginTB + row * (buttonH + marginY) + tagView1.height;;
        button.width = buttonW;
        button.height = buttonH;
        
        [self addSubview:button];
    }
    
    YCHomePageHeaderTagView *tagView2 = [[YCHomePageHeaderTagView alloc] init];
    
    tagView2.imageV.image = [UIImage imageNamed:@"tj-28"];
    tagView2.label.text = @"推荐";
    
    tagView2.backgroundColor = [WWTolls colorWithHexString:@"efefef"];
    
    self.tagView2 = tagView2;
    
    [self addSubview:tagView2];
    
    
    /// 标签
//    ZDSTagsView *tagsView = [[ZDSTagsView alloc] init];
//    self.tagsView.frame = CGRectMake(0, 0, 150, 200);
//    tagsView.backgroundColor = [UIColor orangeColor];
//    [tagsView createTagLabels:@[@"阿斯s飞", @"到底", @"是", @"阿斯顿", @"手势", @"阿斯顿飞"]];
//    self.tagsView = tagsView;
    
//    [self addSubview:tagsView];
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.tagView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    
    self.tagView2.frame = CGRectMake(0, self.tagView1.height + 2 * self.btnHeight + 10 + 30, SCREEN_WIDTH, 24);
    
    self.tagsView.frame = CGRectMake(0, 0, 150, 200);
    
}

- (void)setCircleArr:(NSArray *)circleArr {

//    _circleArr = [NSArray arrayWithArray:circleArr];
    
    _circleArr = circleArr;

    [self setup];
}


- (void)goToType:(YCSquareButton*)btn{
    GroupTypeViewController *gt = [GroupTypeViewController new];
    gt.hidesBottomBarWhenPushed = YES;
    gt.gamecircle = btn.circleM.circlename;
    [self.viewController.navigationController pushViewController:gt animated:YES];
}
@end
