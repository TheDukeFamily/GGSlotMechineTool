//
//  LCSlotMachineSuperView.h
//  LCLuckyCoffee
//
//  Created by Mac on 2017/1/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGSlotMachine.h"
@interface GGSlotMachineSuperView : UIView<GGSlotMachineDelegate, GGSlotMachineDataSource>
- (void)start;
@end
