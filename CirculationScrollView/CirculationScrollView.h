//
//  CirculationScrollView.h
//  CirculationScrollView
//
//  Created by liucaiyang on 15/3/17.
//  Copyright (c) 2015年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CirculationScrollViewDelegate <NSObject>
- (void)didSelectScrollViewAtIndex:(NSInteger)index;
@end

@interface CirculationScrollView : UIView
@property (nonatomic,assign) id<CirculationScrollViewDelegate> delegate;
@property (nonatomic,strong) NSArray *dataSource;

- (void)reloadData;
@end
