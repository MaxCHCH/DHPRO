//
//  BreakUpViewController.m
//  zhidoushi
//
//  Created by licy on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BreakUpViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIButton+SSLPointBigger.h"
#import "BreakUpAlertView.h"
#import "UITextView+LimitLength.h"

@interface BreakUpViewController () <UITextViewDelegate,SSLAlertViewTapDelegate>

@property (nonatomic,strong)UILabel *textPlacehoader;
@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)NSMutableArray *buttonArray;

@property (nonatomic,strong)NSMutableArray *reasonArray;

@end

@implementation BreakUpViewController

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"解散团组页面"];
    
    
    //导航栏标题
    self.titleLabel.text = @"解散团组";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    
    //导航栏右边按钮
    self.rightButton.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"解散团组页面"];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)dealloc {
    NSLog(@"解散团组页面释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#f7f1f1"];
    
    self.reasonArray = [NSMutableArray arrayWithObjects:@"团组创建有误",@"没有时间维护了",@"团员不活跃",@"其他", nil];
    
    TPKeyboardAvoidingScrollView *bgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 76)];
    topView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:topView];
    //    topView.layer.borderWidth = 0.5;
    //    topView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, topView.width, topView.height - 10)];
    //    titleLable.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
    [topView addSubview:titleLable];
    titleLable.textColor = TimeColor;
    titleLable.text = @"为了维护其他团员权益，解散团组需要审核哦\n而且团组一旦解散将无法恢复";
    titleLable.font = MyFont(13.0);
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.numberOfLines = 2;
    
    CGFloat maxY = topView.maxY;
    
    
    //    NSArray *titleArray = @[@"团组创建有误",@"没有时间维护了",@"团员不活跃",@"其他"];
    
    for (int i = 0; i < self.reasonArray.count; i++) {
        
        CGFloat y = maxY + 10 + 50 * i;
        
        UIButton *tempBgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 50)];
        [bgView addSubview:tempBgButton];
        tempBgButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
        tempBgButton.tag = i;
        [tempBgButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [tempBgButton setImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
        [tempBgButton setImage:[UIImage imageNamed:@"team_yiguanzhu.png"] forState:UIControlStateSelected];
        tempBgButton.imageEdgeInsets = UIEdgeInsetsMake((tempBgButton.height - 16) / 2, tempBgButton.width - 12 - 16, (tempBgButton.height - 16) / 2, 12);
        tempBgButton.selected = NO;
        [self.buttonArray addObject:tempBgButton];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 130, 16)];
        [tempBgButton addSubview:textLabel];
        textLabel.textColor = [WWTolls colorWithHexString:@"#4f777f"];
        textLabel.font = MyFont(16.0);
        textLabel.text = self.reasonArray[i];
        
        if (tempBgButton.tag == 3) {
            tempBgButton.selected = YES;
            maxY = tempBgButton.maxY;
        }
        
        UIView *inLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tempBgButton.width, 0.5)];
        [tempBgButton addSubview:inLineView];
        inLineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    }
    
    //textView
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, maxY + 10, SCREEN_WIDTH, 200)];
    
    [text limitTextLength:50];
    //    self.textView = text;
    //    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    text.layoutManager.allowsNonContiguousLayout = NO;
    self.textView = text;
    text.delegate = self;
    text.font = MyFont(16);
    text.textColor = ContentColor;
    text.scrollEnabled = YES;
    [bgView addSubview:text];
    
    //理由
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(6, 8, text.width - 10, 16)];
    textlbl.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"输入30文字理由";
    textlbl.textColor = [ContentColor colorWithAlphaComponent:0.6];
    textlbl.font = MyFont(16);
    [text addSubview:textlbl];
    //提交申请按钮
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bottom - 110, SCREEN_WIDTH, 50)];
//    commitButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [bgView addSubview:commitButton];
    [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton setTitle:@"申请提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[WWTolls colorWithHexString:@"#ff5203"] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"dhbj-750-128"] forState:UIControlStateNormal];
    
    if (iPhone4) {
        bgView.contentSize = CGSizeMake(SCREEN_WIDTH, commitButton.maxY + 17);
    }
}

#pragma mark - Delegate

#pragma mark SSLAlertViewTapDelegate
- (void)sslAlertViewTapCancelTap {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [textView textFieldTextLengthLimit:nil];
    self.textPlacehoader.hidden = textView.text.length > 0;
}

#pragma mark - Event Responses

#pragma mark 返回
- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 选择按钮点击
- (void)selectButtonClick:(UIButton *)selectButton {
    
    //已经被选中，点击无操作
    if (selectButton.selected) {
        return;
    }
    
    //点击其他按钮
    if (selectButton.tag == 3) {
        self.textView.hidden = NO;
        
        //点击三种理由按钮
    } else {
        self.textView.hidden = YES;
    }
    
    [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = (UIButton *)obj;
        if (button.tag == selectButton.tag) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }];
}

#pragma mark 申请提交
- (void)commitButtonClick:(UIButton *)commitButton {
    
    UIButton *ohterButton = self.buttonArray[3];
    
    //手动输入理由
    if (ohterButton.selected) {
        
        if ([WWTolls isNull:self.textView.text]) {
            [self showAlertMsg:@"请输入内容" andFrame:CGRectZero];
        } else {
            
            [self requestWithUrgetaskWithReason:self.textView.text];
        }
        
        //提供理由
    } else {
        
        __block NSString *str = nil;
        
        [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *button = (UIButton *)obj;
            if (button.selected) {
                str = self.reasonArray[button.tag];
            }
        }];
        
        [self requestWithUrgetaskWithReason:str];
    }
}

#pragma mark - Private Methods


#pragma mark - Request
#pragma mark 解散团组申请
- (void)requestWithUrgetaskWithReason:(NSString *)reason {
    
    NSLog(@"解散理由:%@",reason);
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.gameId] forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",reason] forKey:@"reason"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISSOLVE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if ([dic[@"result"] isEqualToString:@"0"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"breakUpGroup" object:nil];
            NSLog(@"处理成功")
            
            BreakUpAlertView *alertView = [[BreakUpAlertView alloc] initWithFrame:weakSelf.view.window.bounds];
            alertView.sslAlertViewTapDelegate = weakSelf;
            [alertView createView];
            [weakSelf.view.window addSubview:alertView];
            [alertView ssl_show];
            
        }
    }];
}

#pragma mark - Getters And Setters
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}

- (NSMutableArray *)reasonArray {
    if (!_reasonArray) {
        _reasonArray = [NSMutableArray array];
    }
    return _reasonArray;
}



@end
