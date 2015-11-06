//
//  MainViewController.m
//  SuspendedBall
//
//  Created by chenpeng on 15/11/6.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "MainViewController.h"
#import "SecViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(pushTo:)];
    self.navigationItem.rightBarButtonItem = right;
    // Do any additional setup after loading the view from its nib.
}

- (void)pushTo:(id)sender
{
    SecViewController *sec = [[SecViewController alloc]init];
    [self.navigationController showViewController:sec sender:nil];
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
