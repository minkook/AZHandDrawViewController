//
//  AZHandDrawView.h
//  AZHandDrawViewController
//
//  Created by minkook yoo on 2020/06/09.
//  Copyright © 2020 minkook yoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZHandDrawView : UIView


@property (nonatomic, assign) CGFloat strokeWidth;  // default is 1.

@property (nonatomic, strong) UIColor *strokeColor; // default is UIColor.redColor.

@property (nonatomic, assign) CGLineCap lineCap;    // default is kCGLineCapRound.


@end

NS_ASSUME_NONNULL_END
