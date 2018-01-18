//
//  WWViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ContactViewController.h"

#import "WWTolls.h"
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
//..gateGory..//
#import "NSString+Utilities.h"
#import "NSString+NARSafeString.h"
#import "Define.h"

@interface ContactViewController ()
{
    NSUInteger _selectedCount;
//    NSMutableArray *_listContentArray;
    NSMutableArray *searchArray;
    NSMutableArray *updateArray;
}

@end

static     NSMutableDictionary *endPhoneString;

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    endPhoneString = [NSMutableDictionary dictionary];
    _selectedCount = 0;
    searchArray = [[NSMutableArray alloc] init];
    updateArray = [[NSMutableArray alloc] init];
    self.getManArray = [[NSMutableArray alloc] initWithCapacity:10];

}

#pragma mark - 点击导航条按钮 Button Action -

- (void)pressedBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(ABAddressBookRef)createAddressBook{

    ABAddressBookRef addressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
        }
    else
    {
//        addressBook = ABAddressBookCreate();
    }
    return addressBook;
}

#pragma mark 获取联系人信息
-(void)readContacts
{

//    endPhoneString = @"";
    endPhoneString = [NSMutableDictionary dictionary];
//    _listContentArray = [[NSMutableArray alloc] init];

    ABAddressBookRef addressBooks = [self createAddressBook];

    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
//    NSString* allPhones = @"";
//    NSMutableArray* contactArray = [NSMutableArray array];

    for (NSInteger i = 0; i < nPeople; i++)
    {
        AddressBook *addressBook = [[AddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        }
        else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);
        addressBook.rowSelected = NO;
        
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSLog(@"name  %@",addressBook.name);

        if (ABMultiValueGetCount(phones) > 0) {

            addressBook.phoneNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@"(" withString:@""];
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@")" withString:@""];
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
            addressBook.phoneNum = [addressBook.phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
//           NSLog(@"本地通讯录====name  %@   phone   %@",addressBook.name, addressBook.phoneNum);

            if ([self isValidateMobile:addressBook.phoneNum]) {

//            if (endPhoneString == nil) {
//                
//                endPhoneString = addressBook.phoneNum;
//
//            }else{

                if (addressBook.phoneNum.length!=0) {
                    if (addressBook.name.length<1) {
                        addressBook.name = addressBook.phoneNum;
                    }
                    [endPhoneString setValue:@{@"name":addressBook.name} forKey:addressBook.phoneNum];
                    }
                }
//                if (addressBook.phoneNum.length!=0) {
////                    [_listContentArray addObject:addressBook.phoneNum];
//                }
//            }
        }
        NSLog(@"本地通讯录====  %@ ",endPhoneString);
    }

}

#pragma mark -  上传通讯录
-(void)uploadPhoneNumber
{
    //    上传通讯录
    [self upDataUserPhoneBook:endPhoneString];
}

-(void)writePhoneNumber
{
//    NSMutableDictionary * phoneDictionary = [[NSMutableDictionary alloc]init];
//    [phoneDictionary setObject:endPhoneString forKey:@"phoneValue"];
//    [WWTolls setLocalPlistInfo:phoneDictionary Key:DOCUMENT_USERPHONE_PLIST];
    [NSUSER_Defaults setValue:endPhoneString forKey:[NSUSER_Defaults objectForKey:ZDS_USERID]];
    [NSUSER_Defaults synchronize];
}

#pragma mark -检测通讯录
-(void)comparisonPhoneBook
{
    
    NSDictionary *phoneString = [NSUSER_Defaults objectForKey:[NSUSER_Defaults objectForKey:ZDS_USERID]];
    if (![phoneString isKindOfClass:[NSDictionary class]]) {
        [NSUSER_Defaults setObject:nil forKey:[NSUSER_Defaults objectForKey:ZDS_USERID]];
        phoneString = nil;
    }
    NSMutableDictionary * resultString = [NSMutableDictionary dictionary];
    for (NSString *s in endPhoneString.allKeys) {
        if(phoneString[s]==nil) [resultString setObject:endPhoneString[s] forKey:s];
    }
    
    
//    NSLog(@"phoneString,endPhoneString*******%@,%@",phoneString,endPhoneString);
//    NSRange range = [phoneString rangeOfString:endPhoneString options:NSCaseInsensitiveSearch];
//    
//    if (phoneString.length!=0&&range.length!=0) {
//        resultString = [phoneString stringByReplacingCharactersInRange:range withString:@""];
//    }
//    NSLog(@"resultString*******%@",resultString);
    if (resultString.count!=0) {
         NSLog(@"有新的用户噢噢噢噢噢噢噢噢哦哦哦");
//        resultString = [resultString substringToIndex:resultString.length-1];
        [self upDataUserPhoneBook:resultString];
//        NSMutableDictionary * phoneDictionary = [[NSMutableDictionary alloc]init];
//        [phoneDictionary setObject:endPhoneString forKey:@"phoneValue"];
//        [WWTolls setLocalPlistInfo:phoneDictionary Key:DOCUMENT_USERPHONE_PLIST];
    }
}

//        ABPropertyID multiProperties[] = {
//            kABPersonPhoneProperty,
//            kABPersonEmailProperty
//        };
//        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
//        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
//            ABPropertyID property = multiProperties[j];
//            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
//            NSInteger valuesCount = 0;
//            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
//            
//            if (valuesCount == 0) {
//                if (valuesRef) {
//                    CFRelease(valuesRef);
//                }
//                continue;
//            }
//            
//            for (NSInteger k = 0; k < valuesCount; k++) {
//                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
//                switch (j) {
//                    case 0: {// Phone number
//                        addressBook.tel = [(NSString*)value telephoneWithReformat];
//                        break;
//                    }
//                    case 1: {// Email
//                        addressBook.email = (NSString*)value;
//                        break;
//                    }
//                }
//                if (value) {
//                    CFRelease(value);
//                }
//            }
//            if (valuesRef) {
//                CFRelease(valuesRef);
//            }
//        }
//        
//        if ([self isValidateMobile:addressBook.phoneNum]) {
//            [contactArray addObject:addressBook];
//        }
//        [addressBook release];
//        
//        if (abName) CFRelease(abName);
//        if (abLastName) CFRelease(abLastName);
//        if (abFullName) CFRelease(abFullName);
//    }
//    if (allPeople) {
//        CFRelease(allPeople);
//    }
//    if (addressBooks) {
//        CFRelease(addressBooks);
//    }
//    
//    if (allPhones.length > 0) {
//        allPhones = [allPhones substringToIndex:allPhones.length - 1];
//    }
//    
//    [_listContentArray removeAllObjects];
//    [_listContentArray addObjectsFromArray:contactArray];
//    NSLog(@"--------------------通讯录-----%@",_listContentArray);
//    for (int i =0; i<[_listContentArray count]; i++) {
//        AddressBook *address = [_listContentArray objectAtIndex:i];
//        
//        for (int j=0; j<[_getManArray count]; j++) {
//            self.modelID1 = [NSString stringWithFormat:@"%@",address.phoneNum];
//            NSString *str2 = [[_getManArray objectAtIndex:j] objectForKey:@"invitee"];
//            self.modelID2 = [NSString stringWithFormat:@"%@",str2];
//            NSLog(@"通讯录被邀请人=======%@===%@",_modelID1,_modelID2);
//            if ([self.modelID1 isEqualToString:self.modelID2]) {
//                NSLog(@"-------------------已经邀请过了%@",self.modelID2);
//                address.isAttented = 1;//表明已邀请
//                
//                NSString *str3 = [[_getManArray objectAtIndex:j] objectForKey:@"sign"];
//                NSLog(@">>>>>>>>str3==%@",str3);
//                if ([str3 intValue] == 1) {
//                    
//                    NSLog(@"说明已经安装股客");
//                    address.isGuKe = 1;
//                    
//                }else{
//                    
//                }
//            }
//        }
//
//        if (address.isGuKe == 1) {
//            //表明已经安装了股客，将其删除
//            NSLog(@"说明已经安装股客,将其删除");
//            [_listContentArray removeObject:address];
//        }
//
//    }

    //把联系人保存到数据库中
//    [NSThread detachNewThreadSelector:@selector(saveTelContact:) toTarget:self withObject:contactArray];
//    [[FMDatabaseManager sharedFMDatabase] saveContact:contactArray];
    
//    NSLog(@"phones %@",allPhones);

    /*
    
    UserInfo* user = [[ModelManager sharedModelManager] getUserInfo];
    
    NSURL *url = [NSURL URLWithString:iSport_Http_Base_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSString *_path = @"checkUserUserMobile.html";
    NSDictionary *paras = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:user.userID], @"userID", allPhones,@"userMobile", nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:_path parameters:paras];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.responseData) {
            id  json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"json  %@",json);
            NSArray* array = [json objectForKey:@"mobileList"];

            [updateArray removeAllObjects];
            [updateArray addObjectsFromArray:array];
            
//            [[FMDatabaseManager sharedFMDatabase] updateContact:array];
//            [NSThread detachNewThreadSelector:@selector(updateTelContact:) toTarget:self withObject:array];
//            NSLog(@"array %@",array);
            //1，代表是好友2，没有注册，3，已经注册
            for (int i = 0; i < array.count; i++) {
                NSDictionary* dict = [array objectAtIndex:i];
                NSInteger isCheck = [[dict objectForKey:@"isCheck"] integerValue];
                NSInteger userID = [[dict objectForKey:@"userID"] integerValue];
                if (_listContentArray.count > i) {
                    AddressBook* person = [_listContentArray objectAtIndex:i];
                    person.isCheck = isCheck;
                    person.userID = userID;
                }
            }
            [_listContentArray sortUsingFunction:compare context:NULL];
            
            [self.tableView reloadData];
            
            [NSThread detachNewThreadSelector:@selector(saveTelContact:) toTarget:self withObject:_listContentArray];
        }
    }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [_listContentArray removeAllObjects];
          NSArray* array = [[FMDatabaseManager sharedFMDatabase] getContact];
          [_listContentArray addObjectsFromArray:array];
          [self.tableView reloadData];
          NSLog(@"error  ");
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init]; 
    [queue addOperation:operation];
    
//    NSLog(@"get  =====%@",[[FMDatabaseManager sharedFMDatabase] getContact]);
}

NSComparisonResult compare(AddressBook* firstBook, AddressBook* secondBook, void *context)
{
    NSString *first = [NSString stringWithFormat:@"%d", firstBook.isCheck];
    NSString *second = [NSString stringWithFormat:@"%d",secondBook.isCheck];
    return [second compare:first];
    
}

#pragma mark -  手机通讯录数据库库的操作

-(void)saveTelContact:(NSMutableArray*)array
{
    @autoreleasepool {
        [[FMDatabaseManager sharedFMDatabase] saveContact:array];
    }
}


-(void)updateTelContact:(NSMutableArray*)array
{
    @autoreleasepool {
        [[FMDatabaseManager sharedFMDatabase] updateContact:array];
        NSLog(@"get  %@",[[FMDatabaseManager sharedFMDatabase] getContact]);
    }
     */

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];

    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (void)dealloc
{
//	[searchArray release];
//    [_listContentArray release];
//    self.searchBar = nil;
//	[super dealloc];
}

-(void)upDataUserPhoneBook:(NSMutableDictionary*)pbookstring
{
    if (![NSUSER_Defaults objectForKey:ZDS_USERID]) {
        return;
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pbookstring options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *phone = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    phone = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [dictionary setObject:phone forKey:@"pbookstring"];
    NSLog(@"上传通讯录dictionary——————————————%@",dictionary);
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CPBOOKDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            NSLog(@"%@,%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"insertStatus"]], [NSString stringWithFormat:@"%@",[dic objectForKey:@"newFriendsCount"]]);
            NSLog(@"通讯录返回数据*********%@", dic);
            [NSUSER_Defaults setValue:endPhoneString forKey:[NSUSER_Defaults objectForKey:ZDS_USERID]];
            [NSUSER_Defaults synchronize];
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
