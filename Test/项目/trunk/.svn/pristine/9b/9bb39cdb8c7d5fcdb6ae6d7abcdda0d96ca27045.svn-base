//
//  WWViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <malloc/malloc.h>
#import "AddressBook.h"
#import <MessageUI/MessageUI.h>
#import "BaseViewController.h"

@protocol ContactsDelegate <NSObject>
- (void)contactsDidFinishPickingDataWithInfo:(NSArray*)array;

@end

@interface ContactViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) id<ContactsDelegate> delegate;
//@property (nonatomic, retain) UITableView *tableView;
//@property (nonatomic, retain) UISearchBar *searchBar;
//@property (nonatomic, retain) UISearchDisplayController *searchDisplay;

//@property (nonatomic, copy) NSString *savedSearchTerm;
//@property (nonatomic) NSInteger savedScopeButtonIndex;
//@property (nonatomic) BOOL searchWasActive;
//@property (nonatomic) BOOL startSearch;//是否开始搜索
//@property (nonatomic,assign) NSInteger searchSection;

@property (nonatomic,copy)NSString *modelID1;
@property (nonatomic,copy)NSString *modelID2;
@property (nonatomic,retain) NSMutableArray *getManArray;

//请求通讯录
-(void)readContacts;
//上传通讯录
-(void)uploadPhoneNumber;
//检测通讯录
-(void)comparisonPhoneBook;
//写入通讯录
-(void)writePhoneNumber;

@end
