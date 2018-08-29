//
//  ViewController.m
//  GGSlotMachine
//
//  Created by Mr.Gao on 2018/8/29.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)GoSlotMachine:(UIButton *)sender {
    [self.navigationController pushViewController:[[TestViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
