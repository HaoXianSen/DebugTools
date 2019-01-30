//
//  ViewController.m
//  HZDebugTool
//
//  Created by harry on 2019/1/16.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "ViewController.h"
#import "HZDebugManager.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/// Test TableView
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIButton *topButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    _tableView = tableView;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[HZDebugManager sharedManager] showPerformanceWithType:HZDebugManagerPerformanceTypeFPS | HZDebugManagerPerformanceTypeCPU | HZDebugManagerPerformanceTypeMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.numberOfLines = 0;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld个cell,技术是世界上计算机实施近似计算机数据司机计算机四十九司机数据急死急死计算机司机急死缉私局数据缉私局数据is计算机计算贷款的承诺可能吃司机可是你的可能查看可是你的科技搜才能打瞌睡🆚( ^_^ )不错嘛(⊙_⊙?)🏷😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld将要显示", indexPath.row);
    UITableViewCell *lastCell = [self.tableView.visibleCells lastObject];
    NSIndexPath *lastCellIndexPath = [tableView indexPathForCell:lastCell];
    if (lastCellIndexPath.row>=30) {
        self.topButton.hidden = NO;
    } else {
        self.topButton.hidden = YES;
    }
}

- (UIButton *)topButton {
    if (!_topButton) {
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.frame = CGRectMake(self.view.bounds.size.width-60, self.view.bounds.size.height-80, 50, 50);
        _topButton.layer.cornerRadius = 25;
        _topButton.clipsToBounds = YES;
        _topButton.backgroundColor = UIColor.yellowColor;
        [self.view addSubview:_topButton];
    }
    return _topButton;
}

@end
