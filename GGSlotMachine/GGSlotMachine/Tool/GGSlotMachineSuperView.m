//
//  LCSlotMachineSuperView.m
//  LCLuckyCoffee
//
//  Created by Mac on 2017/1/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "GGSlotMachineSuperView.h"
#import "UIImage+LCImage.h"

#define LCAlert(msg) [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
#define WINDOW_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define WINDOW_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface GGSlotMachineSuperView()
//@property (nonatomic, strong)NSMutableArray *slotIcons;
@property (nonatomic, strong) NSArray <UIImage *> *gifArray;
@property (nonatomic, strong) GGSlotMachine  *slotMachine;
@property (nonatomic, strong) UIImageView    *startImgV;
@property (nonatomic, strong) UIButton       *startButton;
@property (nonatomic, strong) NSMutableArray *slotIcons;
@end

@implementation GGSlotMachineSuperView

- (NSArray *)gifArray{
    if (!_gifArray) {
        _gifArray = [NSArray arrayWithObjects:
                     [UIImage imageNamed:@"user_cp_yao_01"],
                     [UIImage imageNamed:@"user_cp_yao_02"],
                     [UIImage imageNamed:@"user_cp_yao_03"],
                     [UIImage imageNamed:@"user_cp_yao_04"],
                     [UIImage imageNamed:@"user_cp_yao_03"],
                     [UIImage imageNamed:@"user_cp_yao_02"],
                     [UIImage imageNamed:@"user_cp_yao_01"],nil];
    }
    return _gifArray;
}

- (NSMutableArray *)slotIcons{
    if (!_slotIcons) {
        _slotIcons = [NSMutableArray array];
        for (int i = 1; i<46; i++) {
            NSString *string;
            if (i<10) {
                string = [NSString stringWithFormat:@"0%d",i];
            }else{
                string = [NSString stringWithFormat:@"%d",i];
            }
            [_slotIcons addObject:[UIImage imageWithTitle:string]];
        }
    }
    return _slotIcons;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createSpareParts];
    }
    return self;
}

#pragma mark - 绘制页面视图
- (void)createSpareParts{
    CGFloat WIDTH = (WINDOW_WIDTH-60)*0.914;
    _slotMachine = [[GGSlotMachine alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH*0.3783)];
    _slotMachine.center = CGPointMake(self.frame.size.width / 2, WIDTH*0.18915+100);
    _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _slotMachine.backgroundImage = [UIImage imageNamed:@"user_cp_bg_ge"];
    _slotMachine.coverImage = [UIImage imageNamed:@"user_cp_bg"];
    
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    [self addSubview:_slotMachine];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImageN = [UIImage imageNamed:@"user_cp_btn"];
    UIImage *btnImageH = [UIImage imageNamed:@"user_cp_btn_b"];
    _startButton.frame = CGRectMake(0, 0, btnImageN.size.width, btnImageN.size.height);
    _startButton.center = CGPointMake(self.frame.size.width / 2, WIDTH*0.26593+100);
    _startButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [_startButton setBackgroundImage:btnImageN forState:UIControlStateNormal];
    [_startButton setBackgroundImage:btnImageH forState:UIControlStateHighlighted];
    [_startButton setBackgroundImage:btnImageH forState:UIControlStateDisabled];
    [_startButton addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_startButton];
    
    _startImgV = [[UIImageView alloc] initWithFrame:CGRectMake((WINDOW_WIDTH-60)*0.957+30, 100, 35, 101)];
    _startImgV.image = [UIImage imageNamed:@"user_cp_yao_01"];
    _startImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)];
    UISwipeGestureRecognizer *singdown =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(start)];
    [singdown setDirection:UISwipeGestureRecognizerDirectionDown];
    [_startImgV addGestureRecognizer:singdown];
    [_startImgV addGestureRecognizer:singleTap];
    [self addSubview:_startImgV];
}

#pragma mark - 下注点击事件
- (void)startBtnClick{
    if (_slotMachine.slotResults) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        LCAlert([self dictionaryToJson:@{@"data":_slotMachine.slotResults}]);
#pragma clang diagnostic pop
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        LCAlert(@"请遥操纵杆");
#pragma clang diagnostic pop
    }
}

- (void)start{
    
    _startImgV.animationImages = self.gifArray; //动画图片数组
    _startImgV.animationDuration = 0.5; //执行一次完整动画所需的时长
    _startImgV.animationRepeatCount = 1;  //动画重复次数
    [_startImgV startAnimating];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSInteger i=1; i<46; i++) {
        [tempArr addObject:[NSNumber numberWithInteger:i]];
    }
    
    NSMutableSet *setArr = [[NSMutableSet alloc]init];
    
    while ([setArr count]<6) {
        int r = arc4random() % [tempArr count];
        [setArr addObject:[tempArr objectAtIndex:r]];
    }
    NSArray *randomArray = [setArr allObjects];
    
    NSComparator finderSort = ^(id string1,id string2){
        
        if (string1 > string2) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (string1 < string2){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    _slotMachine.slotResults = [randomArray sortedArrayUsingComparator:finderSort];
    
    [_slotMachine startSliding];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    _startButton.highlighted = YES;
    [_startButton performSelector:@selector(setHighlighted:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.8];
    
    [self start];
}

#pragma mark - ZCSlotMachineDelegate

- (void)gg_slotMachineWillStartSliding:(GGSlotMachine *)slotMachine {
    _startImgV.userInteractionEnabled = NO;
    _startButton.enabled = NO;
}

- (void)gg_slotMachineDidEndSliding:(GGSlotMachine *)slotMachine {
    _startImgV.userInteractionEnabled = YES;
    _startButton.enabled = YES;
}

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)gg_iconsForSlotsInSlotMachine:(GGSlotMachine *)slotMachine {
    return self.slotIcons;
}

- (NSUInteger)gg_numberOfSlotsInSlotMachine:(GGSlotMachine *)slotMachine {
    return 6;
}
//在老虎机的宽度
- (CGFloat)gg_slotWidthInSlotMachine:(GGSlotMachine *)slotMachine {
    CGFloat WIDTH = (WINDOW_WIDTH-60)*0.8044/6;
    return WIDTH;
}

//在老虎机的间距
- (CGFloat)gg_slotSpacingInSlotMachine:(GGSlotMachine *)slotMachine {
    return 40.f;
}

//字典转字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *key = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return key;
}

@end
