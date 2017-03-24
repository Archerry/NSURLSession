//
//  ViewController.m
//  WMHSession
//
//  Created by Archer on 2017/3/24.
//  Copyright © 2017年 jiuji. All rights reserved.
//

#import "ViewController.h"
#import "WMHFile.h"
#import "SessionViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_backTable;
    NSMutableArray *_dataSource;
}
@end

@implementation ViewController

-(void)createData{
    NSArray *array = @[@"下载（图片）",@"大文件下载",@"断点续传",@"上传文件"];
    _dataSource = [NSMutableArray arrayWithArray:array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createData];
    [self createUI];
}

-(void)createUI{
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 84, AllScreen.width, 150)];
    titleLbl.text = @"NSURLSession";
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:titleLbl];
    
    _backTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), AllScreen.width, AllScreen.height - CGRectGetMaxY(titleLbl.frame))];
    _backTable.backgroundColor = [UIColor whiteColor];
    _backTable.delegate = self;
    _backTable.dataSource = self;
    [self.view addSubview:_backTable];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *WMHStr = @"string";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WMHStr];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WMHStr];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SessionViewController *sessionVC = [[SessionViewController alloc]init];
    sessionVC.titleStr = [NSString stringWithFormat:@"%@",_dataSource[indexPath.row]];
    sessionVC.whichOne = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
