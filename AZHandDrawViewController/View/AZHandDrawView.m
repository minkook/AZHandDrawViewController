//
//  AZHandDrawView.m
//  AZHandDrawViewController
//
//  Created by minkook yoo on 2020/06/09.
//  Copyright © 2020 minkook yoo. All rights reserved.
//

#import "AZHandDrawView.h"


@interface AZHandDrawView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *clearImage;

@property (nonatomic, assign) CGPoint previousPoint1;
@property (nonatomic, assign) CGPoint previousPoint2;
@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, strong) NSArray *commandHistory;
@property (nonatomic, assign) NSUInteger currentCommandIndex;

// Flag
@property (nonatomic, assign) BOOL isFlagFirstDraw;

@end


@implementation AZHandDrawView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.strokeWidth = 1.0;
        self.strokeColor = UIColor.redColor;
        self.lineCap = kCGLineCapRound;
        
        self.commandHistory = [NSArray new];
        
        self.maxHistoryCount = 10;
        
    }
    
    return self;
}


- (void)layoutSubviews {
    
    if (CGRectEqualToRect(self.imageView.frame, CGRectZero)) {
        self.imageView.frame = self.bounds;
    }
    
}



#pragma mark - Property

- (void)setMaxHistoryCount:(NSInteger)maxHistoryCount {
    _maxHistoryCount = MIN(maxHistoryCount, 100);
}



#pragma mark -

- (CGPoint)midPoint:(CGPoint)p1 p2:(CGPoint)p2 {
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    
}



#pragma mark - Execute Command History

- (void)executeCommandHistoryWithImage:(UIImage *)image {
    
    NSArray *array = self.commandHistory;
    if (0 < self.currentCommandIndex && self.currentCommandIndex < self.commandHistory.count - 1) {
        array = [array subarrayWithRange:NSMakeRange(0, self.currentCommandIndex + 1)];
    }
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    [mutableArray addObject:image];
    
    if (mutableArray.count > self.maxHistoryCount + 1) {
        [mutableArray removeObjectAtIndex:0];
    }
    
    self.commandHistory = [NSArray arrayWithArray:mutableArray];
    
    self.currentCommandIndex = self.commandHistory.count - 1;
    
}



#pragma mark - Undo & Redo

- (void)undo {
    
    // 예외처리
    if (self.currentCommandIndex <= 0) {
        return;
    }
    
    self.currentCommandIndex -= 1;
    
    self.imageView.image = self.commandHistory[self.currentCommandIndex];
    
}

- (void)redo {
    
    // 예외처리
    if (self.currentCommandIndex >= self.commandHistory.count - 1) {
        return;
    }
    
    self.currentCommandIndex += 1;
    
    self.imageView.image = self.commandHistory[self.currentCommandIndex];
    
}



#pragma mark - Clear

- (void)clear {
    
    if (self.commandHistory.count == 0) {
        return;
    }
    
    self.commandHistory = [NSArray new];
    
    self.currentCommandIndex = 0;
    
    self.imageView.image = self.clearImage;
    [self executeCommandHistoryWithImage:self.clearImage];
    
}



#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    self.previousPoint1 = [touch previousLocationInView:self];
    self.previousPoint2 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    if (!self.isFlagFirstDraw) {
        self.isFlagFirstDraw = YES;
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        self.clearImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self executeCommandHistoryWithImage:self.clearImage];
        
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    self.previousPoint2 = self.previousPoint1;
    self.previousPoint1 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1 = [self midPoint:self.previousPoint1 p2:self.previousPoint2];
    CGPoint mid2 = [self midPoint:self.currentPoint p2:self.previousPoint1];
    
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, self.previousPoint1.x, self.previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, self.lineCap);
    CGContextSetLineWidth(context, self.strokeWidth);
    
    CGFloat red, green, blue, alpha;
    [self.strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    
    CGContextStrokePath(context);
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self executeCommandHistoryWithImage:self.imageView.image];
    
}

@end
