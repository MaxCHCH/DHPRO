

//
//  HeadViewViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/8.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#import "pinyin.h"
#import "ChineseString.h"
#import "HeadViewViewController.h"
#define kTableCell @"tablecell"
@interface HeadViewViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>
@property(nonatomic,retain)NSArray *items;
@property(nonatomic,retain)UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property(nonatomic,retain)NSMutableArray *searchResults;

@property(nonatomic,retain)NSMutableArray *listGroupname;

@end

@implementation HeadViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
//懒加载
- (NSArray *)items{
    if (!_items) {
        self.items = [NSArray array];
    }
    return _items;
}
//懒加载
- (NSMutableArray *)searchResults{
    if (!_searchResults) {
        self.searchResults = [NSMutableArray arrayWithCapacity:0];
    }
    return _searchResults;
}
//懒加载
- (NSMutableArray *)listGroupname{
    if (!_listGroupname) {
        self.listGroupname = [NSMutableArray arrayWithCapacity:0];
    }
    return _listGroupname;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    //导航栏
    [self p_navigationController];
    
    //调用初始化searchController
    [self setSearchControllerView];
    
    //注册
    [self.tableViewMy registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCell];
    // Do any additional setup after loading the view from its nib.
}

- (void)setSearchControllerView{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = false;
    //搜索栏表头视图
    self.tableViewMy.tableHeaderView = self.searchController.searchBar;
    self.tableViewMy.sectionIndexColor = [UIColor redColor];
    [self.searchController.searchBar sizeToFit];
    //背景颜色
    self.searchController.searchBar.backgroundColor = [UIColor orangeColor];
    self.searchController.searchResultsUpdater = self;
    
    
}
- (void)p_navigationController{
    self.title = @"小韩哥-英雄列表";
    self.items = @[@"国服第一臭豆腐 No.1 Stinky Tofu CN.",
                            @"比尔吉沃特(Bill Ji walter)",
                            @"瓦洛兰 Valoran",
                            @"祖安 Zaun",
                            @"德玛西亚 Demacia",
                            @"诺克萨斯 Noxus",
                            @"艾欧尼亚 Ionia",
                            @"皮尔特沃夫 Piltover",
                            @"弗雷尔卓德 Freijord",
                            @"班德尔城 Bandle City",
                            @"无畏先锋",
                            @"战争学院 The Institute of War",
                            @"巨神峰",
                            @"雷瑟守备(JustThunder)",
                            @"裁决之地(JustRule)",
                            @"黑色玫瑰(Black Rose)",
                            @"暗影岛（Shadow island）",
                            @"钢铁烈阳（Steel fierce）",
                            @"恕瑞玛沙漠 Shurima Desert",
                            @"均衡教派（Balanced sect）",
                            @"水晶之痕（Crystal Scar）",
                            @"影流（Shadow Flow ）",
                            @"守望之海（The Watchtower of sea）",
                            @"皮尔特沃夫",
                            @"征服之海",
                            @"扭曲丛林 Twisted Treeline",
                            @"教育网专区",
                            @"试炼之地 Proving Grounds",
                            @"卡拉曼达 Kalamanda",
                            @"蓝焰岛 Blue Flame Island",
                            @"哀嚎沼泽 Howling Marsh",
                            @"艾卡西亚 Icathia",
                            @"铁脊山脉 Ironspike Mountains",
                            @"库莽古丛林 Kumungu",
                            @"洛克法 Lokfar",
                            @"摩根小道 Morgon Pass",
                            @"塔尔贡山脉 Mountain Targon",
                            @"瘟疫丛林 Plague Jungles",
                            @"盘蛇河 Serpentine River",
                            @"厄尔提斯坦 Urtistan",
                            @"巫毒之地 Voodoo Lands",
                            @"咆哮深渊 Howling Abyss",
                            @"熔岩洞窟 Magma Chambers",
                            @"召唤师峡谷 Summoner's Rift",
                            @"九尾妖狐： 阿狸（Ahri）",
                            @"暗影之拳：阿卡丽（Akali）",
                            @"牛头酋长：阿利斯塔（Alistar）",
                            @"殇之木乃伊：阿木木（Amumu）",
                            @"冰晶凤凰：艾尼维亚（Anivia）",
                            @"黑暗之女：安妮（Annie）",
                            @"寒冰射手：艾希（Ashe）",
                            @"蒸汽机器人：布里茨（Blitzcrank)",
                            @"复仇焰魂：布兰德（Brand）",
                            @"皮城女警：凯特琳（Caitlyn）",
                            @"魔蛇之拥：卡西奥佩娅（Cassiopeia）",
                            @"虚空恐惧：科’加斯（ChoGath）",
                            @"英勇投弹手：库奇（Corki）",
                            @"诺克萨斯之手：德莱厄斯（Darius）",
                            @"皎月女神：黛安娜：（Diana）",
                            @"祖安狂人：蒙多医生（DrMundo）",
                            @"荣耀行刑官：德莱文（Delevin）",
                            @"蜘蛛女皇：伊莉斯（Elise）",
                            @"寡妇制造者：伊芙琳（Evelynn）",
                            @"探险家：伊泽瑞尔（Ezreal）",
                            @"末日使者：费德提克（Fiddlesticks）",
                            @"无双剑姬：剑姬（Fiora）",
                            @"潮汐海灵：菲兹（Fizz）",
                            @"哨兵之殇：加里奥（Galio）",
                            @"海洋之灾：普朗克（Gangplank）",
                            @"德玛西亚之力：盖伦（Garen）",
                            @"酒桶：古拉加斯（Gragas）",
                            @"法外狂徒：格雷福斯（Graves）",
                            @"战争之影：赫卡里姆 （Hecarim）",
                            @"大发明家：黑默丁格（Heimerdinger）",
                            @"刀锋意志：伊瑞利亚（Irelia）",
                            @"风暴之怒：迦娜（Janna）",
                            @"德玛西亚皇子：嘉文四世（JarvanⅣ）",
                            @"武器大师：贾克斯（Jax）",
                            @"未来守护者：杰斯（Jayce）",
                            @"天启者：卡尔玛（Karma）",
                            @"死亡颂唱者：卡尔萨斯（Karthus）",
                            @"虚空行者：卡萨丁（Kassadin）",
                            @"不详之刃：卡特琳娜（Katarina）",
                            @"审判天使：凯尔（Kayle）",
                            @"狂暴之心：凯南（Kennen）",
                            @"虚空掠夺者：卡’兹克（Khazix）",
                            @"深渊巨口：克格’莫（Kog Maw）",
                            @"诡术妖姬：乐芙兰（LeBlanc）",
                            @"盲僧：李青（Lee sin）",
                            @"曙光女神：蕾欧娜（Leona）",
                            @"仙灵女巫：璐璐（lulu）",
                            @"光辉女郎：拉克丝（Lux）",
                            @"熔岩巨兽：墨菲特（Malphite）",
                            @"虚空先知：玛尔扎哈（Malzahar）",
                            @"扭曲树精：茂凯（Maokai）",
                            @"无极剑圣：易（Yi）",
                            @"赏金猎人：厄运小姐（MissFortune）",
                            @"齐天大圣：孙悟空（Monkey king）",
                            @"金属大师：莫德凯撒（Mordekaiser）",
                            @"堕天使：莫甘娜（Morgana）",
                            @"唤潮鲛姬：娜美（Nami）",
                            @"沙漠死神：内瑟斯（Nasus）",
                            @"深海泰坦：诺提勒斯（Nautilus）",
                            @"狂野女猎手：奈德丽（Nidalee）",
                            @"永恒梦魇：魔腾（Nocturne）",
                            @"雪人骑士：努努（Nunu）",
                            @"狂战士：奥拉夫（Olaf）",
                            @"发条魔灵：奥莉安娜（Orianna）",
                            @"战争之王：潘森（Pantheon）",
                            @"钢铁大使：波比（Poopy）",
                            @"披甲龙龟：拉莫斯（Rammus）",
                            @"荒漠屠夫：雷克顿（Renekton）",
                            @"傲之追猎者：雷恩加尔（Rengar）",
                            @"放逐之刃：瑞文（Rivan）",
                            @"机械公敌：兰博（Rumble）",
                            @"流浪法师：瑞兹（Ryze）",
                            @"凛冬之怒：瑟庄妮：（Sejuani）",
                            @"恶魔小丑：萨科（Shaco）",
                            @"暮光之眼：慎（Shen）",
                            @"龙血武姬：希瓦娜（Shyvana）",
                            @"炼金术士：辛吉德（Singed）",
                            @"亡灵勇士：赛恩（Sion）",
                            @"战争女神：希维尔（Sivir）",
                            @"水晶先锋：斯卡纳（Skarner）",
                            @"琴瑟仙女：娑娜（Sona）",
                            @"众星之子：索拉卡（Soraka）",
                            @"策士统领：斯维因（Swain）",
                            @"暗黑元首：辛德拉（Syndra）",
                            @"刀锋之影：泰隆（Talon）",
                            @"宝石骑士：塔里克（Taric）",
                            @"迅捷斥候：提莫（Teemo）",
                            @"魂锁典狱长：锤石（Thresh）",
                            @"麦林炮手：崔丝塔娜（Tristana）",
                            @"诅咒巨魔：特兰德尔（Trundle）",
                            @"蛮族之王：泰达米尔（Tryndamere）",
                            @"卡牌大师：崔斯特（Twisted Fate）",
                            @"瘟疫之源：图奇（Twitch）",
                            @"野兽之灵：乌迪尔（Udyr）",
                            @"首领之傲：厄加特（Urgot）",
                            @"惩戒之箭：韦鲁斯（Varus）",
                            @"暗夜猎手：薇恩（Vayne）",
                            @"邪恶小法师：维伽（Veigar）",
                            @"皮城执法官：蔚（Vi）",
                            @"机械先驱：维克托（Viktor）",
                            @"猩红收割者：弗拉基米尔（Vladimir）",
                            @"雷霆咆哮：沃利贝尔（Volibear）",
                            @"嗜血猎手：沃里克（Warwick）",
                            @"远古巫灵：泽拉斯（Xerath）",
                            @"德邦总管：赵信（XinZhao）",
                            @"掘墓者：约里克(Yorick)",
                            @"影流之主：劫（Zed）",
                            @"爆破鬼才：吉格斯（Ziggs）",
                            @"时光守护者：基兰（Zilean）",
                            @"荆棘之兴：婕拉（Zyra"];
    
//    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];//这个是建立索引的核心
//    
//    _listGroupname = [ChineseString IndexArray:self.items];
    
    
//    //测试
//    for (int i = 0; i<[self.items count]; i++) {
//        NameIndex *item = [[NameIndex alloc] init];
//        item._lastName = [self.items objectAtIndex:i];
//        item._originIndex = i;
//        [temp addObject:item];
//    }
//    //名字分section
//    for (NameIndex *item in temp) {
//        //getUserName是实现中文拼音检索的核心，见NameIndex类
//        NSInteger sect = [theCollation sectionForObject:item collationStringSelector:@selector(getLastName)];
//        //设定姓的索引编号
//        item._sectionNum = sect;
//    }
//    
//    //返回27，是a－z和＃
//    NSInteger highSection = [[theCollation sectionTitles] count];
//    //tableView 会被分成27个section
//    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
//    for (int i=0; i<=highSection; i++) {
//        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
//        [sectionArrays addObject:sectionArray];
//    }
//    //根据sectionNum把名字加入到对应section数组里
//    for (NameIndex *item in temp) {
//        [(NSMutableArray *)[sectionArrays objectAtIndex:item._sectionNum] addObject:item];
//    }
//    //进行排序后，加入到数据源中
//    for (NSMutableArray *sectionArray in sectionArrays) {
//        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(getFirstName)]; //按firstName进行排序
//        [self.listGroupname addObject:sortedSection];//这里friendsList是自己定义的列表数据源
//    }
    
    
    

}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSMutableArray * existTitles = [NSMutableArray array];
//    NSArray * allTitles = [[UILocalizedIndexedCollation currentCollation]sectionTitles];
//    //section数组为空的title过滤掉，不显示
//    for (int i=0; i<[allTitles count]; i++) {
//        if ([[self.listGroupname objectAtIndex:i] count] > 0) {
//            [existTitles addObject:[allTitles objectAtIndex:i]];
//        }
//    }
//    return existTitles;
//}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self.searchResults removeAllObjects];
    //NSPredicate 谓词
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@",searchController.searchBar.text];
    self.searchResults = [[self.items filteredArrayUsingPredicate:searchPredicate]mutableCopy];
    //刷新表格
    [self.tableViewMy reloadData];
    
    
}

//添加索引列

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//
//{
//    
//    
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//        
//    {
//        
//        return nil;
//        
//    }
//    
//    
//    
//    return self.items;
//    
//}



//设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回每组行数

   return (!self.searchController.active) ? self.items.count : self.searchResults.count;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [self.listGroupname count];
//}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if ([[self.listGroupname objectAtIndex:section] count] > 0) {
//        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//    }
//    return nil;
//}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    if (indexPath.row > 0) {
        cell.imageView.frame = CGRectMake(60, 60, 10, 10);
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",indexPath.row + 43]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = (!self.searchController.active) ? self.items[indexPath.row] : self.searchResults[indexPath.row];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置每行高度（每行高度可以不一样）
//    if (indexPath.row == 0) {
//        return 100  ;
//    }else{
//        return 44;
//    }
    return 44;
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"adsfads";
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    if ([self.items containsObject:cell.textLabel.text]) {
//        NSLog(@"1");
//        NSLog(@"%@",cell.textLabel.text);
//    }
//    if ([self.searchResults containsObject:cell.textLabel.text]) {
//        NSLog(@"2");
//        NSLog(@"%@",cell.textLabel.text);
//
//    }
    NSLog(@"最终%@",cell.textLabel.text);
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
