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


@interface ViewController ()

@property (nonatomic, assign) UINavigationControllerOperation navigationOperation;
@property (nonatomic, weak) UITableViewCell *selectionCell;

@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *downView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
    
    
}

- (UIImage *)snapshotWithRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[(AppDelegate *)[UIApplication sharedApplication].delegate window].layer renderInContext:ctx];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"first:%@ - %f", NSStringFromCGSize(snapshot.size), snapshot.scale);
    UIGraphicsEndImageContext();
    CGRect clipRect = rect;
    CGAffineTransform rectTransform = CGAffineTransformScale(CGAffineTransformIdentity, snapshot.scale, snapshot.scale);
    clipRect = CGRectApplyAffineTransform(rect, rectTransform);
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(snapshot.CGImage, clipRect)];
    NSLog(@"result:%@", NSStringFromCGSize(resultImg.size));

    return resultImg;

}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.navigationOperation = operation;
    
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        CGRect currentRect = [self.selectionCell convertRect:self.selectionCell.bounds toView:[(AppDelegate *)[UIApplication sharedApplication].delegate window]];
        NSLog(@"convert: %@", NSStringFromCGRect(currentRect));
        
        //截取cell到屏幕顶端的图片
        UIImageView *upImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentRect.size.width, CGRectGetMaxY(currentRect))];
        upImg.image = [self snapshotWithRect:upImg.bounds];
        self.upView = upImg;
        
        //截取cell到屏幕下端的图片
        UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(currentRect), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(currentRect))];
        downImg.image = [self snapshotWithRect:downImg.frame];
        self.downView = downImg;
        
        //添加至window上
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:upImg];
        [[(AppDelegate *)[UIApplication sharedApplication].delegate window] addSubview:downImg];
        
        //
        toVC.view.frame = CGRectMake(0, CGRectGetMaxY(upImg.frame), toVC.view.frame.size.width, toVC.view.frame.size.height);

        
        [containerView addSubview:toVC.view];

    } else if (self.navigationOperation == UINavigationControllerOperationPop) {

    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        if (self.navigationOperation == UINavigationControllerOperationPush) {
            fromVC.view.alpha = 0.5;
            CGRect frame = toVC.view.frame;
            frame.origin.y = 0;
            toVC.view.frame = frame;
            self.upView.frame = CGRectMake(0,  - CGRectGetMaxY(self.upView.frame), [UIScreen mainScreen].bounds.size.width, self.upView.frame.size.height);
            self.downView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.downView.frame.size.height);
        } else if (self.navigationOperation == UINavigationControllerOperationPop) {
            toVC.view.alpha = 1;
            self.upView.frame = CGRectMake(0, 0, self.upView.frame.size.width, self.upView.frame.size.height);
            self.downView.frame = CGRectMake(0, self.upView.frame.size.height, self.downView.frame.size.width, self.downView.frame.size.height);
            fromVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.upView.frame), toVC.view.frame.size.width, toVC.view.frame.size.height);

        }
    } completion:^(BOOL finished) {
        
        if (self.navigationOperation == UINavigationControllerOperationPop) {
            [containerView insertSubview:toVC.view aboveSubview:fromVC.view];

            [self.upView removeFromSuperview];
            [self.downView removeFromSuperview];
            self.upView = nil;
            self.downView = nil;
        }
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectionCell = [tableView cellForRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











