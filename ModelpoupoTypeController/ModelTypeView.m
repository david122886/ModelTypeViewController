//
//  ModelTypeView.m
//  ModelpoupoTypeController
//
//  Created by xxsy-ima001 on 14-5-30.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ModelTypeView.h"
#define INPUTVIEW_MAX_HEIGHT 300
#define kscreenHeight ([[UIScreen mainScreen] bounds].size.height)
@interface ModelTypeView()
@property (nonatomic,strong) UIViewController *controller;
@property (weak, nonatomic) IBOutlet UILabel *charNumberTipLabel;
@property (nonatomic,strong) UIWindow *presentWindow;
@property (nonatomic,strong) void(^finishedInput)(NSString *string);
@property (nonatomic,assign) BOOL isFinished;
@property (nonatomic,assign) int textViewContentHeight;
@property (nonatomic,strong) void(^cancel)();
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *backGroundButton;

@property (nonatomic,strong) NSNumber *maxLength;
- (IBAction)OKButtonClicked:(id)sender;

- (IBAction)backgroundClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
+(id)defaultModelTypeView;
@end
@implementation ModelTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)defaultModelTypeView{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ModelTypeView_iphone" owner:self options:nil];
    return array[0];
}
+(void)presentModelTypeViewParentViewController:(UIViewController *)parentController withTipString:(NSString*)tip withMaxTypeLength:(NSNumber*)maxLength withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel{
    ModelTypeView *controller = [ModelTypeView defaultModelTypeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    controller.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    controller.textView.layer.borderWidth = 1;
    controller.textView.layer.cornerRadius = 5;
    controller.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    controller.inputBackView.backgroundColor = [UIColor whiteColor];
    
    controller.controller = parentController;
    controller.cancel = cancel;
    controller.finishedInput = finished;
    [controller.presentWindow setHidden:NO];
    controller.textView.text = @"";
    if (tip) {
        controller.tipLabel.text = tip;
    }else{
        controller.tipLabel.text = @"请输入:";
    }
    
    controller.frame = [[UIScreen mainScreen] bounds];
    [controller.controller.view addSubview:controller];
    
    [controller.textView becomeFirstResponder];
    controller.maxLength = maxLength;
    controller.charNumberTipLabel.text = [NSString stringWithFormat:@"0/%d",maxLength.integerValue];
}
#pragma mark uitextviewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@ >>>>%@>>",textView.text,text);
    if ([text isEqualToString:@" "]|| [text isEqualToString:@"\n"]) {
        return NO;
    }
    if (CGRectGetHeight(self.inputBackView.frame) < INPUTVIEW_MAX_HEIGHT) {
        float height = textView.contentSize.height - self.textViewContentHeight-9;
        height = height > 0 ?height:0;
        self.textViewContentHeight = textView.contentSize.height;
        CGRect rect =self.inputBackView.frame;
        self.inputBackView.frame = (CGRect){rect.origin.x,rect.origin.y-height,rect.size.width,rect.size.height+height};
    }
    if ([text isEqualToString:@""]) {
        self.charNumberTipLabel.text = [NSString stringWithFormat:@"%d/%d",textView.text.length <= 0?0:textView.text.length-1,self.maxLength.intValue];
    }else{
        self.charNumberTipLabel.text = [NSString stringWithFormat:@"%d/%d",textView.text.length >= self.maxLength.integerValue ?self.maxLength.integerValue:textView.text.length+1,self.maxLength.intValue];
    }
    if (!self.maxLength) {
        return YES;
    }else{
        if (textView.text.length >= self.maxLength.intValue) {
            if ([text isEqualToString:@""]) {
                return YES;
            }
            return NO;
        }else{
            return YES;
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textViewContentHeight = textView.contentSize.height;
}
#pragma mark --


-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float height = rect.size.height;
    self.inputBackView.frame = (CGRect){0,kscreenHeight,CGRectGetWidth(self.frame),120};
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,kscreenHeight-height-CGRectGetHeight(self.inputBackView.frame),CGRectGetWidth(self.frame),self.inputBackView.frame.size.height};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.presentWindow setHidden:YES];
    self.presentWindow = nil;
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,kscreenHeight,CGRectGetWidth(self.frame),120};
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
        self.controller = nil;
        if (self.isFinished) {
            if (self.finishedInput) {
                self.finishedInput(self.textView.text);
            }
        }else{
            if (self.cancel) {
                self.cancel();
            }
        }
    }];
}

- (IBAction)OKButtonClicked:(id)sender {
    self.isFinished = YES;
    [self.textView resignFirstResponder];
}

- (IBAction)backgroundClicked:(id)sender {
    self.isFinished = NO;
    [self.textView resignFirstResponder];
}

- (IBAction)cancelButtonClicked:(id)sender {
    self.isFinished = NO;
    [self.textView resignFirstResponder];
}

@end
