//
//  CirculationScrollView.m
//  CirculationScrollView
//
//  Created by lcy on 15/3/17.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import "CirculationScrollView.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

@interface CirculationScrollView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *previousCycleView;
@property (nonatomic,strong) UIImageView *currentCycleView;
@property (nonatomic,strong) UIImageView *nextCycleView;

@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation CirculationScrollView

- (void)dealloc
{
    _scrollView = nil;
    _scrollView.delegate = nil;
    _pageControl = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapped:)];
        [_scrollView addGestureRecognizer:tapRecognizer];
        
        _previousCycleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _currentCycleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _nextCycleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = self.dataSource.count;
        _pageControl.currentPageIndicatorTintColor = RGBA(66.0, 169.0, 236.0, 1.0);
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        [self addSubview:_pageControl];
        
        _dataSource = [[NSArray alloc] init];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    self.scrollView.frame = bounds;
    
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(bounds), 0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(bounds) * 3, CGRectGetHeight(bounds));
    self.previousCycleView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    self.currentCycleView.frame = CGRectMake(CGRectGetWidth(bounds), 0.0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    self.nextCycleView.frame = CGRectMake(CGRectGetWidth(bounds) * 2, 0.0, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    
    self.pageControl.frame = CGRectMake(0.0, CGRectGetHeight(bounds) - 30.0 , CGRectGetWidth(bounds), 18.0);
    self.pageControl.numberOfPages = self.dataSource.count;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    _currentPage = 0;
}

- (void)reloadData
{
    self.pageControl.currentPage = self.currentPage;
    
    if (self.delegate == nil) {
        return;
    }
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    NSInteger previousPage = [self invalidCurrentCount:_currentPage - 1];
    NSInteger nextPage = [self invalidCurrentCount:_currentPage + 1];
    
    [_previousCycleView setImage:[UIImage imageNamed:_dataSource[previousPage]]];
    [_currentCycleView setImage:[UIImage imageNamed:_dataSource[_currentPage]]];
    [_nextCycleView setImage:[UIImage imageNamed:_dataSource[nextPage]]];

    [self.scrollView addSubview:_previousCycleView];
    [self.scrollView addSubview:_currentCycleView];
    [self.scrollView addSubview:_nextCycleView];
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
}

#pragma mark Action
- (void)sigleTapped:(UITapGestureRecognizer *)gesture
{
    if(_delegate && [_delegate respondsToSelector:@selector(didSelectScrollViewAtIndex:)]){
        [_delegate didSelectScrollViewAtIndex:_pageControl.currentPage];
    }
}

#pragma mark UIScrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat xOffset = scrollView.contentOffset.x;
    if(xOffset >= (CGRectGetWidth(scrollView.bounds) * 2)) { //往后翻
        _currentPage = [self invalidCurrentCount:_currentPage + 1];
        [self reloadData];
    }
    if(xOffset <= 0) {//往前翻
        _currentPage = [self invalidCurrentCount:_currentPage - 1];
        [self reloadData];
    }
}

- (NSInteger)invalidCurrentCount:(NSInteger)page
{
    if (page < 0) {
        page = _dataSource.count -1;
    }else if (page > _dataSource.count -1) {
        page = 0;
    }
    return page;
}

@end
