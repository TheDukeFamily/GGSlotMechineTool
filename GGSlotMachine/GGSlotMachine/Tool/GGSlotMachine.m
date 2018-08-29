//
//  LCSlotMachine.m
//  LCLuckyCoffee
//
//  Created by Mac on 2017/11/11.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GGSlotMachine.h"

static BOOL isSliding = NO;
static const NSUInteger kMinTurn = 3;

@interface GGSlotMachine()
{
    UIEdgeInsets _contentInset;
    NSArray *_slotResults;
    __weak id<GGSlotMachineDataSource> _dataSource;
}
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *slotScrollLayerArray;
@property (nonatomic, strong) NSArray *currentSlotResults;

@end

@implementation GGSlotMachine

- (NSMutableArray *)slotScrollLayerArray{
    if (!_slotScrollLayerArray) {
        _slotScrollLayerArray = [NSMutableArray array];
    }
    return _slotScrollLayerArray;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_backgroundImageView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:_contentView];
        
        _coverImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_coverImageView];
        
        self.singleUnitDuration = 0.01f;
        
        _contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

#pragma mark -

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImageView.image = backgroundImage;
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImageView.image = coverImage;
}

- (NSArray *)slotResults {
    return _slotResults;
}

- (void)setSlotResults:(NSArray *)slotResults {
    if (!isSliding) {
        _slotResults = slotResults;
        
        if (!_currentSlotResults) {
            NSMutableArray *currentSlotResults = [NSMutableArray array];
            for (int i = 0; i < [slotResults count]; i++) {
                [currentSlotResults addObject:[NSNumber numberWithUnsignedInteger:0]];
            }
            _currentSlotResults = [NSArray arrayWithArray:currentSlotResults];
        }
    }
}

- (id<GGSlotMachineDataSource>)dataSource {
    return _dataSource;
}

- (void)setDataSource:(id<GGSlotMachineDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

- (void)reloadData {
    if (self.dataSource) {
        for (CALayer *containerLayer in _contentView.layer.sublayers) {
            [containerLayer removeFromSuperlayer];
        }
        
        NSUInteger numberOfSlots = [self.dataSource gg_numberOfSlotsInSlotMachine:self];
        CGFloat slotSpacing = 0;
        //老虎机间距的代理
        if ([self.dataSource respondsToSelector:@selector(gg_slotSpacingInSlotMachine:)]) {
            slotSpacing = [self.dataSource gg_slotSpacingInSlotMachine:self];
        }
        
        CGFloat slotWidth = _contentView.frame.size.width / numberOfSlots;
        
        if ([self.dataSource respondsToSelector:@selector(gg_slotWidthInSlotMachine:)]) {
            slotWidth = [self.dataSource gg_slotWidthInSlotMachine:self];
        }
        
        for (int i = 0; i < numberOfSlots; i++) {
            CALayer *slotContainerLayer = [[CALayer alloc] init];
            //设置单个控件的位置
            slotContainerLayer.frame = CGRectMake(i * slotWidth + _contentView.frame.size.width*0.0599, -_contentView.frame.size.height*0.48, slotWidth, _contentView.frame.size.height);
            slotContainerLayer.masksToBounds = YES;
            
            CALayer *slotScrollLayer = [[CALayer alloc] init];
            slotScrollLayer.frame = CGRectMake(0, 0, slotWidth, _contentView.frame.size.height);
            
            [slotContainerLayer addSublayer:slotScrollLayer];
            
            
            [_contentView.layer addSublayer:slotContainerLayer];
            
            [self.slotScrollLayerArray addObject:slotScrollLayer];
        }
        
        CGFloat singleUnitHeight = _contentView.frame.size.height / 3;
        
        NSArray *slotIcons = [self.dataSource gg_iconsForSlotsInSlotMachine:self];
        NSUInteger iconCount = [slotIcons count];
        
        for (int i = 0; i < numberOfSlots; i++) {
            CALayer *slotScrollLayer = [self.slotScrollLayerArray objectAtIndex:i];
            NSInteger scrollLayerTopIndex = - (i + kMinTurn + 3) * iconCount;
            
            for (int j = 0; j > scrollLayerTopIndex; j--) {
                UIImage *iconImage = [slotIcons objectAtIndex:abs(j) % iconCount];
                CALayer *iconImageLayer = [[CALayer alloc] init];
                // adjust the beginning offset of the first unit
                NSInteger offsetYUnit = j + 1 + iconCount;
                iconImageLayer.frame = CGRectMake(0, offsetYUnit * singleUnitHeight, slotScrollLayer.frame.size.width, singleUnitHeight);
                
                iconImageLayer.contents = (id)iconImage.CGImage;
                iconImageLayer.contentsScale = iconImage.scale;
                iconImageLayer.contentsGravity = kCAGravityCenter;
                
                [slotScrollLayer addSublayer:iconImageLayer];
            }
        }
    }
}

#pragma mark - start

- (void)startSliding {
    
    if (isSliding) {
        return;
    }
    else {
        isSliding = YES;
        
        if ([self.delegate respondsToSelector:@selector(gg_slotMachineWillStartSliding:)]) {
            [self.delegate gg_slotMachineWillStartSliding:self];
        }
        
        NSArray *slotIcons = [self.dataSource gg_iconsForSlotsInSlotMachine:self];
        NSUInteger slotIconsCount = [slotIcons count];
        
        __block NSMutableArray *completePositionArray = [NSMutableArray array];
        
        [CATransaction begin];
        
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            isSliding = NO;
            
            if ([self.delegate respondsToSelector:@selector(gg_slotMachineDidEndSliding:)]) {
                [self.delegate gg_slotMachineDidEndSliding:self];
            }
            
            for (int i = 0; i < [self.slotScrollLayerArray count]; i++) {
                CALayer *slotScrollLayer = [self.slotScrollLayerArray objectAtIndex:i];
                
                slotScrollLayer.position = CGPointMake(slotScrollLayer.position.x, ((NSNumber *)[completePositionArray objectAtIndex:i]).floatValue);
                
                NSMutableArray *toBeDeletedLayerArray = [NSMutableArray array];
                
                NSUInteger resultIndex = [[self.slotResults objectAtIndex:i] unsignedIntegerValue];
                NSUInteger currentIndex = [[self.currentSlotResults objectAtIndex:i] unsignedIntegerValue];
                
                for (int j = 0; j < slotIconsCount * (kMinTurn + i) + resultIndex - currentIndex; j++) {
                    CALayer *iconLayer = [slotScrollLayer.sublayers objectAtIndex:j];
                    [toBeDeletedLayerArray addObject:iconLayer];
                }
                
                for (CALayer *toBeDeletedLayer in toBeDeletedLayerArray) {
                    // use initWithLayer does not work
                    CALayer *toBeAddedLayer = [CALayer layer];
                    toBeAddedLayer.frame = toBeDeletedLayer.frame;
                    toBeAddedLayer.contents = toBeDeletedLayer.contents;
                    toBeAddedLayer.contentsScale = toBeDeletedLayer.contentsScale;
                    toBeAddedLayer.contentsGravity = toBeDeletedLayer.contentsGravity;
                    
                    CGFloat shiftY = slotIconsCount * toBeAddedLayer.frame.size.height * (kMinTurn + i + 3);
                    toBeAddedLayer.position = CGPointMake(toBeAddedLayer.position.x, toBeAddedLayer.position.y - shiftY);
                    
                    [toBeDeletedLayer removeFromSuperlayer];
                    [slotScrollLayer addSublayer:toBeAddedLayer];
                }
                toBeDeletedLayerArray = [NSMutableArray array];
            }
            
            self.currentSlotResults = self.slotResults;
            completePositionArray = [NSMutableArray array];
        }];
        
        static NSString * const keyPath = @"position.y";
        
        for (int i = 0; i < [self.slotScrollLayerArray count]; i++) {
            CALayer *slotScrollLayer = [self.slotScrollLayerArray objectAtIndex:i];
            
            NSUInteger resultIndex = [[self.slotResults objectAtIndex:i] unsignedIntegerValue];
            NSUInteger currentIndex = [[_currentSlotResults objectAtIndex:i] unsignedIntegerValue];
            
            NSUInteger howManyUnit = (i + kMinTurn) * slotIconsCount + resultIndex - currentIndex;
            CGFloat slideY = howManyUnit * (_contentView.frame.size.height / 3);
            
            CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
            slideAnimation.fillMode = kCAFillModeForwards;
            slideAnimation.duration = howManyUnit * self.singleUnitDuration;
            slideAnimation.toValue = [NSNumber numberWithFloat:slotScrollLayer.position.y + slideY];
            slideAnimation.removedOnCompletion = NO;
            
            [slotScrollLayer addAnimation:slideAnimation forKey:@"slideAnimation"];
            
            [completePositionArray addObject:slideAnimation.toValue];
        }
        
        [CATransaction commit];
    }
}
@end
