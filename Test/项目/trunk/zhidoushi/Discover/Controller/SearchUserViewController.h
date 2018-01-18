//
//  SearchUserViewController.h
//  zhidoushi
//
//  Created by nick on 15/4/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchUserViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property(nonatomic,strong)UITableView * table;
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)UISearchDisplayController * searchDispalyController;
@end
