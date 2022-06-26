//
//  ThirdViewController.m
//  CompilePureObjcProject
//
//  Created by Dio Brand on 2022/6/26.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Third Page";
}

- (IBAction)jumpAction:(UIButton *)sender {
    NSLog(@"%d ----> go here", __LINE__);
}


@end
