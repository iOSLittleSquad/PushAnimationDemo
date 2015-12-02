//
//  ViewController.m
//  PushAndPopDemo
//
//  Created by mantou on 15/11/30.
//  Copyright © 2015年 tq. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CustomAnimator.h"

@interface ViewController ()

@property (nonatomic, strong) CustomAnimator *animator;
@property (nonatomic, strong) DetailViewController *detailVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
    
    self.navigationItem.title = @"Demo";
    self.view.backgroundColor = [UIColor yellowColor];
    // 设置代理
    self.navigationController.delegate = self;
    // 设置转场动画
    self.animator = [[CustomAnimator alloc] init];
    
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    self.animator.navigationOperation = operation;
    
    return self.animator;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.animator.selectionCell = [tableView cellForRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











