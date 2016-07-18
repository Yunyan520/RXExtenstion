//
//  TodayViewController.m
//  RXToDay
//
//  Created by srx on 16/7/8.
//  Copyright © 2016年 https://github.com/srxboys. All rights reserved.
//
// > iOS8

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "RXPost.h"
#import "RXTodayCell.h"


@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>
{
    UITableView * _tableView;
    CGFloat _tableHeight;
    CGFloat _buttonHeight;
    RXPost * _post;
}


@property (nonatomic, copy) NSArray * sourceArr;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configUI];
}


- (void)configUI {
    //高度
    self.preferredContentSize = CGSizeMake(0, 0);
    
    _post = [[RXPost alloc] init];
    
    _tableHeight  = 200;
    _buttonHeight = 40;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, _tableHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _tableView.tableFooterView = [[UIView alloc] init];
    self.sourceArr = [_post getDataFromeLocalPost];
}

- (void)setSourceArr:(NSArray *)sourceArr {

    if(sourceArr.count <= 0) {
        return;
    }

    _sourceArr = sourceArr;
    [_tableView reloadData];
//    [self performSelector:@selector(widgetPerformUpdateWithCompletionHandler:) withObject:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArr.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIndetifi = @"RXTodayCell";
    RXTodayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifi];
    [cell setCellData:_sourceArr[indexPath.row]];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoOrderPage"] completionHandler:^(BOOL success) {
//        NSLog(@"open url result:%d",success);
//    }];
    
    
    /*
     在 appDelegate
         - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
         {
         NSString* prefix = @"iOSWidgetApp://action=";
         if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
         NSString* action = [[url absoluteString] substringFromIndex:prefix.length];
         if ([action isEqualToString:@"GotoHomePage"]) {
         
         }
         else if([action isEqualToString:@"GotoOrderPage"]) {
         BasicHomeViewController *vc = (BasicHomeViewController*)self.window.rootViewController;
         [vc.tabbar selectAtIndex:2];
         }
         }
         
         return  YES;
         }
     */
}


//取消widget默认的inset，让应用靠左
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
//{
//    return UIEdgeInsetsZero;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    //执行任何必要的安装程序以更新视图。
    //如果遇到错误，使用NCUpdateresultfailed
    //如果有不需要更新，使用NCUpdateresultnodata
    //如果有更新，使用NCUpdateresultnewdata
    
    if(_post == nil) {
        NSLog(@"completionHandler post=nil");
        if (completionHandler) {
            completionHandler(NCUpdateResultFailed);
        }
        return;
    }
    
    [_post postReqeustCompletion:^(NSArray *array, BOOL isError) {
        if(!isError) {
            self.sourceArr = array;
//            self.preferredContentSize = CGSizeMake(0, 300);
            if (completionHandler) {
                completionHandler(self.sourceArr.count > 0 ? NCUpdateResultNewData : NCUpdateResultNoData);
            }
        }
        else {
//            self.preferredContentSize = CGSizeMake(0, 0);
            if (completionHandler) {
                completionHandler(NCUpdateResultFailed);
            }
        }
        
        if(_sourceArr.count <= 0) {
            self.preferredContentSize = CGSizeMake(0, 0);
        }
        else {
            self.preferredContentSize = CGSizeMake(0, 250);
        }
        
    }];
  
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Today viewDidAppear数据");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Today viewWillwilllllAppear");
    
    
    if(_post == nil) {
        NSLog(@"viewWillwilllllAppear post=nil");
        return;
    }
    NSLog(@"开始请求数据");
    
    [_post postReqeustCompletion:^(NSArray *array, BOOL isError) {
        
        NSLog(@"进入请求 部分");
        
        if(!isError) {
            self.sourceArr = array;
            NSLog(@"Today 刷新数据");
        }
        else {
            NSLog(@"Today 没有数据");
        }
        
    }];
}


@end
