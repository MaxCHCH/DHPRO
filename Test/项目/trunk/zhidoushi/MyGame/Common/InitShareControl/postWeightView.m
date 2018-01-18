//
//  postWeightView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "postWeightView.h"

#import "WWRequestOperationEngine.h"
#import "JSONKit.h"
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
#import "PickerView+.h"
#import "WeightAlertView.h"
#import "UIView+SSLShowAlert.h"
#import "InitShareWeightView.h"

@interface postWeightView ()<PickerViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)PickerView_ * picker;

@end

@implementation postWeightView

#pragma mark - Init

+ (postWeightView*)initView {
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:@"postWeightView" owner:self options:nil];
    return [nibView lastObject];
}

#pragma mark -  pickViewDelegate 必须实现其中的两个方法†注意†
-(void)cancelBtn {
    [self hiddenPickerView];
}

-(void)pickerValue:(NSString*)str
{
    self.weightTextField.text = str;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self requestWithSaveWeg];
    
//    if (buttonIndex == 1) {
//        
//        [self requestWithSaveWeg];
//    }
}

#pragma mark - Event Responses
#pragma mark 确认按钮事件
- (IBAction)confirm:(id)sender {
    
    if ([[NSUSER_Defaults objectForKey:@"xianzaidetizhong"] isEqualToString:@"0"] && ([[NSUSER_Defaults objectForKey:@"xianzaidetype"] isEqualToString:@"2"] || [self.gameModel isEqualToString:@"3"])) {
        
        if (iOS8) {
            NSString *title = @"确认上传吗？";
            NSString *message = @"";
            NSString *cancelButtonTitle = @"取消";
            NSString *otherButtonTitle = @"确定";
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self requestWithSaveWeg];
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            InitShareWeightView *view = (InitShareWeightView *)self.postWeightDelegate;
            [(UIViewController *)view.initShareDelegate presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认上传吗？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
        
        
//        UIAlertView *alert = [[UIAlertView alloc] init];
//        alert.title = @"确认上传吗？";
//        alert.delegate = self;
//        [alert addButtonWithTitle:@"确定"];
//        [alert show];
        
    }else{
        [self requestWithSaveWeg];
    }
}

#pragma mark 取消按钮事件
- (IBAction)cancel:(id)sender {
    if ([self.postWeightDelegate respondsToSelector:@selector(cancelButtonSender)]) {
        [self.postWeightDelegate cancelButtonSender];
    }
}

#pragma mark - Private Methods
-(void)hiddenPickerView{
    [UIView animateWithDuration:0.2f animations:^{
        [self.picker setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 200)];
    }];
}

#pragma mark - Request
- (void)requestWithSaveWeg {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SAVEWEG];
    
    
    if (self.weightTextField.text.length!=0) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSString stringWithFormat:@"%@",self.parterid] forKey:@"parterid"];
        [dic setObject:@"1" forKey:@"phasepro"];
        NSString *weightString =[NSString stringWithFormat:@"%.1f",[self.weightTextField.text floatValue]];
        [NSUSER_Defaults setObject:weightString forKey:ZDS_LAST_WEIGHT];
        [dic setObject:weightString forKey:@"uploadweg"];
        
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dic requestOperationBlock:^(NSDictionary *dic) {
            
            if (!dic[ERRCODE]) {
                
                NSString *myString = [dic objectForKey:@"uplflag"];
                NSString *loseweg = [dic objectForKey:@"loseweg"];
                
                if ([myString isEqualToString:@"0"]) {
                    
                    if ([self.gameModel isEqualToString:@"3"]) {
                        
                        //第一次上传
                        if ([[NSUSER_Defaults objectForKey:@"xianzaidetizhong"] isEqualToString:@"0"]) {
                            
                            [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"初始体重上传成功，以后要养成记录的好习惯哦~" andFrame:CGRectMake(70,100,200,60) timeInterval:2];
                            
                        } else {
                            
                            WeightAlertView *weight = [[WeightAlertView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds withMessage:loseweg];
                            [[UIApplication sharedApplication].keyWindow addSubview:weight];
                            [weight ssl_show];
                        }
                    } else {
                        
                        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"上传成功,继续加油吧!" andFrame:CGRectMake(70,100,200,60)];
                    }
                }
            }
            
            if ([weakSelf.postWeightDelegate respondsToSelector:@selector(cancelButtonSender)]) {
                [weakSelf.postWeightDelegate cancelButtonSender];
                [weakSelf.postWeightDelegate confirmButtonSender];
            }
        }];
        
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"请完成资料" andFrame:CGRectMake(70,100,200,60)];
    }
}

#pragma mark - Public Methods
-(void)configureView{
    
    CGRect rect = self.weightTextField.frame;
    rect.size.height = 41;
    self.weightTextField.frame = rect;

    self.lineView.height = 0.5;
    
    self.picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, self.weightTextField.bottom-10, SCREEN_WIDTH, 200) withType:wightType];
    self.picker.backgroundColor = [UIColor clearColor];
    self.picker.cancelBtn.hidden = YES;
    self.picker.selectBtn.hidden = YES;
    self.picker.pickDelegate = self;
    [self addSubview:self.picker];
}






@end





