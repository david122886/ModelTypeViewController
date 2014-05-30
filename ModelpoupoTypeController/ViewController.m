//
//  ViewController.m
//  ModelpoupoTypeController
//
//  Created by david on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ViewController.h"
#import "ModelTypeViewController.h"
@interface ViewController ()
- (IBAction)clickedBt:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedBt:(id)sender {
    [ModelTypeViewController presentTypeViewWithTipString:@"请输入" withMaxTypeLength:@(5) withFinishedInput:^(NSString *inputString) {
        
    } withCancel:^{
        
    }];
}
@end
