//
//  ViewController.m
//  CirculationScrollView
//
//  Created by liucaiyang on 15/3/17.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "ViewController.h"
#import "CirculationScrollView.h"
@interface ViewController ()<CirculationScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CirculationScrollView *scrollView = [[CirculationScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    scrollView.delegate = self;
    scrollView.dataSource = @[@"welcome_1.png",@"welcome_2.png",@"welcome_3.png",@"welcome_1.png",@"welcome_2.png",@"welcome_3.png"];
    [self.view addSubview:scrollView];
    [scrollView reloadData];
}

- (void)didSelectScrollViewAtIndex:(NSInteger)index
{
    NSLog(@"click %ld",(long)index);
}
@end
