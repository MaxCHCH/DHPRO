//
//  DetailsDrawTableViewCell.m
//  LeBangProject
//
//  Created by Rillakkuma on 2016/10/10.
//  Copyright © 2016年 北京中科华博有限科技公司. All rights reserved.
//

#import "DetailsDrawTableViewCell.h"

@implementation DetailsDrawTableViewCell {
    NSMutableArray * _iDArray;
}
@synthesize textName,textViewMy;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

	}
    return self;
}

- (void)setUpUI:(NSMutableArray *)arr{
    _iDArray = [NSMutableArray array];
    for (int i = 0; i<_arr.count; i++) {
        int margin = ((DeviceWidth- 50)- 60* _arr.count)/(_arr.count-1);
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageBtn setFrame:CGRectMake(25+i* margin + i*60 ,8.0 ,60.0 ,30.0)];//
        imageBtn.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
        [imageBtn setImage:[UIImage imageNamed:@"uncheck_icon"] forState:UIControlStateNormal];   //设置图片
        [imageBtn setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateSelected];   //设置图片
        [imageBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

        _model = _arr[i];
        imageBtn.tag = 100+i;
        NSLog(@"--我的ID-%d",_model.id);
        NSString * string = [NSString stringWithFormat:@"%d",_model.id];
        [_iDArray addObject:string];

        (imageBtn.tag == 100)?imageBtn.selected = YES:NO;

        [imageBtn addTarget:self action:@selector(imageMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [imageBtn setTitle:_model.name forState:(UIControlStateNormal)];
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:imageBtn];
    }
	
    textViewMy = [[UITextView alloc] initWithFrame:CGRectMake(25.0 , 45,  [[UIScreen mainScreen] bounds].size.width-50.0 ,90.0)];
    textViewMy.layer.borderColor = [UIColor colorWithRed:0.126 green:0.809 blue:0.786 alpha:1.000].CGColor;
    textViewMy.layer.borderWidth = 0.3;
    textViewMy.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
    [self addSubview:textViewMy];
    

    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(25, 160, 33, 17)];
    labelName.backgroundColor = [UIColor clearColor];       //背景颜色
    labelName.textColor = [UIColor blackColor];             //字体颜色 默认为RGB 0,0,0
    labelName.numberOfLines = 0;                            //行数 0为无限 默认为1
    labelName.textAlignment = NSTextAlignmentCenter;        //对齐方式 默认为左对齐
    labelName.font = [UIFont systemFontOfSize:14];          //设置字体及字体大小
    labelName.text = @"评论";                            //设置显示内容
    [self addSubview:labelName];
    
    textName = [[UITextField alloc] initWithFrame:CGRectMake(61, 160, (DeviceWidth-25)/2, 17)];
    textName.placeholder = @"请输入评分值";
    textName.delegate = self;
    textName.keyboardType = UIKeyboardTypeNumberPad;
    textName.borderStyle = UITextBorderStyleRoundedRect;
    textName.backgroundColor = [UIColor clearColor];       //背景颜色
    [self addSubview:textName];

}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"输入内容%@",textView.text);
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"输入内容%@",textView.text);

	NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    NSLog(@"textView input inde %ld",(long)indexPath.section);
    if (_a == 11) {
        NSLog(@"11 inde %d--%@",_a,textView.text);
    }
    if (_a == 12) {
        NSLog(@"12 inde %d--%@",_a,textView.text);

    }
//        DetailDrawTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    //
    //
    //    for (JSTextView *view in cell.contentView.subviews) {
    //
    //        if ([view isKindOfClass:[JSTextView class]]) {
    //            NSLog(@"%@--aydgfa-----",view.text);
    //        }
    //        
    //    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_a == 11) {
        NSLog(@"11 inde %d--%@",_a,textField.text);
        
    }
    if (_a == 12) {
        NSLog(@"12 inde %d--%@",_a,textField.text);
        
    }

}

- (void)imageMethod:(UIButton *)sender{
    if ( sender.isSelected) {
        sender.selected = NO;
    }else {
        sender.selected = YES;
        for (int i=0; i < _arr.count; i ++) {
            if (sender.tag != 100 + i) {
                UIButton * button = [self viewWithTag:100 + i];
                button.selected = NO;
            }else {
                
                if (_a == 11) {
                    NSLog(@"1inde %d--%@",_a,_iDArray[i]);
                }
                if (_a == 12) {
                    NSLog(@"2inde %d--%@",_a,_iDArray[i]);
                }
                
                _returnidBlock(_iDArray[i]);

                NSLog(@"点击了第几个ID-----%@",_iDArray[i]);
            }
        }
    }
}
- (void)selectedOrNormal:(UIButton *)sender{
    (sender.selected == YES)?sender.selected = YES:NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
