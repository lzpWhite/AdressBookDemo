//
//  ViewController.m
//  AddressBookTest
//
//  Created by 刘志鹏 on 16/3/14.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import "ViewController.h"
#import "LZPAddRessBookManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LZPAddRessBookManager *manager;
@property (nonatomic, strong) NSMutableArray *allPerson;
@property (nonatomic, assign) NSInteger idModifty;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self initALlPerson];
    
}

- (void)createTableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
}
- (void)setAllPerson:(NSMutableArray *)allPerson
{
    if (allPerson && allPerson.count>0) {
        _allPerson = [[NSMutableArray alloc] initWithArray:allPerson];
        [_tableView reloadData];
    }
}

- (void)initALlPerson {
    _manager = [[LZPAddRessBookManager alloc] init];
    LZPWeak(self);
    [_manager setGetAllPerson:^(NSMutableArray *arrPeople) {
        weakself.allPerson = arrPeople;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allPerson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    ABRecordRef recordRef = (__bridge ABRecordRef)self.allPerson[indexPath.row];
    
    LZPAddRessBookModel *model = [[LZPAddRessBookModel alloc] initWith:recordRef];
    
    NSDictionary *dict = model.phones[0];
    
    NSString *str = dict.allKeys[0];
    
    cell.detailTextLabel.text=dict[str];
    
    if(model.imageData.length>0){//如果有照片数据
        
        cell.imageView.image=[UIImage imageWithData:model.imageData];
    }else{
        cell.imageView.image=[UIImage imageNamed:@"avatar"];//没有图片使用默认头像
    }
    //使用cell的tag存储记录id
    cell.tag=model.recordId;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",model.personName,model.lastName];
    return cell;
    
    //    return [UITableViewCell new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
