//
//  LCSlotMachine.h
//  LCLuckyCoffee
//
//  Created by Mac on 2017/1/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGSlotMachine;

@protocol GGSlotMachineDelegate <NSObject>

@optional
/** 动画开始 */
- (void)gg_slotMachineWillStartSliding:(GGSlotMachine *)slotMachine;
/** 动画结束 */
- (void)gg_slotMachineDidEndSliding:(GGSlotMachine *)slotMachine;

@end

@protocol GGSlotMachineDataSource <NSObject>

@required
/** 需要号码个数 */
- (NSUInteger)gg_numberOfSlotsInSlotMachine:(GGSlotMachine *)slotMachine;
/** 图片数组 */
- (NSArray *)gg_iconsForSlotsInSlotMachine:(GGSlotMachine *)slotMachine;

@optional
/** 每个号码width */
- (CGFloat)gg_slotWidthInSlotMachine:(GGSlotMachine *)slotMachine;
/** 间距 **/
- (CGFloat)gg_slotSpacingInSlotMachine:(GGSlotMachine *)slotMachine;

@end


@interface GGSlotMachine : UIView

/** 默认（0，0，0，0） */
@property (nonatomic) UIEdgeInsets contentInset;
/** 数字占位视图背景 */
@property (nonatomic, strong) UIImage *backgroundImage;
/** Super背景 */
@property (nonatomic, strong) UIImage *coverImage;

/** 选中号码数组 */
@property (nonatomic, strong) NSArray *slotResults;

@property (nonatomic) CGFloat singleUnitDuration;

/** 控制旋转速度 默认0.15 */
@property (nonatomic, weak) id <GGSlotMachineDelegate> delegate;
@property (nonatomic, weak) id <GGSlotMachineDataSource> dataSource;

- (void)startSliding;
@end
