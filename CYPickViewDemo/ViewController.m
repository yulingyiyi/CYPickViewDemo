//
//  ViewController.m
//  CYPickViewDemo
//
//  Created by SX on 2017/5/31.
//  Copyright © 2017年 YULING. All rights reserved.
//

#import "ViewController.h"
#import "CYPickView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)cliak:(UIButton *)sender {
    
//    [CYPickView showDataViewWithItem:@[@"11", @"22", @"33", @"444"] title:@"选中" cancel:@"cancel" ok:@"OK" block:^(NSString *str) {
//       
//        NSLog(@"_%@", str);
//    }];
    [CYPickView showDateViewWithTitle:@"选中" cancel:@"cancel" ok:@"OK" block:^(NSString *str) {
        
        NSLog(@"_%@", str);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
