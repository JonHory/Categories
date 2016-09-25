//
//  ViewController.m
//  Categories
//
//  Created by rhcf_wujh on 16/9/23.
//  Copyright © 2016年 wjh. All rights reserved.
//

#import "ViewController.h"

#import "NSObject+LogProperty.h"

#import "NSDate+WeiBo.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,copy  ) UITableView  * tableView;

@property (nonatomic ,strong) NSArray< NSDictionary *> * titles;



@end

@implementation ViewController

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        
        //tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    return _tableView;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@{@"例子":@[@"这只是一个例子"
                                ]},
                    @{@"UIView":@[@"UIView"
                                  ]},
                    @{@"UIImage":@[@"UIImage"
                                   ]},
                    @{@"UIColor":@[@"UIColor"
                                   ]},
                    @{@"NSObject":@[@"Dict输出快速写Model"
                                    ]},
                    @{@"NSDate":@[@"判断今年昨天今天"
                                  ]},
                    ];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欢迎";
    
    self.tableView.frame = self.view.bounds;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * datas = self.titles[section].allValues.lastObject;
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CategoriesCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSArray * datas = self.titles[indexPath.section].allValues.lastObject;

    cell.textLabel.text = [NSString stringWithFormat:@"%@",datas[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray * datas = [[NSMutableArray alloc]init];
    [self.titles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * title = obj.allKeys.lastObject;
        [datas addObject:title];
    }];
    return datas;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * title = self.titles[section].allKeys.lastObject;
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case CategoryTypeNSObject:{
            [self jsonToModel];
            break;
        }
        default:
            break;
    }
}

#pragma mark - NSObject
- (void)jsonToModel{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"x"] = @"xxxx";
    dict[@"list"] = @[@{@"aa":@"a"},@{@"bb":@"b"},@{@"cc":@"c"}];
    dict[@"num"] = @1.01;
    
    [NSObject printPropertyListWithDict:dict];
}

#pragma mark - NSDate
- (void)pushDateVC{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
