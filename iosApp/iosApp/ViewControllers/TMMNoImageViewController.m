//
//  TMMNoImageViewController.m
//  TMM-iOS
//
//  Created by chenxiong on 2022/8/12.
//

#import "TMMNoImageViewController.h"
#import <TMMUIKit/TMMUIView.h>
#import <shared/shared.h>

@interface TMMNoImageViewController ()
@property (nonatomic, strong) TMMUIView *skiaView;
@end

@implementation TMMNoImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.skiaView = [SharedViewsKt createDisplayViewUsingCADisplayLink];
    [self.view addSubview:self.skiaView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.skiaView.frame = self.view.bounds;
}

- (void)dealloc {
    [self.skiaView dispose];
    self.skiaView = nil;
}


@end
