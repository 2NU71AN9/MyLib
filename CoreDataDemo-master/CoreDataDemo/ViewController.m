//
//  ViewController.m
//  CoreDataDemo
//
//  Created by sjimac01 on 2018/5/2.
//  Copyright © 2018年 sjimac01. All rights reserved.
//

#import "ViewController.h"
#import "PersonManager.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation ViewController
{
    NSManagedObjectContext *_context;
}
static int personId =0;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem =barButtonItem;
    
    // 因为数据是假的，所以为了避免重复，先拿到最大ID
    int maxPersonID =0;
    for (Person *person in [[PersonManager shareManager] readAllData]) {
        if (maxPersonID<[person.personID intValue]) {
            maxPersonID =[person.personID intValue];
        }
    }
    personId += maxPersonID;
    // 添加tableView
    [self.view addSubview:self.tableView];
    // TODO: 查询所有数据 添加数据
    [self.dataSource addObjectsFromArray:[[PersonManager shareManager] readAllData]];
    [self.tableView reloadData];
}

#pragma mark - Click

#pragma mark - 添加数据

- (void)addItem {
    // TODO: 新增
    [[PersonManager shareManager] insertDataWithPersonID:[NSString stringWithFormat:@"%d",personId]
                                                    name:[NSString stringWithFormat:@"客服%02d",personId]
                                                     age:arc4random()%20
                                                   photo:@"photo"];
    // TODO: 查询
    [self.dataSource addObject:[[PersonManager shareManager] searchDataWithPersonID:[NSString stringWithFormat:@"%d",personId]]];
    Person *person =[self.dataSource lastObject];
    NSArray *records =(NSArray *)person.trackRecord;
    NSLog(@"%@",records);
    [self.tableView reloadData];
    personId++;
}


#pragma mark - Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellID"];
    }
    Person *person =self.dataSource[indexPath.row];
    cell.textLabel.text         =person.name;
    cell.detailTextLabel.text   =[NSString stringWithFormat:@"%d",person.age];
    cell.imageView.image        =[UIImage imageNamed:person.photo];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Person *person =self.dataSource[indexPath.row];
    // TODO: 删除
    [[PersonManager shareManager] deleteDataWithPersonID:person.personID];
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - ==============================实例化============================


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource =[NSMutableArray array];
    }
    return _dataSource;
}




@end
