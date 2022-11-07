//
//  TMMOldComposeViewController.m
//  TMM-iOS
//
//  Created by chenxiong on 2022/9/9.
//

#import "TMMComposeViewController.h"
#import <shared/shared.h>

@interface TMMComposeViewController ()
@property (nonatomic, strong) UIViewController *composeVC;

@end

@implementation TMMComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.composeVC = [SharedViewsKt createDisplayViewUsingComposeJBContainer];
    [self addChildViewController:self.composeVC];
    [self.view addSubview:self.composeVC.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.composeVC.view.frame = self.view.bounds;
}

@end
