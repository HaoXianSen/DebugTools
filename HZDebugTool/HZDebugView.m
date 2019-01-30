//
//  HZDebugView.m
//  HZDebugTool
//
//  Created by harry on 2019/1/16.
//  Copyright © 2019 DangDang. All rights reserved.
//

#import "HZDebugView.h"

@interface HZDebugView()

/// fps
@property (nonatomic, weak) UILabel *fpsLabel;
/// memery
@property (nonatomic, weak) UILabel *memoryLabel;
/// cpu
@property (nonatomic, weak) UILabel *cpuLabel;
/// 关闭按钮
@property (nonatomic, weak) UIButton *closeButton;
@end

@implementation HZDebugView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    fpsLabel.text = @"FPS:0";
    fpsLabel.textColor = [UIColor colorWithHue:96.0/360.0 saturation:1.f brightness:0.9 alpha:1];
    [self addSubview:fpsLabel];
    _fpsLabel = fpsLabel;
    
    UILabel *memoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    memoryLabel.text = @"memory:0";
    memoryLabel.adjustsFontSizeToFitWidth = YES;
    memoryLabel.textColor = [UIColor colorWithHue:96.0/360.0 saturation:1 brightness:0.9 alpha:1];
    [self addSubview:memoryLabel];
    _memoryLabel = memoryLabel;
    
    UILabel *cpuLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    cpuLabel.text = @"cpu:0";
    cpuLabel.textColor = [UIColor colorWithHue:96.0/360.0 saturation:1 brightness:0.9 alpha:1];
    [self addSubview:cpuLabel];
    _cpuLabel = cpuLabel;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithHue:96.0/360.0 saturation:1 brightness:0.9 alpha:1] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    _closeButton = closeButton;
}

- (void)closeButtonClicked:(UIButton *)btn {
    if (self.closeBlock) self.closeBlock(btn);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (self.bounds.size.width-50) / 3.0;
    NSArray *tempArray = @[self.fpsLabel, self.memoryLabel, self.cpuLabel];
    [tempArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textAlignment = NSTextAlignmentCenter;
        obj.frame = CGRectMake(idx*width, 0, width, self.bounds.size.height);
    }];
    
    self.closeButton.frame = CGRectMake(self.bounds.size.width-50, 0, 50, self.bounds.size.height);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.superview];
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, point.y, frame.size.width, frame.size.height);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.superview];
    CGRect frame = self.frame;
    if (point.y < kNavigationHeight) {
        self.frame = CGRectMake(0, kNavigationHeight, frame.size.width, frame.size.height);
    } else if (point.y > self.superview.bounds.size.height-frame.size.height-(kIsIPhoneX?34:0)) {
        self.frame = CGRectMake(0, self.superview.bounds.size.height-frame.size.height-(kIsIPhoneX?34:0), frame.size.width, frame.size.height);
    } else {
        self.frame = CGRectMake(0, point.y, frame.size.width, frame.size.height);
    }
    
}


#pragma mark - setter
- (void)setFps:(CGFloat)fps {
    if (_fps != fps) {
        _fps = fps;
        self.fpsLabel.text = [NSString stringWithFormat:@"fps:%d", (int)fps];
        self.fpsLabel.textColor = [UIColor colorWithHue:(96.0/360.0)*(fps/60) saturation:1.f brightness:0.9 alpha:1];
    }
}

- (void)setMemory:(CGFloat)memory {
    if (_memory != memory) {
        _memory = memory;
        self.memoryLabel.text = [NSString stringWithFormat:@"memory:%.fM", memory];
    }
}

- (void)setCpu:(long)cpu {
    if (_cpu != cpu) {
        _cpu = cpu;
        self.cpuLabel.text = [NSString stringWithFormat:@"cpu:%ld%%", cpu];
    }
}
@end
