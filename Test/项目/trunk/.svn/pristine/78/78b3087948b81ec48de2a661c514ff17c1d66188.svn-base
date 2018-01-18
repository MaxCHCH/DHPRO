//
//  discussAlertView.m
//  zhidoushi
//
//  Created by nick on 15/9/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "discussAlertView.h"
#import "UIView+SSLAlertViewTap.h"

@implementation discussAlertView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <DiscussAlertDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - UI

#pragma mark 创建帖子正文UI 并传入发布人id
- (void)createViewWithContentUserId:(NSString*)userid;{
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addGeneralTap];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 160, self.width, 160)];
    if([userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
        bottomView.frame = CGRectMake(0, self.height - 110, self.width, 110);
    }
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    //复制
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn addTarget:self action:@selector(copyContent:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:copyBtn];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discuss_copy"]];
    img.frame = CGRectMake(SCREEN_WIDTH/2 - 22, 18, 14, 14);
    [copyBtn addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 6, 0, 100, 50)];
    label.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    label.text = [NSString stringWithFormat:@"复制"];
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    label.font = MyFont(16.0);
    [copyBtn addSubview:label];
    if (![userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [bottomView addSubview:line];
        //举报
        UIButton *JubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, self.width, 50)];
        JubaoBtn.backgroundColor = [UIColor whiteColor];
        [JubaoBtn addTarget:self action:@selector(JubaoContnt:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:JubaoBtn];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discuss_jubao"]];
        img.frame = CGRectMake(SCREEN_WIDTH/2 - 24, 18, 16, 14);
        [JubaoBtn addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 6, 0, 100, 50)];
        label.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
        label.text = [NSString stringWithFormat:@"举报"];
        label.textColor = [WWTolls colorWithHexString:@"#535353"];
        label.font = MyFont(16.0);
        [JubaoBtn addSubview:label];
    }
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, bottomView.height - 50, self.width, 50)];
    cancelButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = MyFont(16.0);
    [bottomView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 创建评论UI 并传入回复模型
- (void)createViewWithModel:(DiscoverReplyModel*)model {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addGeneralTap];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 160, self.width, 160)];
    if([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]){
        bottomView.frame = CGRectMake(0, self.height - 110, self.width, 110);
    }
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    //复制
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn addTarget:self action:@selector(copyReply:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:copyBtn];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discuss_copy"]];
    img.frame = CGRectMake(SCREEN_WIDTH/2 - 22, 18, 14, 14);
    [copyBtn addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 6, 0, 100, 50)];
    label.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    label.text = [NSString stringWithFormat:@"复制"];
    label.textColor = [WWTolls colorWithHexString:@"#535353"];
    label.font = MyFont(16.0);
    [copyBtn addSubview:label];
    if (![model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [bottomView addSubview:line];
        //举报
        UIButton *JubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, self.width, 50)];
        JubaoBtn.backgroundColor = [UIColor whiteColor];
        [JubaoBtn addTarget:self action:@selector(Jubaoreplay:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:JubaoBtn];
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discuss_jubao"]];
        img.frame = CGRectMake(SCREEN_WIDTH/2 - 24, 18, 16, 14);
        [JubaoBtn addSubview:img];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(img.right + 6, 0, 100, 50)];
        label.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
        label.text = [NSString stringWithFormat:@"举报"];
        label.textColor = [WWTolls colorWithHexString:@"#535353"];
        label.font = MyFont(16.0);
        [JubaoBtn addSubview:label];
    }
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, bottomView.height - 50, self.width, 50)];
    cancelButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = MyFont(16.0);
    [bottomView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Event Responses
#pragma mark 举报点击事件
- (void)Jubaoreplay:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(JuBaoAlertConfirmClick:)]) {
        [self.delegate JuBaoAlertConfirmClick:self];
    }
    [self ssl_hidden];
}
#pragma mark - 复制点击事件
- (void)copyContent:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(copyContentAlertConfirmClick:)]) {
        [self.delegate copyContentAlertConfirmClick:self];
    }
    [self ssl_hidden];
}
- (void)JubaoContnt:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(JuBaoContentAlertConfirmClick:)]) {
        [self.delegate JuBaoContentAlertConfirmClick:self];
    }
    [self ssl_hidden];
}
#pragma mark - 复制点击事件
- (void)copyReply:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(copyAlertConfirmClick:)]) {
        [self.delegate copyAlertConfirmClick:self];
    }
    [self ssl_hidden];
}
#pragma mark 取消点击事件
- (void)cancelButtonClick:(UIButton *)button {
    [self ssl_hidden];
}

@end
