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
    
    self.handDrawView.maxHistoryCount = 20;
    
}



#pragma mark - Button Action

- (IBAction)undoButtonAction:(UIButton *)sender {
    [self.handDrawView undo];
}

- (IBAction)redoButtonAction:(UIButton *)sender {
    [self.handDrawView redo];
}

- (IBAction)clearButtonAction:(UIButton *)sender {
    [self.handDrawView clear];
}


@end
