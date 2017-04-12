//
//  DetailsDrawTableViewCell.h
//  LeBangProject
//
//  Created by Rillakkuma on 2016/10/10.
//  Copyright © 2016年 北京中科华博有限科技公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDictionaryByID.h"
typedef void (^ReturnIDBlock)(NSString *id);

@interface DetailsDrawTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)GetDictionaryByID *model;
@property (nonatomic, copy) ReturnIDBlock returnidBlock;
@property (nonatomic,strong)UITextField *textName;
@property (nonatomic,strong)UITextView *textViewMy;
@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,assign) int a;

- (void)setUpUI:(NSMutableArray *)arr;
@end
