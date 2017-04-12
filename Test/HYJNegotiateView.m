//
//  HYJNegotiateView.m
//  HeYiJia
//
//  Created by Jabraknight on 15/3/31.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "HYJNegotiateView.h"

@implementation HYJNegotiateView
+(HYJNegotiateView *)instanceSizeTextView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HYJNegotiateView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
-(void)awakeFromNib{
    _tableViewMy.delegate = self;
    _tableViewMy.dataSource = self;
    _arrayData = @[@"完成",@"未完成待料",@"未完成待修",@"未完成完工"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    cell.textLabel.text = _arrayData[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(HYJxxiangqingSizevviewGouwuChe:indexPathS:)]) {
        [self.delegate HYJxxiangqingSizevviewGouwuChe:cell.textLabel.text indexPathS:indexPath];
    }

}
//- (void)drawRect:(CGRect)rect {
//    
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    
//    CGContextFillRect(context, rect);
//    
//    //上分割线，
//    
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    
//    CGContextStrokeRect(context, CGRectMake(0, -0.1, rect.size.width, 0.1));
//    
//    //下分割线
//    
//    CGContextSetStrokeColorWithColor(context,[UIColor grayColor].CGColor);
//    
//    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-0.1, rect.size.width,0.1));
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
