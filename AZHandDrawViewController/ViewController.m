//
//  ViewController.m
//  AZHandDrawViewController
//
//  Created by minkook yoo on 2020/06/09.
//  Copyright © 2020 minkook yoo. All rights reserved.
//

#import "ViewController.h"
#import "AZHandDrawView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet AZHandDrawView *handDrawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.handDrawView.strokeWidth = 2.0;
    
    self.handDrawView.strokeColor = UIColor.purpleColor;
    
    self.handDrawView.lineCap = kCGLineCapRound;
    
}


@end
