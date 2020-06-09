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

@property (nonatomic, assign) CGPoint previousPoint1;
@property (nonatomic, assign) CGPoint previousPoint2;
@property (nonatomic, assign) CGPoint currentPoint;

@end


@implementation AZHandDrawView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
    }
    
    return self;
}


- (void)layoutSubviews {
    
    if (CGRectEqualToRect(self.imageView.frame, CGRectZero)) {
        self.imageView.frame = self.bounds;
    }
    
}


#pragma mark -

- (CGPoint)midPoint:(CGPoint)p1 p2:(CGPoint)p2 {
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    
}



#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    self.previousPoint1 = [touch previousLocationInView:self];
    self.previousPoint2 = [touch previousLocationInView:self];
    self.currentPoint = [touch locationInView:self];
    
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
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

@end
