//
//  CustomActionSheet.m
//  iSport2
//
//  Created by xinglei on 13-5-27.
//  Copyright (c) 2013年 xinglei. All rights reserved.
//

#import "CustomActionSheet.h"
static const CGFloat    ButtonRadius = 2;
static const float bottomHeight = 216;

@implementation CustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithTitle:(NSString *)title delegate:(id<CustomActionSheetDelegate>)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    if (self = [super init]) {
        self.delegate = aDelegate;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        
        self.bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, bottomHeight)];
//        self.bottomImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
        self.bottomImageView.image = [UIImage imageNamed:@"ActionSheetBottom.png"];
        self.bottomImageView.userInteractionEnabled = YES;
        [self addSubview:self.bottomImageView];
        
        for (int i = 0; i < 3; i++) {
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == 0) {
                [button setTitle:destructiveButtonTitle forState:UIControlStateNormal];
                button.layer.cornerRadius = ButtonRadius;
                button.layer.masksToBounds = YES;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"BtnSave"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"BtnSavePres"] forState:UIControlStateHighlighted];
                button.frame = CGRectMake(20, 19, 280, 46);
            }
            else if (i == 1){
                [button setTitle:otherButtonTitles forState:UIControlStateNormal];
                button.layer.cornerRadius = ButtonRadius;
                button.layer.masksToBounds = YES;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"photoSelect.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"photoSelectPres.png"] forState:UIControlStateHighlighted];
                
                if ([otherButtonTitles isEqualToString:@"删除"]) {
                    [button setBackgroundImage:[UIImage imageNamed:@"BtnDel"] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"BtnDelPres"] forState:UIControlStateHighlighted];
                }
                
                button.frame = CGRectMake(20, 44+19*2, 280, 46);
            }
            else if (i == 2){
                [button setTitle:cancelButtonTitle forState:UIControlStateNormal];
                button.layer.cornerRadius = ButtonRadius;
                button.layer.masksToBounds = YES;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"BtnCancel"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"BtnCancelPres.png"] forState:UIControlStateHighlighted];
                button.frame = CGRectMake(20, 88 + 19*3, 280, 46);
            }
            button.tag = i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.bottomImageView addSubview:button];
        }
        
    }
    return  self;
}

-(void)buttonClicked:(UIButton*)button
{
    [self dismissView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate customActionSheet:self clickedButtonAtIndex:button.tag];
    }
}

-(void)show
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelAlert;
    self.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT);
    [window addSubview:self];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomImageView.frame = CGRectMake(0, SCREEN_HEIGHT-bottomHeight, 320, bottomHeight);
        
    } completion:^(BOOL finished){

    }];
}

-(void)dismissView
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.0];
        self.bottomImageView.frame = CGRectMake(0, SCREEN_HEIGHT, 320, bottomHeight);

    } completion:^(BOOL finished) {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        window.windowLevel = UIWindowLevelNormal;

        [self.bottomImageView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
