//
//  UIView+LoadFromNib.m
//  Ituji
//
//  Created by 曹 君平 on 8/16/12.
//
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+ (id)loadFromNib
{
    id view = nil;
    NSString *xibName = NSStringFromClass([self class]);
    UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:xibName bundle:nil];
    if(temporaryController)
    {
        view = temporaryController.view;
    }   
    return view;
}

+ (id)loadNib {
    id view = nil;
    NSString *xibName = NSStringFromClass([self class]);
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:xibName owner:nil options:nil];
    view = objects[0];
    return view;
}   

@end
