//
//  ViewController.m
//  Makeipa
//
//  Created by Dio on 2022/3/2.
//  Copyright © 2022 Dio. All rights reserved.
//

#import "ViewController.h"
#import "SecViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *textString = @"这个是用来演示的文字";
    
    //字符串字体大小、颜色全部统一样式
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 375 - 20, 50)];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.text = textString;
    [self.view addSubview:label1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%d",__LINE__);
    SecViewController *sec = [[SecViewController alloc] initWithNibName:@"SecViewController" bundle:nil];
    [self.navigationController pushViewController:sec animated:YES];
}

@end
