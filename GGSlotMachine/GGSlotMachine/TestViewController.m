//
//  TestViewController.m
//  GGSlotMachine
//
//  Created by Mr.Gao on 2018/8/29.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "TestViewController.h"
#import "GGSlotMachineSuperView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    GGSlotMachineSuperView *view = [[GGSlotMachineSuperView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    [self.view addSubview:view];
    [view start];
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
