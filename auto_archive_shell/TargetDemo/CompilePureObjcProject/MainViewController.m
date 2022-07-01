//
//  MainViewController.m
//  CompilePureObjcProject
//
//  Created by Dio Brand on 2022/6/25.
//

#import "MainViewController.h"
#import "SecViewController.h"
#import "MyNibView.h"
#import "BookModel.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Main Page";
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(10, 45, 200, 45);
    [lab setText:@"This is a label"];
    [self.view addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 200, 50);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"Jump to 2 Page" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
    

    BookModel *book = [[BookModel alloc] init];
    book.name = @"美人鱼";
    book.icon = @"1";
    
    NSArray *nibViews =  [[NSBundle mainBundle] loadNibNamed:@"MyNibView" owner:self options:nil];
    MyNibView *nibView = [nibViews objectAtIndex:0];
    nibView.frame = CGRectMake(10, 10, 120, 140);
    nibView.backgroundColor = [UIColor yellowColor];
    nibView.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    nibView.book = book;
    [self.view addSubview:nibView];
}

- (void)jumpAction:(UIButton *)button {
    SecViewController *secVC = [SecViewController new];
    [self.navigationController pushViewController:secVC animated:YES];
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
