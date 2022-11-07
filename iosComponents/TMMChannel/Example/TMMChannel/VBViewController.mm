//
//  VBViewController.m
//  TMMChannel
//
//  Created by "chenxiong" on 08/09/2022.
//  Copyright (c) 2022 "chenxiong". All rights reserved.
//

#import "VBViewController.h"
#import <TMMChannel/TMMFeedListLoader.h>

@interface VBViewController ()

@end

@implementation VBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [TMMFeedListLoader fetchNoImageDataWithContext:nil isMore:NO success:^(NSArray<TMMBaseViewModel *> * _Nonnull viewModels) {
        NSLog(@"%@", viewModels);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    [TMMFeedListLoader fetchNoImageJSONWithContext:nil isMore:NO success:^(NSDictionary *json) {
        NSLog(@"%@", json);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
