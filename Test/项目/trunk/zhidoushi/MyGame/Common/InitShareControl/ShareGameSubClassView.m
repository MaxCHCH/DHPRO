//
//  ShareGameSubClassView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ShareGameSubClassView.h"
//..微信API..//
#import "WXApi.h"
#import "UMSocial.h"
#import "NARShareView.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

//团组分享
static NSString *ShareMessage = @"教你减肥新花样，这次一定瘦下来！来脂斗士一起快乐变型吧！";
//邀请
static NSString *InvitateMessage = @"全新的自我，百变的你！来脂斗士加入我的减脂团一起瘦！";
//撒欢
static NSString *DiscoverShareMessage = @"我在脂斗士里发了一个好玩儿的东东，求围观！";
//乐活吧
static NSString *GroupActBarMessage = @"我在脂斗士里发了一个好玩儿的东东，求围观！";
//HTML页面
static NSString *webHtmlMessage = @"快来看看到底发生了什么...";

//举报图片
static NSString *const JubaoImage = @"jb-570-80.png";
static NSString *const JubaoHighlightImage = @"jb-570-80-touch.png";
//删除图片
static NSString *const DeleteImage = @"sc-570-80.png";
static NSString *const DeleteHightlightImage = @"sc-570-80-touch.png";
//置顶图片
static NSString *const SetTop = @"zd-570-80.png";
static NSString *const SetHighlightTop = @"zd-570-80-touch.png";
//取消置顶图片
static NSString *const CancelTop = @"qxzd--570-80.png";
static NSString *const CancelHighlightTop = @"qxzd--570-80-touch.png";

//朋友圈图片
static NSString *const PyqImage = @"pyq-100.png";
//qq图片
static NSString *const QQImage = @"qq-100.png";
//qq空间
static NSString *const QZoneImage = @"qqkj-100.png";
//微博
static NSString *const WeiBoImage = @"wb-100.png";
//微信
static NSString *const WeiXinImage = @"wx-100.png";
//粉丝
static NSString *const FenSiImage = @"zds-110-110";

@interface ShareGameSubClassView ()

//撒欢展示图片
@property (nonatomic,strong) UIImage                                    *showimage;

@end

@implementation ShareGameSubClassView

#pragma mark - Init

+ (ShareGameSubClassView *)initViewWithShareGameSubClassViewType:(ShareGameSubClassViewType)type andModel:(NSObject *)model {
    return [[ShareGameSubClassView alloc] initWithShareViewWithType:type andModel:(NSObject *)model];
}

- (ShareGameSubClassView *)initWithShareViewWithType:(ShareGameSubClassViewType)type andModel:(NSObject *)model {
    
    if (self = [super init]) {
        
        self.shareGameSubClassViewType = type;
        
        if (type == ActiveShareType || type == GrouptTalkShareType || type == SquareAndDynamicTalkShareType) {
            self.groupTalkModel = (GroupTalkModel*)model;
        } else if (type == DiscoverShareType) {
            self.discoverModel = (DiscoverModel *)model;
        }
    }
    return self;
}

#pragma mark - Public Methods

- (CGFloat)createView {
    
//    self.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.width, 16)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"分享";
    label.font = MyFont(16.0);
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    label.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, label.maxY + 15, SCREEN_WIDTH - 20, 0.5)];
//    [self addSubview:lineView];
    lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    CGFloat maxY = label.maxY + 15 + 0.5;
    
    ShareGameSubClassViewType type = self.shareGameSubClassViewType;
    
    if (type == inType || type == GeneralGroupShareType) {
        label.text = @"邀请";
    }
    if(type == NotifyHTMLShareType || type == GeneralGroupOutShareType){
        label.text = @"分享";
    }
    //减脂团邀请
    if (type == inType || type == GeneralGroupShareType) {
        
        NSMutableArray *invilateArray = [NSMutableArray arrayWithObjects:FenSiImage,PyqImage,WeiXinImage,WeiBoImage,QQImage,QZoneImage, nil];
        NSMutableArray *invilateTextArray = [NSMutableArray arrayWithObjects:@"粉丝",@"朋友圈",@"微信",@"微博",@"QQ",@"QQ空间", nil];
        
        if (![QQApiInterface isQQInstalled]) {
            [invilateArray removeObjectAtIndex:4];
            [invilateArray removeObjectAtIndex:4];
        }
        
        for (int i = 0; i < invilateArray.count; i++) {
            
            //            CGFloat left = 20;
            //// 分享按钮适配
            CGFloat left = ( SCREEN_WIDTH - 55 * 4 ) / 5;
            CGFloat tempMaxY = maxY + 15;
            //            CGFloat x = left + (i % 4) * (55 + 20);
            ////
            CGFloat x = left + (i % 4) * (55 + left);
            CGFloat y = tempMaxY + (i / 4) * (55 + 7 + 14 + 15);
            
            UIButton *invitateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 55, 55)];
            [invitateButton setImage:[UIImage imageNamed:invilateArray[i]] forState:UIControlStateNormal];
            invitateButton.tag = i;
            [self addSubview:invitateButton];
            [invitateButton addTarget:self action:@selector(invitateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(invitateButton.x, invitateButton.maxY + 7, invitateButton.width, 14)];
            [self addSubview:typeLabel];
            typeLabel.font = MyFont(14.0);
            typeLabel.textAlignment = NSTextAlignmentCenter;
            typeLabel.text = invilateTextArray[i];
            typeLabel.textColor = [UIColor whiteColor];
            
            //最后一个 给maxY重新复制
            if (i == (invilateArray.count - 1)) {
                maxY = typeLabel.maxY;
            }
            
        }
        
        self.height = maxY + 18;
//        return maxY + 18;
    }
    
    //减脂团分享
    else if (type == outType || type == NotifyHTMLShareType || type == GeneralGroupOutShareType) {
        
        NSMutableArray *shareArray = [NSMutableArray arrayWithObjects:PyqImage,WeiXinImage,QZoneImage,QQImage,WeiBoImage, nil];
        NSMutableArray *shareTextArray = [NSMutableArray arrayWithObjects:@"朋友圈",@"微信",@"QQ空间",@"QQ",@"微博", nil];
        
        if (![QQApiInterface isQQInstalled]) {
            [shareArray removeObjectAtIndex:2];
            [shareArray removeObjectAtIndex:2];
        }
        
        for (int i = 0; i < shareArray.count; i++) {
            
            
            //            CGFloat left = 20;
            // 分享按钮适配
            CGFloat left = ( SCREEN_WIDTH - 55 * 4 ) / 5;
            
            CGFloat tempMaxY = maxY + 15;
            
            //            CGFloat x = left + (i % 4) * (55 + 20);
            CGFloat x = left + (i % 4) * (55 + left);
            CGFloat y = tempMaxY + (i / 4) * (55 + 7 + 14 + 15);
            
            UIButton *invitateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 55, 55)];
            [invitateButton setImage:[UIImage imageNamed:shareArray[i]] forState:UIControlStateNormal];
            invitateButton.tag = i;
            [self addSubview:invitateButton];
            [invitateButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(invitateButton.x, invitateButton.maxY + 7, invitateButton.width, 14)];
            [self addSubview:typeLabel];
            typeLabel.font = MyFont(14.0);
            typeLabel.text = shareTextArray[i];
            typeLabel.textAlignment = NSTextAlignmentCenter;
            typeLabel.textColor = [UIColor whiteColor];
            
            //最后一个 给maxY重新复制
            if (i == (shareArray.count - 1)) {
                maxY = typeLabel.maxY;
            }
            
        }
        
        self.height = maxY + 18;
//        return maxY + 18;
    }
    
    //
    else if (type == ActiveShareType || type == GrouptTalkShareType || type == DiscoverShareType || type == SquareAndDynamicTalkShareType) {
        
        NSMutableArray *shareArray = [NSMutableArray arrayWithObjects:PyqImage,WeiXinImage,QZoneImage,QQImage,WeiBoImage, nil];
        NSMutableArray *shareTextArray = [NSMutableArray arrayWithObjects:@"朋友圈",@"微信",@"QQ空间",@"QQ",@"微博", nil];
        
        if (![QQApiInterface isQQInstalled]) {
            [shareArray removeObjectAtIndex:2];
            [shareArray removeObjectAtIndex:2];
        }
        
        for (int i = 0; i < shareArray.count; i++) {
            
            //            CGFloat left = 20;
            //// 分享按钮适配
            CGFloat left = ( SCREEN_WIDTH - 55 * 4 ) / 5;
            
            CGFloat tempMaxY = lineView.maxY + 15;
            
            //            CGFloat x = left + (i % 4) * (55 + 20);
            CGFloat x = left + (i % 4) * (55 + left);
            
            CGFloat y = tempMaxY + (i / 4) * (55 + 7 + 14 + 15);
            
            UIButton *invitateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 55, 55)];
            [invitateButton setImage:[UIImage imageNamed:shareArray[i]] forState:UIControlStateNormal];
            invitateButton.tag = i;
            [self addSubview:invitateButton];
            [invitateButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(invitateButton.x, invitateButton.maxY + 7, invitateButton.width, 14)];
            [self addSubview:typeLabel];
            typeLabel.font = MyFont(14.0);
            typeLabel.text = shareTextArray[i];
            typeLabel.textAlignment = NSTextAlignmentCenter;
            typeLabel.textColor = [UIColor whiteColor];
            
            //最后一个 给maxY重新复制
            if (i == (shareArray.count - 1)) {
                maxY = typeLabel.maxY;
            }
        }
    }
    
//    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(10, maxY + 15, SCREEN_WIDTH - 20, 0.1)];
//    [self addSubview:secondLineView];
//    secondLineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    maxY = maxY + 28;
    UIView *BtnBg = [[UIView alloc] initWithFrame:CGRectMake(10, maxY, SCREEN_WIDTH - 20, 0)];
    BtnBg.backgroundColor = [UIColor whiteColor];
    BtnBg.clipsToBounds = YES;
    BtnBg.layer.cornerRadius = 4;
    [self addSubview:BtnBg];
    
    //乐活吧活动  乐活吧团聊
    if (
        type == ActiveShareType || type == GrouptTalkShareType || type == SquareAndDynamicTalkShareType) {
        
        //当前用户userId
        NSString *userId = [NSUSER_Defaults valueForKey:ZDS_USERID];
        NSString *gameAngle = [[NSUserDefaults standardUserDefaults] valueForKey:@"shareGroupGameAngle"];
        //当前选择用户id
        //        NSString *cuUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"shareGroupUserId"];
        //        //团长id
        //        NSString *groupUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"shareGroupUserId"];
        
        //置顶相关
        NSString *istop = [[NSUserDefaults standardUserDefaults] valueForKey:@"shareGroupIsTop"];
        NSNumber *topNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"shareGroupTopNumber"];
        NSNumber *topupper = [NSUSER_Defaults objectForKey:@"shareGroupTopUpper"];
        
        NSString *isCollect = [[NSUserDefaults standardUserDefaults] valueForKey:@"shareGroupIsCollection"];
        //收藏
        if (self.groupTalkModel.title && self.groupTalkModel.title.length > 0) {//精华帖
            UIButton *CollectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
            CollectButton.titleLabel.font = MyFont(15);
            CollectButton.backgroundColor = [UIColor whiteColor];
            if([isCollect isEqualToString:@"0"]) [CollectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
            else [CollectButton setTitle:@"收藏" forState:UIControlStateNormal];
            [CollectButton setTitleColor:OrangeColor forState:UIControlStateNormal];
            [CollectButton addTarget:self action:@selector(CollectButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [BtnBg addSubview:CollectButton];
            
            BtnBg.height = CollectButton.bottom;
            
        }
        
        
        //他人发布的内容
        if (![userId isEqualToString:self.groupTalkModel.userid]) {
            
            UIButton *deleteButton = nil;
            
            //活动或团聊     用户是团长
            if ((type == ActiveShareType || type == GrouptTalkShareType ) && ([gameAngle isEqualToString:@"0"] || [gameAngle isEqualToString:@"1"])) {
                if (BtnBg.height != 0) {
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                    line.backgroundColor = TimeColor;
                    [BtnBg addSubview:line];
                }
                deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
                deleteButton.backgroundColor= [UIColor whiteColor];
                [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
                deleteButton.titleLabel.font = MyFont(15);
                [deleteButton setTitleColor:OrangeColor forState:UIControlStateNormal];
//                [deleteButton setImage:[UIImage imageNamed:DeleteImage] forState:UIControlStateNormal];
//                [deleteButton setImage:[UIImage imageNamed:DeleteHightlightImage] forState:UIControlStateHighlighted];
                [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [BtnBg addSubview:deleteButton];
                
                BtnBg.height = deleteButton.bottom;
            }
            
            UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height , self.width - 10 * 2, 44)];
            reportButton.backgroundColor= [UIColor whiteColor];
            reportButton.titleLabel.font = MyFont(15);

            if (BtnBg.height != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                line.backgroundColor = TimeColor;
                [BtnBg addSubview:line];
            }
            if (self.groupTalkModel.title && self.groupTalkModel.title.length > 0) {
                
//                [reportButton setImage:[UIImage imageNamed:@"quxiao-570-80"] forState:UIControlStateNormal];
                [reportButton setTitle:@"取消" forState:UIControlStateNormal];
                [reportButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                reportButton.titleLabel.font = MyFont(15);
                [reportButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
//                [reportButton setImage:[UIImage imageNamed:JubaoImage] forState:UIControlStateNormal];
//                [reportButton setImage:[UIImage imageNamed:JubaoHighlightImage] forState:UIControlStateHighlighted];
                [reportButton setTitle:@"举报" forState:UIControlStateNormal];
                [reportButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [BtnBg addSubview:reportButton];
            
            BtnBg.height = reportButton.bottom;
            
            //自己发布的内容
        } else {
            if (BtnBg.height != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                line.backgroundColor = TimeColor;
                [BtnBg addSubview:line];
            }
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
            deleteButton.backgroundColor = [UIColor whiteColor];
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [deleteButton setTitleColor:OrangeColor forState:UIControlStateNormal];
            deleteButton.titleLabel.font = MyFont(15);
            [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [BtnBg addSubview:deleteButton];
            
            BtnBg.height = deleteButton.bottom;
            
            //用户是团长 & 乐活吧中团聊
            if (([gameAngle isEqualToString:@"0"] || [gameAngle isEqualToString:@"1"]) && type == GrouptTalkShareType) {
                
                //已置顶  显示取消置顶按钮
                if ([istop isEqualToString:@"1"]) {
                    if (BtnBg.height != 0) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                        line.backgroundColor = TimeColor;
                        [BtnBg addSubview:line];
                    }
                    UIButton *cancelTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
                    cancelTopButton.backgroundColor= [UIColor whiteColor];

//                    [cancelTopButton setImage:[UIImage imageNamed:CancelTop] forState:UIControlStateNormal];
//                    [cancelTopButton setImage:[UIImage imageNamed:CancelHighlightTop] forState:UIControlStateHighlighted];
                    [cancelTopButton setTitle:@"取消置顶" forState:UIControlStateNormal];
                    cancelTopButton.titleLabel.font = MyFont(15);
                    [cancelTopButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                    [cancelTopButton addTarget:self action:@selector(cancelTopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [BtnBg addSubview:cancelTopButton];
                    
                    BtnBg.height = cancelTopButton.bottom;
                    //非已置顶  但是置顶数为0 显示置顶按钮
#pragma 置顶数量
                } else if (topNumber.intValue < topupper.intValue){
                    if (BtnBg.height != 0) {
                        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                        line.backgroundColor = TimeColor;
                        [BtnBg addSubview:line];
                    }
                    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
                    [topButton setTitle:@"置顶" forState:UIControlStateNormal];
                    [topButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                    topButton.titleLabel.font = MyFont(15);
                    topButton.backgroundColor= [UIColor whiteColor];
//                    [topButton setImage:[UIImage imageNamed:SetTop] forState:UIControlStateNormal];
//                    [topButton setImage:[UIImage imageNamed:SetHighlightTop] forState:UIControlStateHighlighted];
                    [topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [BtnBg addSubview:topButton];
                    
                    BtnBg.height = maxY;
                }
            }
        }
    }
    
    //撒欢分享
    else if (type == DiscoverShareType) {
        
        NSString *userId = [NSUSER_Defaults valueForKey:ZDS_USERID];
        
        if (![userId isEqualToString:self.discoverModel.userid]) {
            if (BtnBg.height != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                line.backgroundColor = TimeColor;

                [BtnBg addSubview:line];
            }
            UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(0,BtnBg.height, self.width - 10 * 2, 44)];
            reportButton.backgroundColor= [UIColor whiteColor];
            [reportButton setTitle:@"举报" forState:UIControlStateNormal];
            [reportButton setTitleColor:OrangeColor forState:UIControlStateNormal];
            reportButton.titleLabel.font = MyFont(15);
//            [reportButton setImage:[UIImage imageNamed:JubaoImage] forState:UIControlStateNormal];
//            [reportButton setImage:[UIImage imageNamed:JubaoHighlightImage] forState:UIControlStateHighlighted];
            [reportButton addTarget:self action:@selector(reportButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [BtnBg addSubview:reportButton];
            
            BtnBg.height = reportButton.maxY;
        } else {
            if (BtnBg.height != 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
                line.backgroundColor = TimeColor;

                [BtnBg addSubview:line];
            }
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height, self.width - 10 * 2, 44)];
            deleteButton.backgroundColor= [UIColor whiteColor];
//            [deleteButton setImage:[UIImage imageNamed:DeleteImage] forState:UIControlStateNormal];
//            [deleteButton setImage:[UIImage imageNamed:DeleteHightlightImage] forState:UIControlStateHighlighted];
            [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [deleteButton setTitleColor:OrangeColor forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [BtnBg addSubview:deleteButton];
            deleteButton.titleLabel.font = MyFont(15);

            
            BtnBg.height = deleteButton.maxY;
        }
    }
    
    else {
        if (BtnBg.height != 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, BtnBg.height-1, SCREEN_WIDTH, 1)];
            line.backgroundColor = TimeColor;

            [BtnBg addSubview:line];
        }
        UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnBg.height , self.width - 10 * 2, 44)];
        reportButton.backgroundColor= [UIColor whiteColor];
        [reportButton setTitle:@"取消" forState:UIControlStateNormal];
        [reportButton setTitleColor:OrangeColor forState:UIControlStateNormal];
        reportButton.titleLabel.font = MyFont(15);
        [reportButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [BtnBg addSubview:reportButton];
        BtnBg.height = reportButton.bottom;
    }
    
    self.height = BtnBg.bottom + 18;
    
    for (UIView *chirld in self.subviews) {
        if (chirld.height == 14 || chirld.width == 55) {
            chirld.alpha = 0;
        }
    }
    int i = 0.1;
    for (UIView *chirld in self.subviews) {
        if (chirld.height == 14 || chirld.width == 55) {
            i += 0.5;
            [UIView animateWithDuration:0.5 delay:i options:0 animations:^{
                chirld.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    /**
     取消按钮2.3.4废弃
     */
    //    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(17.5, maxY, self.width - 17.5 * 2, 40)];
    //    [cancelButton setImage:[UIImage imageNamed:@"quxiao-570-80"] forState:UIControlStateNormal];
    //    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [self addSubview:cancelButton];
    
    return self.height;
}

#pragma mark Event Responses

#pragma mark 邀请
- (void)invitateButtonClick:(UIButton *)invidateButton {
    
    NSInteger index = invidateButton.tag;
    //花束
    //    NSString *s = InvitateMessage;
    
    //    NSString *s = [NSString stringWithFormat:@"来脂斗士搜/“%@/”，跟我一起快乐减脂吧！ ",[NSUSER_Defaults valueForKey:ZDS_URLREQUEST_NICKNAME]];
    NSString *s = [NSString stringWithFormat:@"来脂斗士搜\"%@\" ，跟我一起快乐减脂吧！ ",[NSUSER_Defaults valueForKey:@"fenxianggamename"]];
    
    NSString *title = @"推荐脂斗士给你";
    
    NSData *data = [NSUSER_Defaults objectForKey:@"fenxianggameimage"];
    
    UIImage *image = [UIImage imageWithData:data];
    NSString *url = ZDS_APPSTOREURL;
    
    if ([WWTolls isNull:image]) {
        image = [UIImage imageNamed:@"ICON_120.png"];
    }
    
    if (self.shareGameSubClassViewType == GeneralGroupShareType || self.shareGameSubClassViewType == GeneralGroupOutShareType) {
        s = [NSString stringWithFormat:@"我在%@等你来跟我一起瘦",[NSUSER_Defaults valueForKey:@"fenxianggamename"]];
        
        title = @"推荐脂斗士给你";
        
        NSData *data = [NSUSER_Defaults objectForKey:@"fenxianggameimage"];
        
        image = [UIImage imageWithData:data];
        if ([WWTolls isNull:image]) {
            image = [UIImage imageNamed:@"ICON_120.png"];
        }
        url = [NSString stringWithFormat:@"%@h5/game/huanle.html?gameid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,[NSUSER_Defaults objectForKey:@"fenxianggameid"]];
    }
    
    //粉丝
    if (index == 0) {
        if ([self.shareGameDelegate respondsToSelector:@selector(invitationButton)]) {
            [self.shareGameDelegate invitationButton];
        }
    }
    //朋友圈
    else if (index == 1) {
        [self friendShareMyInformation:s title:title image:image url:url];
    }
    //微信好友
    else if (index == 2) {
        [self weixinShareMyInformation:s title:title image:image url:url];
    }
    //新浪微博
    else if (index == 3) {
        [self sinaShareWithContent:s title:title image:image url:url];
    }
    //QQ
    else if (index == 4) {
        [self qqFriendShareWithContent:s title:title image:image url:url];
        
    }
    //QQ空间
    else if (index == 5) {
        [self qzoneShareWithContent:s title:title image:image url:url];
    }
    
    
}

#pragma mark 分享
- (void)shareButtonClick:(UIButton *)shareButton {
    
    NSInteger index = shareButton.tag;
    //花束
    NSString *s = @"测试花束";
    NSString *title = @"";
    UIImage *image = nil;
    NSString *url = nil;
    
    //活动吧活动
    if (self.shareGameSubClassViewType == ActiveShareType) {
        s = GroupActBarMessage;
        //        title = @"我在脂斗士等你";
        image = [UIImage imageNamed:@"ICON_120.png"];
        url = ZDS_APP_DOWNLOAD;
        //撒欢图文
    } else if (self.shareGameSubClassViewType == DiscoverShareType) {
        s = self.discoverModel.content;
        if (s.length < 1) {
            s = DiscoverShareMessage;
        }
        //     title = @"我在脂斗士等你";
        if ([WWTolls isNull:self.image] || self.discoverModel.showimage.length < 1) {
            image = [UIImage imageNamed:@"ICON_120.png"];
        } else {
            image = self.image;
        }
        url = ZDS_APP_DOWNLOAD;
        url = [self discoverShareH5WithShowId:self.discoverModel.showid andPraimgcount:self.discoverModel.praisecount];
        //活动吧图文
    } else if (self.shareGameSubClassViewType == GrouptTalkShareType || self.shareGameSubClassViewType == SquareAndDynamicTalkShareType) {
        
        //        title = @"我在脂斗士等你";
        s = self.groupTalkModel.content;
        if (s.length < 1) {
            s = GroupActBarMessage;
        }
        if ([WWTolls isNull:self.image] || self.groupTalkModel.imageurl.length < 1) {
            image = [UIImage imageNamed:@"ICON_120.png"];
        } else {
            image = self.image;
        }
        url = ZDS_APP_DOWNLOAD;
        url = [self groupShareH5WithBarid:self.groupTalkModel.barid andPraisecount:self.groupTalkModel.goodSum];
        if(_groupTalkModel.title && _groupTalkModel.title.length>0){
            url = [NSString stringWithFormat:@"%@h5/show/playbartitle.html?talkid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,self.groupTalkModel.barid];
        }
        //团组邀请 (没有团组邀请这里)
    } else if (self.shareGameSubClassViewType == inType) {
        
        //团组分享
    } else if (self.shareGameSubClassViewType == outType) {//28天团组分享
        s = ShareMessage;
        //        title = @"我在脂斗士等你";
        image = [UIImage imageNamed:@"ICON_120.png"];
        url = ZDS_APPSTOREURL;
    } else if (self.shareGameSubClassViewType == NotifyHTMLShareType){
        s = webHtmlMessage;
        title = @"脂斗士又有新消息啦！";
        image = [UIImage imageNamed:@"ICON_120.png"];
        url = [NSUSER_Defaults objectForKey:@"htmlshareHtml"];
        if ([url rangeOfString:@"/lb/index.html?reportid="].length > 0) {
            image = [UIImage imageNamed:@"tbrj-120.jpg"];
            title = @"《蜕变日记》记录你的坚持";
            s = @"用努力与汗水绘制一道风景，让他们领教你的倔强！";
        }
    }else if(self.shareGameSubClassViewType == GeneralGroupOutShareType){
        s = InvitateMessage;
        s = [NSString stringWithFormat:@"我在%@等你来跟我一起瘦",[NSUSER_Defaults valueForKey:@"fenxianggamename"]];
        
        title = @"推荐脂斗士给你";
        
        NSData *data = [NSUSER_Defaults objectForKey:@"fenxianggameimage"];
        
        image = [UIImage imageWithData:data];
        if ([WWTolls isNull:image]) {
            image = [UIImage imageNamed:@"ICON_120.png"];
        }
        
        url = [NSString stringWithFormat:@"%@h5/game/huanle.html?gameid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,[NSUSER_Defaults objectForKey:@"fenxianggameid"]];
    }
    
    if ([QQApiInterface isQQInstalled]) {
        
        //朋友圈
        if (index == 0) {
            [self friendShareMyInformation:s title:title image:image url:url];
        }
        //微信好友
        else if (index == 1) {
            [self weixinShareMyInformation:s title:title image:image url:url];
        }
        //QQ空间
        else if (index == 2) {
            [self qzoneShareWithContent:s title:@" " image:image url:url];
        }
        //QQ好友
        else if (index == 3) {
            [self qqFriendShareWithContent:s title:@" " image:image url:url];
        }
        //新浪微博
        else if (index == 4) {
            [self sinaShareWithContent:s title:title image:image url:url];
        }
    } else {
        //朋友圈
        if (index == 0) {
            [self friendShareMyInformation:s title:title image:image url:url];
        }
        //微信好友
        else if (index == 1) {
            [self weixinShareMyInformation:s title:title image:image url:url];
        }
        
        //新浪微博
        else if (index == 2) {
            [self sinaShareWithContent:s title:title image:image url:url];
        }
    }
    
    
}

- (void)cancelAnimal{
    int i = 0.1;
    for (UIView *chirld in self.subviews) {
        if (chirld.height == 14 || chirld.width == 55) {
            i += 0.5;
            [UIView animateWithDuration:0.2 delay:i options:0 animations:^{
                chirld.alpha = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
#pragma mark 取消按钮
- (void)cancelButtonClick:(UIButton *)cancelButton {
    [self cancelAnimal];
    if ([self.shareGameDelegate respondsToSelector:@selector(cancelButtonSender)]) {
        [self.shareGameDelegate cancelButtonSender];
    }
}

#pragma mark 举报
- (void)reportButtonClick:(UIButton *)reportButton {
    if ([self.shareGameDelegate respondsToSelector:@selector(shareGameSubClassViewDelegateReport)]) {
        [self.shareGameDelegate shareGameSubClassViewDelegateReport];
    }
}

#pragma mark 删除
- (void)CollectButtonButtonClick:(UIButton *)delegateButton {
    if ([self.shareGameDelegate respondsToSelector:@selector(shareGameSubClassViewDelegateCollect)]) {
        [self.shareGameDelegate shareGameSubClassViewDelegateCollect];
    }
}


#pragma mark 删除
- (void)deleteButtonClick:(UIButton *)delegateButton {
    if ([self.shareGameDelegate respondsToSelector:@selector(shareGameSubClassViewDelegateDelete)]) {
        [self.shareGameDelegate shareGameSubClassViewDelegateDelete];
    }
}

#pragma mark 置顶
- (void)topButtonClick:(UIButton *)topButton {
    if ([self.shareGameDelegate respondsToSelector:@selector(shareGameSubClassViewDelegateTop)]) {
        [self.shareGameDelegate shareGameSubClassViewDelegateTop];
    }
}

#pragma mark 取消置顶
- (void)cancelTopButtonClick:(UIButton *)cancelTopButton {
    
    if ([self.shareGameDelegate respondsToSelector:@selector(shareGameSubClassViewDelegateCancelTop)]) {
        [self.shareGameDelegate shareGameSubClassViewDelegateCancelTop];
    }
}

#pragma mark - Private Methods
#pragma mark - 分享微信
-(void)weixinShareMyInformation:(NSString*)description title:(NSString *)title image:(UIImage *)image url:(NSString *)url
{
    [self cancelButtonClick:nil];
    [self judeWeinXinShare];
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//分享内容带图片和文字时必须为NO
    //    UIImage *image = [UIImage imageNamed:@"ICON_120.png"];
    //    NSString *title = @"我在脂斗士等你";
    //
    //    if(self.shareGameSubClassViewType == inType){//邀请
    //        title = @"快来脂斗士找我";
    //    }
    //
    //    if (self.shareGameSubClassViewType == inType &&[[NSUSER_Defaults objectForKey:@"fenxianggameimage"] isKindOfClass:[NSData class]]) {
    //        NSData *data = [NSUSER_Defaults objectForKey:@"fenxianggameimage"];
    //        image = [UIImage imageWithData:data];
    //    }
    
    //设置这个路径是为了点击聊天列表的气泡时也可以跳转
    WXWebpageObject *ext = [WXWebpageObject object];
    
    //获取app网址
    //    NSString *url = ZDS_APPSTOREURL;
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    message.mediaObject = ext;
    //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
    message.title = title;
    message.description = description;
    req.message = message;
    //    if (shartType == 1) {
    req.scene = WXSceneSession;//微信
    //    }else{
    //        req.scene = WXSceneTimeline;//微信朋友圈
    //    }
    [WXApi sendReq:req];
}

#pragma mark - 朋友圈
//title 和description互相赋值 暂没照原因
-(void)friendShareMyInformation:(NSString*)description title:(NSString *)title image:(UIImage *)image url:(NSString *)url
{
    [self cancelButtonClick:nil];
    [self judeWeinXinShare];
    NSLog(@"点击了返回");
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//分享内容带图片和文字时必须为NO
    
    //    UIImage *image = [UIImage imageNamed:@"ICON_120.png"];
    //
    //    if (self.shareGameSubClassViewType == inType && [[NSUSER_Defaults objectForKey:@"fenxianggameimage"] isKindOfClass:[NSData class]]) {
    //        NSData *data = [NSUSER_Defaults objectForKey:@"fenxianggameimage"];
    //        image = [UIImage imageWithData:data];
    //        //        image.size = CGSizeMake(120, 120);
    //    }
    
    //设置这个路径是为了点击聊天列表的气泡时也可以跳转
    WXWebpageObject *ext = [WXWebpageObject object];
    
    //    NSString *url = ZDS_APPSTOREURL;
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    message.mediaObject = ext;
    //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
    message.title = description;
    message.description = title;
    
    req.message = message;
    //    if (shartType == 1) {
    req.scene = WXSceneTimeline;//微信朋友圈
    
    [WXApi sendReq:req];
    
}

-(void)judeWeinXinShare
{
    [NSUSER_Defaults setObject:@"007" forKey:ZDS_WEIXINJUDGE];
    [NSUSER_Defaults synchronize];
}

#pragma mark - QZone
- (void)qzoneShareWithContent:(NSString *)content title:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

#pragma mark - QQFriend
- (void)qqFriendShareWithContent:(NSString *)content title:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    
    [UMSocialData defaultData].extConfig.qqData.url = url;
    
    [UMSocialData defaultData].extConfig.qqData.title = title;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}

#pragma mark - Sina
- (void)sinaShareWithContent:(NSString *)content title:(NSString *)title image:(UIImage *)image url:(NSString *)url {
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://sns.whalecloud.com/tencent2/callback";
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = content;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1aaa";
    webpage.title = title;
    webpage.description = content;
    NSData *imageData = UIImagePNGRepresentation(image);
    webpage.thumbnailData = imageData;
    webpage.webpageUrl = url;
    message.mediaObject = webpage;
    
    //myDelegate.wbtoken为空
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    
    [WeiboSDK sendRequest:request];
    [self cancelButtonClick:nil];
}

#pragma mark 撒欢图文的h5链接
- (NSString *)discoverShareH5WithShowId:(NSString *)showId andPraimgcount:(NSString *)praimgcount {
    
    NSString *str = [NSString stringWithFormat:@"%@h5/show/showdetail.html?praimgcount=%@&showid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,praimgcount,showId];
    
    //    NSString *str = [NSString stringWithFormat:@"http://test.zhidoushi.com/zhidoushi/h5/show/showdetail.html?praimgcount=%@&showid=%@",praimgcount,showId];
    
    NSLog(@"撒欢图文的h5链接:%@",str);
    
    return str;
}

#pragma mark 团组图文的h5链接
- (NSString *)groupShareH5WithBarid:(NSString *)barId andPraisecount:(NSString *)praisecount{
    
    NSString *str = [NSString stringWithFormat:@"%@h5/show/playbartalk.html?praisecount=%@&talkid=%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"1",barId];
    NSLog(@"团组图文的h5链接:%@",str);
    return str;
}

#pragma mark app下载地址
- (NSString *)downloadUrl {
    return @"http://a.app.qq.com/o/simple.jsp?pkgname=com.health.fatfighter";
}

//#pragma mark - 动画
//-(void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    self.backgroundColor = [UIColor clearColor];
//    for (UIView *chirld in self.subviews) {
//        if (chirld.height == 14 || chirld.width == 55) {
//            chirld.alpha = 0;
//        }
//    }
//    for (UIView *chirld in self.subviews) {
//        if (chirld.height == 14 || chirld.width == 55) {
//            [UIView animateWithDuration:1 delay:0.5 options:0 animations:^{
//                chirld.alpha = 1;
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
//    }
////    self.backgroundColor = [UIColor whiteColor];
//}
//
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    [super drawLayer:layer inContext:ctx];
//    self.backgroundColor = [UIColor clearColor];
//}

@end




