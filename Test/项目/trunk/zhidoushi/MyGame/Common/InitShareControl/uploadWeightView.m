//
//  uploadWeightView.m
//  zhidoushi
//
//  Created by xinglei on 14/11/29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "uploadWeightView.h"

#import "WWTolls.h"
#import "JSONKit.h"
#import "ImageButton.h"
#import "PickerView+.h"
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
#import "WWRequestOperationEngine.h"

@interface uploadWeightView ()

@property(nonatomic,strong)NSString * imageUrl_1;
@property(nonatomic,strong)NSString * imageUrl_2;
@property(nonatomic,strong)ImageButton * imageButton_1;
@property(nonatomic,strong)ImageButton * imageButton_2;
@property(nonatomic,strong)PickerView_ * picker;
@end

@interface uploadWeightView ()<PickerViewDelegate,UITextFieldDelegate>

@end

@implementation uploadWeightView

+(uploadWeightView*)initView{

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"uploadWeightView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)cancelButon:(id)sender {

    if ([self.uploadViewDelegate respondsToSelector:@selector(cancelButtonSender)]) {
        [self.uploadViewDelegate cancelButtonSender];
    }
}

- (IBAction)confirmButton:(id)sender {

     NSLog(@"%f",self.phgoalweg.floatValue);

    NSString *weightTextFieldString = self.weightTextField.text;

    if (self.phgoalweg.floatValue==0) {
        [self uploadWeightData];

    }else{
        if ((weightTextFieldString.floatValue > self.phgoalweg.floatValue)) {

        [self.viewController showAlertMsg:@"当前上传体重大于目标体重无法上传" andFrame:CGRectMake(70,100,200,60)];
    }
    else{
        [self uploadWeightData];
        }
    }
}

-(void)uploadWeightData
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SAVEWEG];
    if (self.weightTextField.text.length!=0 && self.imageUrl_1.length!=0 && self.imageUrl_2.length!=0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [dic setObject:[NSString stringWithFormat:@"%@",self.parterid] forKey:@"parterid"];
        [dic setObject:@"0" forKey:@"phasepro"];
        [dic setObject:@"0" forKey:@"uploadtype"];
        NSString *weightString =[NSString stringWithFormat:@"%.1f",[self.weightTextField.text floatValue]];
        [NSUSER_Defaults setObject:weightString forKey:ZDS_LAST_WEIGHT];
        [dic setObject:weightString forKey:@"uploadweg"];
        [dic setObject:[NSString stringWithFormat:@"%@",self.imageUrl_1] forKey:@"imageurl1"];
        [dic setObject:[NSString stringWithFormat:@"%@",self.imageUrl_2] forKey:@"imageurl2"];
        NSLog(@"体重数—————%@",dic);
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dic requestOperationBlock:^(NSDictionary *dic) {
            
            __strong typeof(weakSelf)strongSelf = weakSelf;
            
            if (!dic[ERRCODE]) {
                
                [strongSelf.viewController showAlertMsg:@"上传成功啦，我们会有专人认真审核，请留意消息通知哦！" andFrame:CGRectMake(70,100,200,60)];

                NSLog(@"%@",dic);
                if ([[dic objectForKey:@"uplflag"]isEqualToString:@"0"]) {

                    if ([strongSelf.uploadViewDelegate respondsToSelector:@selector(confirmButtonSender)]) {
                        [strongSelf.uploadViewDelegate confirmButtonSender];
                    }
                    NSLog(@"%@",dic);
                    [strongSelf.viewController showAlertMsg:@"上传成功啦，我们会有专人认真审核，请留意消息通知哦！" andFrame:CGRectMake(70,100,200,60)];
                }
            }
        }];
    }
    else{
        [self.viewController showAlertMsg:@"上传资料不完整,需要2张照片和体重信息哦!" andFrame:CGRectMake(70,100,200,60)];
    }
}

-(void)configureView{

    CGRect rect = self.weightTextField.frame;
    rect.size.height = 41;
    self.weightTextField.frame = rect;
    self.weightTextField.delegate = self;
    [self.weightTextField setKeyboardType:UIKeyboardTypeNumberPad];

    self.line1View.height =0.5;
    self.line2View.height = 0.5;

    _imageButton_1 = [[ImageButton alloc]init];
    _imageButton_1.typeString = @"1000";
    _imageButton_1.imageTitle = @"weightImage_first";
    _imageButton_1.myPictureFrame = @"110,180";
    _imageButton_1.frame = CGRectMake( 175, 156, 90, 90);
    _imageButton_1.titleLabel.font = MyFont(12);
    _imageButton_1.backgroundColor = [UIColor grayColor];
    _imageButton_1.layer.cornerRadius = 2;
    [_imageButton_1 setBackgroundImage:[UIImage imageNamed:@"shangchuanzhaopian_180_180"] forState:UIControlStateNormal];
    [_imageButton_1 setBackgroundImage:[UIImage imageNamed:@"shangchuanzhaopian_180_180"] forState:UIControlStateHighlighted];
    //返回照片路径
    __weak typeof(self)weakSelf = self;
    [_imageButton_1 setImageBlock_1:^(NSString *hash){
        weakSelf.imageUrl_1 = hash;
    }];
    [self addSubview:_imageButton_1];

    ImageButton *imageButton_2 = [[ImageButton alloc]initWithFrame:CGRectMake( 175, 288, 90, 90)];
    imageButton_2.typeString = @"2000";
    imageButton_2.imageTitle = @"weightImage_second";
    imageButton_2.myPictureFrame = @"0,110,180,640";
    imageButton_2.titleLabel.font = MyFont(12);
    imageButton_2.backgroundColor = [UIColor grayColor];
    imageButton_2.layer.cornerRadius = 2;
    [imageButton_2 setBackgroundImage:[UIImage imageNamed:@"shangchuanzhaopian_180_180"] forState:UIControlStateNormal];
    [imageButton_2 setBackgroundImage:[UIImage imageNamed:@"shangchuanzhaopian_180_180"] forState:UIControlStateHighlighted];
    [imageButton_2 setImageBlock_2:^(NSString *hash){
        weakSelf.imageUrl_2 = hash;
    }];
    [self addSubview:imageButton_2];

    self.picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:wightType];
    self.picker.pickDelegate = self;
    [self addSubview:self.picker];

    UITapGestureRecognizer *weightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weightAction)];
    [self addGestureRecognizer:weightTap];

    [self.confirmButton addTarget:self action:@selector(confirmButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -  textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.weightTextField resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        if (iPhone4) {
            [self.picker setFrame:CGRectMake(0, self.frame.size.height-250, self.frame.size.width, self.picker.height)];
        }else{
            [self.picker setFrame:CGRectMake(0, self.frame.size.height-330, self.frame.size.width, self.picker.height)];
        }
    }];
    return NO;
}
#pragma mark -  pickViewDelegate 必须实现其中的两个方法†注意†
-(void)cancelBtn{
    [self hiddenPickerView];
}

-(void)selectBtn:(PickerView_*)pick
{
    [self hiddenPickerView];
}

-(void)pickerValue:(NSString*)str
{
    self.weightTextField.text = str;
}

-(void)hiddenPickerView{
    [UIView animateWithDuration:0.2f animations:^{
        
        [self.picker setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.picker.height)];
    }];
}


-(void)weightAction{
    NSLog(@"点击了空白");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
