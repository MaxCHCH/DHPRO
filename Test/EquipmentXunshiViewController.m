//
//  EquipmentXunshiViewController.m
//  LeBangProject
//  设备巡视
//  Created by Rillakkuma on 16/6/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "EquipmentXunshiViewController.h"
#import "XSTableViewCell.h"
#import "EquipRunParam.h"
#import "Dictionary.h"

@interface EquipmentXunshiViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *recoid;
    //标记
    NSMutableArray *arrayTag;
    NSString *stringExplain;//故障说明
    int flage;//正常与故障
    NSString *companyID,*companyname;//项目ID
    
    NSMutableArray *arrayID ;// 保存通用字典数据
    
    NSString *normalString,*unusualString,*otherString;
    
    NSString *PJM_EquipRunParam01,*PJM_EquipRunParam02,*PJM_EquipRunParam03;
}
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic)NSMutableArray *m_dataArr;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMy;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNum;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *enquiries;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property (weak, nonatomic) IBOutlet UITextView *textViewtxt;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseCompany;
@property (weak, nonatomic) IBOutlet UIButton *buttonNormal;
@property (weak, nonatomic) IBOutlet UIButton *buttonFix;

@property (strong, nonatomic)NSMutableArray *m_DictionaryArrray;
@property (strong, nonatomic)NSMutableArray *m_CompanyId;

@property (weak, nonatomic) IBOutlet UIView *viewForNormal;
@property (weak, nonatomic) IBOutlet UIView *viewForFix;
@property (assign, nonatomic) BOOL tixianType;//标志位，0表示正常，1表示故障


@end

@implementation EquipmentXunshiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title  = @"777";

 
	
//	[_addImageButton addTarget:self action:@selector(addImageMethod) forControlEvents:(UIControlEventTouchUpInside)];
//	UIButton *buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
//	[buttonName setFrame:FrameValue];
//	buttonName.backgroundColor = [UIColor clearColor];       //背景颜色
//	[buttonName setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];   //设置图片
//	[buttonName setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//	[self.view addSubview:buttonName];
	
	
    arrayID = [[NSMutableArray alloc]init];
    arrayTag = [[NSMutableArray array] init];
    _m_dataArr = [NSMutableArray array];
    _m_CompanyId =[NSMutableArray array];
    _m_DictionaryArrray = [[NSMutableArray array]init];
    
    [self getCompanyData];
    [self getDict];
    
    _textViewtxt.layer.borderColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000].CGColor;
    _textViewtxt.layer.borderWidth = 1;
    _textViewtxt.delegate = self;
    _buttonChooseCompany.layer.borderColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000].CGColor;
    _buttonChooseCompany.layer.borderWidth = 1;

    _tableViewMy.delegate = self;
    _tableViewMy.dataSource = self;
    _tableViewMy.tableFooterView = [UIView new];

    _buttonFix.layer.cornerRadius = _buttonNormal.layer.cornerRadius = 10;
    _buttonFix.layer.borderColor = _buttonNormal.layer.borderColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000].CGColor;
    _buttonFix.layer.borderWidth = _buttonNormal.layer.borderWidth = 1;
    _viewForNormal.hidden = YES;
    
    
    //  stringValue = 3206‖商业项目部‖CKS-PD-037‖所内屏‖‖0‖3
    if (_stringValue != nil) {
        NSArray *array = [_stringValue componentsSeparatedByString:@"‖"];
        _textFieldMy.text = array[1];
        _textFieldNum.text = array[2];
        _textFieldName.text = array[3];
        recoid = array[0];
        flage = 1;
        [self loadData];
    }
    else{
        flage = 0;
    }
    
}
- (void)addImageMethod{
	if ([UIImagePickerController isSourceTypeAvailable:
		 UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePicker.delegate = self;
		imagePicker.allowsEditing = YES; //允许用户编辑
		[self presentViewController:imagePicker animated:YES completion:nil];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	//image 就是修改后的照片
	//将图片添加到对应的视图上
	[_addImageButton setImage:image forState:UIControlStateNormal];
	
//	//结束操作
//	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//	//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//	
//	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	
//	[manager POST:API_URL_(@"EmpPictureUp") parameters:@{@"EmpID":@"2"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//		
//		NSData *imageData = UIImageJPEGRepresentation(image, 0.60);
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		formatter.dateFormat = @"yyyyMMddHHmmss";
//		NSString *str = [formatter stringFromDate:[NSDate date]];
//		NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//		// 上传图片，以文件流的格式
//		[formData appendPartWithFileData:imageData name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];
//		
//	} progress:^(NSProgress * _Nonnull uploadProgress) {
//		NSLog(@"进度-%.2f",uploadProgress.fractionCompleted);
//	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		NSString *string  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//		NSLog(@"上传成功%@",string);
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		
//	}];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getDict{
	NSString *urlll =[NSString stringWithFormat:@"%@&DTypeID=PJM004",API_BASE_URL(@"GetDictionaryByID")];
	
	urlll = [urlll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	[manager GET:urlll parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"GetDictionaryByID %@",responseObject);
//		arrayID = [GetDictionaryByID mj_objectArrayWithKeyValuesArray:responseObject[@"Dictionary"]];
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
	}];
}
- (void)getCompanyData{
    
    NSDictionary *params=@{
                           @"CompanyID":[USERDEFAULTS objectForKey:@"companyid"]
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:API_BASE_URL(@"GetEstateDetailFromCompanyID") parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//设备巡检 运行参数获取
- (void)loadData{
    
    NSString *URL =[NSString stringWithFormat:@"%@&RecordID=%@",API_BASE_URL(@"GetEquipRunByRecordID"),recoid];
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject--%@",responseObject);

        if ([responseObject[@"result"] isEqualToString:@"True"]) {
            [self reloadDataArr:responseObject[@"EquipRunParam"]];
            _viewForNormal.hidden = NO;
            
            [_tableViewMy reloadData];
 
        }else{
            NSLog(@"获取数据失败");
        }
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error--%@",error);
    }];

}

- (void)reloadDataArr:(NSArray *)arr{
    [_m_dataArr removeAllObjects];
    for (int i = 0; i<[arr count]; i++) {
        NSDictionary *dict = [arr objectAtIndex:i];
        EquipRunParam *model = [[EquipRunParam alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [_m_dataArr addObject:model];
    }
}


#pragma mark -提交
- (IBAction)commitDataMethod:(UIButton *)sender {
 
    //巡检记录提交
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    
    if (flage == 1) {
        
        [self commitNormalData:locationString];
    }
    else if (flage == 0)
    {
        [self commitFixData:locationString];
    }
    
    
}
- (void)commitNormalData:(NSString *)nowtime{
//    if (!recoid||recoid == nil) {
//        [MBProgressHUD showError:@"请扫描设备"];
//        return;
//    }
    [self commitDataFirst:nowtime];
   
}
- (void)commitDataFirst:(NSString *)timeStr{
    NSString *RunStatusTypeId = @"01";
    
    NSString *str = [NSString stringWithFormat:@"&RecordID=%@&EmpID=%@&LogDate=%@&RunStatusTypeId=%@&Memo=%@&CompanyID=%@",recoid,[USERDEFAULTS objectForKey:@"userid"],timeStr,RunStatusTypeId,@"",[USERDEFAULTS objectForKey:@"companyid"]];
    NSDictionary *params=@{
                           @"tableName":@"PJM_EquipRunLogHead",
                           @"url":str
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager POST:API_BASE_URL(@"CommCommit") parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		NSData *imageData = UIImageJPEGRepresentation(_addImageButton.currentImage, 0.60);
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.dateFormat = @"yyyyMMddHHmmss";
		NSString *str = [formatter stringFromDate:[NSDate date]];
		NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
		// 上传图片，以文件流的格式
		[formData appendPartWithFileData:imageData name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
				NSLog(@"进度-%.2f",uploadProgress.fractionCompleted);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"我的responseObject  %@",responseObject);
        if ([responseObject[@"result"] isEqual:@1]) {
            
            NSLog(@"pkid  %@",responseObject[@"pkid"]);
            NSLog(@"01 -- %@",PJM_EquipRunParam01);
            NSLog(@"02 -- %@",PJM_EquipRunParam02);
            NSLog(@"03 -- %@",PJM_EquipRunParam03);
            
            [self requestData:responseObject[@"pkid"] nowTime:timeStr Memo:normalString pjmID:PJM_EquipRunParam01];
            [self requestData:responseObject[@"pkid"] nowTime:timeStr Memo:unusualString pjmID:PJM_EquipRunParam02];
            [self requestData:responseObject[@"pkid"] nowTime:timeStr Memo:otherString pjmID:PJM_EquipRunParam03];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)requestData:(NSString *)pkid nowTime:(NSString *)nowtime Memo:(NSString *)memo pjmID:(NSString *)pjm{
    NSLog(@"pkid  %@",pkid);

    NSLog(@"-----%@",memo);
	
		NSString *stringUrl = @"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx?json=CommCommit";

	
	
    NSString *str = [NSString stringWithFormat:@"&PJM_EquipRunParam_ID=%@&RunStatusTypeId=%@&LogDate=%@&EmpID=%@&Memo=%@&PJM_EquipRunLogHead_ID=%@",pjm,@"01",nowtime,[USERDEFAULTS objectForKey:@"userid"],memo,pkid];
    NSDictionary *params=@{
                           @"tableName":@"PJM_EquipRunLogSub",
                           @"url":str
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:stringUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject  %@",responseObject);

        if ([responseObject[@"result"] isEqual:@1]) {
			
            NSLog(@"succes");
        }else{
            NSLog(@"fail");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)commitFixData:(NSString *)nowtime{
    if (!stringExplain||stringExplain.length == 0) {
        return;
    }
    if (!companyID) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"&RecordID=%@&发现人=%@&故障时间=%@&故障原因=%@&EstateID=%@",recoid,[USERDEFAULTS objectForKey:@"userid"],nowtime,stringExplain,companyID];
    NSDictionary *params=@{
                           @"tableName":@"PEM_FailureNote",
                           @"url":str
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:API_BASE_URL(@"CommCommit") parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"] isEqual:@1]) {
			
		}

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 按钮获取点击的indexPath
//正常
- (void)normalBtn:(UIButton *)button{
    NSLog(@"正常按钮 状态-%d",button.selected);

    UIView *v = [button superview];//获取父类view
    XSTableViewCell *cell = (XSTableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPathAll = [_tableViewMy indexPathForCell:cell];//获取cell对应的section
    
    if (button.selected == 1) {
        NSLog(@"cheng");
        cell.textFieldTxt.hidden = NO;
    }
    else{
        NSLog(@"bai");
        cell.textFieldTxt.hidden = YES;
    }
    
    NSLog(@"故障按钮 状态-%d",button.selected);

    if ([[arrayTag objectAtIndex:indexPathAll.row] integerValue] == 1) {
        [cell.chooseButton setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
        cell.chooseButton.selected = YES;
        [cell.chooseSubButton setBackgroundColor:[UIColor whiteColor]];cell.chooseSubButton.selected = NO;
        [arrayTag replaceObjectAtIndex:indexPathAll.row withObject:@"0"];
    }
    
}
//故障
- (void)fastBtn:(UIButton *)button{
    NSLog(@"故障按钮 状态-%d",button.selected);
    UIView *v = [button superview];//获取父类view
    XSTableViewCell *cell = (XSTableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPathAll = [_tableViewMy indexPathForCell:cell];//获取cell对应的section
    
    if (button.selected == 1) {
        NSLog(@"cheng");
        cell.textFieldTxt.hidden = NO;
    }
    else{
        NSLog(@"bai");
        cell.textFieldTxt.hidden = YES;
    }
    
    NSLog(@"故障按钮 状态-%d",button.selected);

    if ([[arrayTag objectAtIndex:indexPathAll.row] integerValue] == 0) {
        [cell.chooseButton setBackgroundColor:[UIColor whiteColor]];cell.chooseButton.selected=NO;
        [cell.chooseSubButton setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
        cell.chooseSubButton.selected = NO;
        [arrayTag replaceObjectAtIndex:indexPathAll.row  withObject:@"1"];
    }
    
}

- (IBAction)normalTouchMethod:(UIButton *)sender {
    _buttonNormal.backgroundColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000];
    _buttonFix.backgroundColor = [UIColor whiteColor];
    _viewForFix.hidden = YES;
    _viewForNormal.hidden = NO;
    flage = 1;//正常
}

//故障
- (IBAction)breakdownTouchMethod:(UIButton *)sender {
    _buttonFix.backgroundColor = [UIColor colorWithRed:0.075 green:0.702 blue:0.659 alpha:1.000];
    _buttonNormal.backgroundColor = [UIColor whiteColor];
    _viewForFix.hidden = NO;
    _viewForNormal.hidden = YES;
    flage = 0;//故障
    
}
- (IBAction)getCompanyInfo:(UIButton *)sender {

//    HYJNegotiateView *size =[HYJNegotiateView instanceSizeTextView];
//    size.delegate = self;
//    size.indexEight = @"公司项目";
//    size.arrayData = _m_CompanyId;
//    size.frame = CGRectMake(0, 0, DeviceWidth,DeviceHeight);
//    [size.viewBackGround addGestureRecognizer:size.tapGesture];
//    [size.tapGesture addTarget:self action:@selector(oneBtnsMethod)];
//    [[UIApplication sharedApplication].keyWindow addSubview:size];
//    self.negotiate = size;
 
}
- (void)HYJxxiangqingSizeviewGouwuChe:(NSString *)sender EstateID:(NSString *)Estateid RepaircategoryID:(NSString *)strID spID:(int)spid{
    companyID = strID;
    companyname = sender;
    
    [_buttonChooseCompany setTitle:companyname forState:(UIControlStateNormal)];
    [self oneBtnsMethod];
}
-(void)oneBtnsMethod{
//    [self.negotiate removeFromSuperview];
//    [self.negotiate.viewBackGround removeFromSuperview];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIView *v = [textField superview];//获取父类view
    XSTableViewCell *cell = (XSTableViewCell *)[v superview];//获取cell
    NSIndexPath *indexPathAll = [_tableViewMy indexPathForCell:cell];//获取cell对应的section
    NSLog(@"---%ld---%@",(long)indexPathAll.row,arrayTag[indexPathAll.row]);
    switch (indexPathAll.row) {
        case 0:
        {
            NSLog(@"第-%ld-行输入的文字是：%@",(long)indexPathAll.row,textField.text);
            normalString = textField.text;


        }
            break;
        case 1:
        {
            NSLog(@"第-%ld-行输入的文字是：%@",(long)indexPathAll.row,textField.text);
            unusualString = textField.text;



        }
            break;
        case 2:
        {
            NSLog(@"第-%ld-行输入的文字是：%@",(long)indexPathAll.row,textField.text);
            otherString = textField.text;



        }
            break;
            
        default:
            break;
    }

    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    stringExplain = textView.text;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _m_dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EquipRunParam *model = _m_dataArr[indexPath.row];

    XSTableViewCell *cell = [XSTableViewCell cellWithTableView:tableView];
    cell.nameLabeltxt.text = model.ParamName;
    
    if ([arrayTag count] <= indexPath.row) {
        [arrayTag addObject:@"0"];
    }
    
    if ([[arrayTag objectAtIndex:indexPath.row] integerValue] == 0) {
        [cell.chooseButton setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
        [cell.chooseSubButton setBackgroundColor:[UIColor whiteColor]];
        cell.chooseButton.selected=YES;  //分别给
        cell.chooseSubButton.selected = YES;
        
    }else{
        [cell.chooseButton setBackgroundColor:[UIColor whiteColor]];//normal
        [cell.chooseSubButton setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];//fix
        cell.chooseButton.selected=NO;  //分别给
        cell.chooseSubButton.selected = NO;
    }
    
    if (indexPath.row == 0) {
        PJM_EquipRunParam01 = model.PJM_EquipRunParam_ID;

    }
    if (indexPath.row == 1) {
        PJM_EquipRunParam02 = model.PJM_EquipRunParam_ID;

    }
    if (indexPath.row == 2) {
        PJM_EquipRunParam03 = model.PJM_EquipRunParam_ID;

    }
    [cell.chooseButton addTarget:self action:@selector(normalBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [cell.chooseSubButton addTarget:self action:@selector(fastBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
    cell.textFieldTxt.delegate = self;

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)historyMethod{
    
}
-(void)erWeiMaClickr
{
//    QRCodeVC*shopVC = [[QRCodeVC alloc]init];
//	shopVC.stringPage = @"设备巡视";
//	shopVC.myReturnTextBlock = ^(NSString *showText){
//		NSLog(@"showText  %@",showText);
//		NSArray *array = [showText componentsSeparatedByString:@"‖"];
//		NSLog(@"array %@",array);
//		//				_numbeLabel.text =array[1];
//		//				_stringSaoCode=array[1];
//		
//		_textFieldMy.text = array[0];
//		_textFieldNum.text = array[1];
//		_textFieldName.text = array[2];
//		_enquiries.text = array[3];
//		
//	};
	
//    [self.navigationController pushViewController:shopVC animated:YES];
	
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
