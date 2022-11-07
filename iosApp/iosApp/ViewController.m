//
//  ViewController.m
//  iosApp
//
//  Created by chenxiong on 2022/11/2.
//

#import "ViewController.h"
#import "TMMComposeViewController.h"
#import "TMMNoImageViewController.h"

@interface ViewController ()
@property (nonatomic ,strong) NSMutableArray <UIButton *> *buttons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"long list demo";
    NSLog(@"viewDidLoad");
    [self setNavigationBarBackgroundColor:[UIColor whiteColor]];
    self.buttons = @[].mutableCopy;
    {
        UIButton *button = [self createButtonWithTitle:@"render using CADisplayLink"
                                              selector:@selector(didPressedCADisplayLinkButton)];
        [self addButton:button];
    }
    
    {
        UIButton *button = [self createButtonWithTitle:@"render using Compose-jb container"
                                              selector:@selector(didPressedComposeJBContainerButton)];
        [self addButton:button];
    }
}

#pragma mark - life circle
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat originY = self.view.safeAreaInsets.top + 80;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat buttonHeight = 40.0f;
    for (UIButton *button in self.buttons) {
        button.frame = CGRectMake(0, originY, viewWidth, buttonHeight);
        originY = CGRectGetMaxY(button.frame);
    }
}

- (void)didPressedComposeJBContainerButton {
    TMMComposeViewController *vc = [[TMMComposeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressedCADisplayLinkButton {
    TMMNoImageViewController *vc = [[TMMNoImageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addButton:(UIButton *)button {
    if (button) {
        [self.buttons addObject:button];
        [self.view addSubview:button];
    }
}

-(void)setNavigationBarBackgroundColor:(UIColor *)color {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (@available(iOS 15.0, *)) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
        attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = color;
        appearance.titleTextAttributes = attrs;
        [navigationBar setStandardAppearance:appearance];
        [navigationBar setScrollEdgeAppearance:appearance];
        
        navigationBar.standardAppearance.backgroundColor = color;
        navigationBar.scrollEdgeAppearance.backgroundColor = color;
    } else {
        self.navigationController.navigationBar.barTintColor = color;
    }
}

#pragma mark -
- (UIButton *)createButtonWithTitle:(NSString *)title selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    button.layer.borderWidth = 0.5f;
    
    return button;
}


@end
