//
//  SecondViewController.m
//  ALGridView
//
//  Created by Arien Lau on 14-7-5.
//  Copyright (c) 2014年 Arien Lau. All rights reserved.
//

#import "SecondViewController.h"
#import "ALGridView.h"

@interface SecondViewController () <ALGridViewDataSource, ALGridViewDelegate, UIActionSheetDelegate>
{
    ALGridView *_gridView;
    NSMutableArray *_viewData;
    
    BOOL _isReloadData;
}

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

CGFloat systemVersion();
CGFloat systemVersion() {
    static CGFloat _systemVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    });
    return _systemVersion;
}

#define iOS7_0 (systemVersion() >= 7.0)

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    if (iOS7_0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _isReloadData = NO;
    _viewData = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [_viewData addObject:[NSNull null]];
    }
    _gridView = [[ALGridView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _gridView.dataSource = self;
    _gridView.delegate = self;
    //    _gridView.scrollMode = ALGridViewScrollModeHorizontal;
    _gridView.topMargin = 10;
    _gridView.bottomMargin = 10;
    _gridView.leftMargin = 10;
    _gridView.canEdit = YES;
    _gridView.canCreateFolder = YES;
    [self.view addSubview:_gridView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ALGridViewDataSource
- (NSInteger)numberOfItemsInGridView:(ALGridView *)gridView
{
    return _viewData.count + 1;
}

- (NSInteger)numberOfColumnsInGridView:(ALGridView *)gridView
{
    return 3;
}

- (ALGridViewItem *)gridView:(ALGridView *)gridView itemAtIndex:(NSInteger)index
{
    static NSString *reuserIdentifier = @"algridViewIdentifier";
    static NSString *lastIdentifier = @"lastIdentifier";
    ALGridViewItem *item = nil;
    if (index == _viewData.count) {
        item = [gridView dequeueReusableItemWithIdentifier:lastIdentifier];
        if (!item) {
            item = [[ALGridViewItem alloc] initWithReuseIdentifier:lastIdentifier];
        }
        item.label.text = @" + ";
    } else {
        item = [gridView dequeueReusableItemWithIdentifier:reuserIdentifier];
        if (!item) {
            item = [[ALGridViewItem alloc] initWithReuseIdentifier:reuserIdentifier];
        }
        item.label.text = [NSString stringWithFormat:@"第 %d 行", index];
        //    if (_isReloadData) {
        //        item.label.text = [NSString stringWithFormat:@"%d row", index];
        //    } else {
        //        item.label.text = [NSString stringWithFormat:@"第 %d 行", index];
        //    }
    }
    CGFloat red = rand() % 255;
    CGFloat green = rand() % 255;
    CGFloat blue = rand() % 255;
    
    item.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    item.layer.borderColor = [UIColor whiteColor].CGColor;
    item.layer.borderWidth = 1.0;
    
    return item;
}

- (BOOL)gridView:(ALGridView *)gridView canMoveItemAtIndex:(NSInteger)index
{
    return NO;
    return (index != 0 && index != _viewData.count);
}

- (BOOL)gridView:(ALGridView *)gridView canTriggerEditAtIndex:(NSInteger)index
{
    return (index != _viewData.count);
    return (index != 1 && index != _viewData.count);
}

#pragma mark - ALGridViewDelegate
- (CGSize)itemSizeForGridView:(ALGridView *)gridView
{
    return CGSizeMake(90, 90);
}

- (void)gridView:(ALGridView *)gridView didSelectItemAtIndex:(NSInteger)index
{
    //    CAAnimation *animation = [CAAnimation animation];
    //    animation.duration = 0.3;
    //    animation.
    //    [_viewData removeObjectAtIndex:index];
    //    [_gridView deleteItemAtIndex:index isNeedAnimation:YES];
    //    [gridView deleteItemAtIndex:index animation:[self dropBookToCloudAnimation:[_gridView itemAtIndex:index]]];
    if (index == _viewData.count) {
        NSLog(@"点击了 加号");
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"other1", @"other2", @"other3", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d", buttonIndex);
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
    return 15;
}

//- (void)gridView:(ALGridView *)gridView didBeganDragItemAtIndex:(NSInteger)index
//{
//    NSLog(@"%s, %d", __FUNCTION__, index);
//}
//
//- (void)gridView:(ALGridView *)gridView didEndDragItemAtIndex:(NSInteger)index
//{
//    NSLog(@"%s, %d", __FUNCTION__, index);
//}

- (void)gridViewDidBeginEditing:(ALGridView *)gridView
{
    NSLog(@"start editing");
}

- (void)gridViewDidEndEditing:(ALGridView *)gridView
{
    NSLog(@"end editing");
}

- (void)gridView:(ALGridView *)gridView willMergeItemsWithReceiverIndex:(NSInteger)receiverIndex fromIndex:(NSInteger)fromIndex
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"will reIndex : %d fromIndex : %d", receiverIndex, fromIndex);
    
}

- (void)gridView:(ALGridView *)gridView didCancelMergeItemsWithReceiverIndex:(NSInteger)receiverIndex fromIndex:(NSInteger)fromIndex
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"did Cancel Merge reIndex:%d fromIndex: %d",receiverIndex, fromIndex);
}

- (void)gridView:(ALGridView *)gridView didMergeItemsWithReceiverIndex:(NSInteger)receiverIndex fromIndex:(NSInteger)fromIndex touch:(UITouch *)touch
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"did reIndex : %d fromIndex : %d", receiverIndex, fromIndex);
}

- (BOOL)gridView:(ALGridView *)gridView canReceiveOtherItemAtIndex:(NSInteger)index
{
    return (index != _viewData.count);
}

@end
