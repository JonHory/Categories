//
//  ViewController.m
//  Categories
//
//  Created by rhcf_wujh on 16/9/23.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+LogProperty.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,copy) UITableView * tableView;

@property (nonatomic ,strong) NSArray * titles;

@end

@implementation ViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    return _tableView;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"Dict转Model"
                    ];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = self.view.bounds;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CategoriesCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row >= self.titles.count) {
        return cell;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.titles[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case CategoryTypeNSObject:
            [self jsonToModel];
            break;
            
        default:
            break;
    }
}

- (void)jsonToModel{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"x"] = @"xxxx";
    dict[@"list"] = @[@{@"aa":@"a"},@{@"bb":@"b"},@{@"cc":@"c"}];
    dict[@"num"] = @1.01;
    
    [NSObject printPropertyListWithDict:dict];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
