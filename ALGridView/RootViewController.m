//
//  RootViewController.m
//  ALGridView
//
//  Created by Arien Lau on 14-5-27.
//  Copyright (c) 2014年 Arien Lau. All rights reserved.
//

#import "RootViewController.h"
#import "ALGridView.h"

@interface RootViewController () <ALGridViewDataSource, ALGridViewDelegate>
{
    ALGridView *_gridView;
    NSMutableArray *_viewData;
}

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewData = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [_viewData addObject:[NSNull null]];
    }
    _gridView = [[ALGridView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _gridView.dataSource = self;
    _gridView.delegate = self;
//    _gridView.scrollMode = ALGridViewScrollModeHorizontal;
    _gridView.topMargin = 30;
    _gridView.bottomMargin = 30;
    _gridView.leftMargin = 10;
    _gridView.canEnterEditing = YES;
    _gridView.canCreateFolder = YES;
    [self.view addSubview:_gridView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(50, 100, 70, 40);
//    [button setTitle:@"title" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(itemDidTaped:) forControlEvents:UIControlEventTouchUpInside];
//    [button addTarget:self action:@selector(itemDidTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
//    [button addTarget:self action:@selector(itemDidTouchUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
//    [button addTarget:self action:@selector(itemDidTouchCancel:) forControlEvents:UIControlEventTouchCancel];
//    [button addTarget:self action:@selector(itemDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
//    [self.view addSubview:button];
}

//- (void)itemDidTaped:(ALGridViewItem *)item
//{
//    NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)itemDidTouchDown:(ALGridViewItem *)item withEvent:(UIEvent *)event
//{
//     NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)itemDidTouchUpOutSide:(ALGridViewItem *)item
//{
//    //手指超过control的边界
//     NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)itemDidTouchCancel:(UIButton *)button
//{
//    NSLog(@"%s", __FUNCTION__);
//}
//
//- (void)itemDidTouchDragExit:(UIButton *)button
//{
//    NSLog(@"%s", __FUNCTION__);
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ALGridViewDataSource
- (NSInteger)numberOfItemsInGridView:(ALGridView *)gridView
{
    return _viewData.count;
}

- (NSInteger)numberOfColumnsInGridView:(ALGridView *)gridView
{
    return 3;
}

- (ALGridViewItem *)ALGridView:(ALGridView *)gridView itemAtIndex:(NSInteger)index
{
    static NSString *reuserIdentifier = @"algridViewIdentifier";
    ALGridViewItem *item = [gridView dequeueReusableItemWithIdentifier:reuserIdentifier];
    if (!item) {
        item = [[ALGridViewItem alloc] initWithReuseIdentifier:reuserIdentifier];
//        [item addTarget:self action:@selector(itemDidTaped:) forControlEvents:UIControlEventTouchUpInside];
//        [item addTarget:self action:@selector(itemDidTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
//        [item addTarget:self action:@selector(itemDidTouchUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
//        [item addTarget:self action:@selector(itemDidTouchCancel:) forControlEvents:UIControlEventTouchCancel];
//        [item addTarget:self action:@selector(itemDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    }
    item.label.text = [NSString stringWithFormat:@"第 %d 行", index];
    item.backgroundColor = [UIColor grayColor];
    return item;
}

- (BOOL)ALGridView:(ALGridView *)gridView canMoveItemAtIndex:(NSInteger)index
{
    return (index != 0);
}

- (BOOL)ALGridView:(ALGridView *)gridView canTriggerEditAtIndex:(NSInteger)index
{
    return (index != 1);
}

#pragma mark - ALGridViewDelegate
- (CGSize)itemSizeForGridView:(ALGridView *)gridView
{
    return CGSizeMake(90, 90);
}

- (void)ALGridView:(ALGridView *)gridView didSelectItemAtIndex:(NSInteger)index
{
//    CAAnimation *animation = [CAAnimation animation];
//    animation.duration = 0.3;
//    animation.
//    [_viewData removeObjectAtIndex:index];
//    [_gridView deleteItemAtIndex:index isNeedAnimation:YES];
//    [gridView deleteItemAtIndex:index animation:[self dropBookToCloudAnimation:[_gridView itemAtIndex:index]]];
}

- (CAAnimation *)dropBookToCloudAnimation:(ALGridViewItem *)cellToDelete
{
//    NSInteger index = [_gridView indexOfItem:cellToDelete];
//    CGRect frameOfDeleteItem = [_gridView frameForItemAtIndex:index];
    //animation path
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CGPoint fromPoint = cellToDelete.center;
    [movePath moveToPoint:fromPoint];
    CGPoint endPoint = CGPointMake(fromPoint.x + 100, fromPoint.y + 100);
    [movePath addLineToPoint:endPoint];
//    int nOffSet = 150;
//    [movePath addQuadCurveToPoint:endPoint
//                     controlPoint:CGPointMake(endPoint.x + 120, endPoint.y - nOffSet)];
    //move
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = YES;
    
    //scale
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)];
    scaleAnim.removedOnCompletion = YES;
    
    //alpha
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.0];
    //    opacityAnim.removedOnCompletion = YES;
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
    animGroup.duration = 0.3;
    animGroup.delegate = nil;
    animGroup.removedOnCompletion = YES;
    
    return animGroup;
}

- (CGFloat)rowSpacingForGridView:(ALGridView *)gridView
{
    return 20;
}

- (CGFloat)columnSpacingForGridView:(ALGridView *)gridView
{
    return 10;
}

- (void)ALGridView:(ALGridView *)gridView didBeganDragItemAtIndex:(NSInteger)index
{
    NSLog(@"%s, %d", __FUNCTION__, index);
}

- (void)ALGridView:(ALGridView *)gridView didEndDragItemAtIndex:(NSInteger)index
{
    NSLog(@"%s, %d", __FUNCTION__, index);
}

@end
