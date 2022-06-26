//
//  SecViewController.m
//  CompilePureObjcProject
//
//  Created by Dio Brand on 2022/6/26.
//

#import "SecViewController.h"
#import "ThirdViewController.h"
#import "MyNibView.h"
#import "BookModel.h"

@interface SecViewController ()

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Second Page";

    BookModel *book = [[BookModel alloc] init];
    book.name = @"美人鱼";
    book.icon = @"1";
    
    NSArray *nibViews =  [[NSBundle mainBundle] loadNibNamed:@"MyNibView" owner:self options:nil];
    MyNibView *nibView = [nibViews objectAtIndex:0];
    nibView.frame = CGRectMake(0, 0, 120, 140);
    nibView.backgroundColor = [UIColor yellowColor];
    nibView.book = book;
    
    NSInteger time = 0.3;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //在主线程延迟执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC), mainQueue, ^{
        [self.view addSubview:nibView];
        nibView.center = CGPointMake(self.view.center.x, self.view.center.y + 150);
        NSLog(@"在主线程执行: 3秒后执行这个方法");
    });
}

- (IBAction)jumpAction:(UIButton *)sender {
    ThirdViewController *thirdVC = [ThirdViewController new];
    [self.navigationController pushViewController:thirdVC animated:YES];
}

@end
