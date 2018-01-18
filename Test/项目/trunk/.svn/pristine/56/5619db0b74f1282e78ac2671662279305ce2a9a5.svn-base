//
//  UserSearchAlertView.m
//  zhidoushi
//
//  Created by licy on 15/8/7.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UserSearchAlertView.h"


@interface UserSearchAlertView () <UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSString *searchText;

@end

@implementation UserSearchAlertView

#pragma mark Init

- (void)setDelegate:(id <UserSearchAlertViewDelegate>)delegate andSearchText:(NSString *)searchText {
    self.delegate = delegate;
    self.searchText = searchText;
    [self createView];
}

- (void)createView {
    
    [self ssl_addGeneralTap];
    
    UIView *topGgView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, self.width, 50)];
    [self addSubview:topGgView];
    topGgView.backgroundColor = ZDS_BACK_COLOR;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 30)];
    //    [_searchBar setTintColor:[WWTolls colorWithHexString:@"dedede"]];//修改光标颜色
    
    searchBar.placeholder = @"输入团员昵称";
    
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.layer.cornerRadius = 2.5;
    searchBar.clipsToBounds = YES;
    UIView *searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    //    searchTextField.backgroundColor = RGBCOLOR(239, 239, 239);
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchBar.barStyle = UIBarStyleDefault;
    
    searchBar.delegate = self;
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    
    // Change search bar text color
    searchField.textColor = [WWTolls colorWithHexString:@"#535353"];
    searchBar.text = self.searchText;
    self.searchBar = searchBar;
    
//    for(id cc in [searchBar.subviews[0] subviews]){
//        if([cc isKindOfClass:[UIButton class]]){
//            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:@"搜索"  forState:UIControlStateNormal];
//        }  
//    }
    
    for (UIView *subview in [searchBar.subviews[0] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    [topGgView addSubview:searchBar];
    
    [searchBar becomeFirstResponder];
}   

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchUserBack];
    NSLog(@"搜索");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([self.delegate respondsToSelector:@selector(userSearchAlertView:textDidChange:)]) {
        [self.delegate userSearchAlertView:self textDidChange:searchText];
    }
}

#pragma mark Event Responses

#pragma mark Private Methods
- (void)searchUserBack {
    
    if ([self.delegate respondsToSelector:@selector(userSearchAlertView:searchWithText:)]) {
        [self.delegate userSearchAlertView:self searchWithText:self.searchBar.text];
    }   
    [self ssl_hidden];
}

@end
