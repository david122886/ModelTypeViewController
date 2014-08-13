//
//  ModelTypeView.m
//  ModelpoupoTypeController
//
//  Created by xxsy-ima001 on 14-5-30.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ModelTypeView.h"
#define IOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.000)
#define IOS568 ([[UIScreen mainScreen] bounds].size.height >= 568)
#define INPUTVIEW_MAX_HEIGHT 200
#define kscreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kscreenWidth ([[UIScreen mainScreen] bounds].size.width)
@interface ModelTypeView()
@property (weak, nonatomic) IBOutlet UILabel *charNumberTipLabel;
@property (nonatomic,strong) UIWindow *presentWindow;
@property (nonatomic,strong) NSString * (^errorTipBlock)(NSString *inputString);
@property (nonatomic,strong) void(^finishedInput)(NSString *string);
@property (nonatomic,assign) BOOL isFinished;
@property (nonatomic,assign) int textViewContentHeight;
@property (nonatomic,strong) void(^cancel)();
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *backGroundButton;

@property (nonatomic,strong) NSString *tipString;
@property (nonatomic,strong) NSNumber *maxLength;
///是否是uitextfield风格,或者是uitextview风格,默认是uitextfield风格
@property (nonatomic,assign) BOOL isTextFieldType;
///已经输入的字符大小
@property (nonatomic,assign) int inTypeLength;
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

+(void)presentModelTypeViewParentViewController:(UIViewController *)parentController withIsTextFieldType:(BOOL)isTextFieldType returnErrorTipString:(NSString* (^)(NSString *inputString))errorTip withTipString:(NSString*)tip withMaxTypeLength:(NSNumber*)maxLength withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel{
    ModelTypeView *controller = [ModelTypeView defaultModelTypeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    controller.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    controller.textView.layer.borderWidth = 1;
    controller.textView.layer.cornerRadius = 5;
    controller.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    controller.inputBackView.backgroundColor = [UIColor whiteColor];
    controller.tipString = tip;
    controller.cancel = cancel;
    controller.finishedInput = finished;
    controller.errorTipBlock = errorTip;
    [controller.presentWindow setHidden:NO];
    controller.textView.text = @"";
    if (tip) {
        controller.tipLabel.text = tip;
    }else{
        controller.tipLabel.text = @"请输入:";
    }
    
    controller.frame = parentController.view.bounds;
    [parentController.view addSubview:controller];
    
    [controller.textView becomeFirstResponder];
    controller.maxLength = maxLength;
    controller.isTextFieldType = isTextFieldType;
    controller.charNumberTipLabel.text = [NSString stringWithFormat:@"0/%d字",maxLength.intValue];
    controller.inTypeLength = 0;
}

+(void)presentModelTypeViewParentViewController:(UIViewController *)parentController returnErrorTipString:(NSString* (^)(NSString *inputString))errorTip withTipString:(NSString*)tip withMaxTypeLength:(NSNumber*)maxLength withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel{
    ModelTypeView *controller = [ModelTypeView defaultModelTypeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:controller selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    controller.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    controller.textView.layer.borderWidth = 1;
    controller.textView.layer.cornerRadius = 5;
    controller.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    controller.inputBackView.backgroundColor = [UIColor whiteColor];
    controller.tipString = tip;
    controller.cancel = cancel;
    controller.finishedInput = finished;
    controller.errorTipBlock = errorTip;
    [controller.presentWindow setHidden:NO];
    controller.textView.text = @"";
    if (tip) {
        controller.tipLabel.text = tip;
    }else{
        controller.tipLabel.text = @"请输入:";
    }
    
    controller.frame = parentController.view.bounds;
    [parentController.view addSubview:controller];
    
    [controller.textView becomeFirstResponder];
    controller.maxLength = maxLength;
    controller.isTextFieldType = YES;
    controller.charNumberTipLabel.text = [NSString stringWithFormat:@"0/%d字",maxLength.intValue];
    controller.inTypeLength = 0;
}

#pragma mark uitextviewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]|| [text isEqualToString:@"\n"]) {
        return self.isTextFieldType?NO:YES;
    }
    
    if (self.inTypeLength >= self.maxLength.intValue && ![text isEqualToString:@""]) {
        return NO;
    }
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        if (CGRectGetHeight(self.inputBackView.frame) < INPUTVIEW_MAX_HEIGHT) {
            float height = textView.contentSize.height - self.textViewContentHeight;
            height = height > 0 ?height:0;
            self.textViewContentHeight = textView.contentSize.height;
            CGRect rect =self.inputBackView.frame;
            self.inputBackView.frame = (CGRect){rect.origin.x,rect.origin.y-height,rect.size.width,rect.size.height+height};
        }
    }else{
        if (CGRectGetHeight(self.inputBackView.frame) < INPUTVIEW_MAX_HEIGHT && CGRectGetMinY(self.inputBackView.frame) >=20) {
            float height = textView.contentSize.height - self.textViewContentHeight;
            height = height > 0 ?height:0;
            self.textViewContentHeight = textView.contentSize.height;
            CGRect rect =self.inputBackView.frame;
            self.inputBackView.frame = (CGRect){rect.origin.x,rect.origin.y-height,rect.size.width,rect.size.height+height};
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.markedTextRange == nil) {
        self.inTypeLength = textView.text.length;
        self.charNumberTipLabel.text = [NSString stringWithFormat:@"%d/%d字",self.inTypeLength,self.maxLength.intValue];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.textViewContentHeight = textView.contentSize.height;
}

#pragma mark --


-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        float height = IOS7?rect.size.height:rect.size.height+20;
        self.inputBackView.frame = (CGRect){0,kscreenHeight,CGRectGetWidth(self.frame),130};
        [UIView animateWithDuration:animationDuration animations:^{
            self.inputBackView.frame = (CGRect){0,kscreenHeight-height-CGRectGetHeight(self.inputBackView.frame),CGRectGetWidth(self.frame),self.inputBackView.frame.size.height};
        } completion:^(BOOL finished) {
            
        }];
    }else{
        float height = IOS7?rect.size.width:rect.size.width+20;
        self.inputBackView.frame = (CGRect){0,kscreenWidth,CGRectGetWidth(self.frame),130};
        [UIView animateWithDuration:animationDuration animations:^{
            self.inputBackView.frame = (CGRect){0,kscreenWidth-height-CGRectGetHeight(self.inputBackView.frame),CGRectGetWidth(self.frame),self.inputBackView.frame.size.height};
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.presentWindow setHidden:YES];
    self.presentWindow = nil;
    [UIView animateWithDuration:animationDuration animations:^{
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            self.inputBackView.frame = (CGRect){0,kscreenHeight,CGRectGetWidth(self.frame),130};
        }else{
            self.inputBackView.frame = (CGRect){0,kscreenWidth,CGRectGetWidth(self.frame),130};
        }
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tipLabel.text = self.tipString;
        self.textView.text = @"";
        self.inTypeLength = 0;
        self.charNumberTipLabel.text = [NSString stringWithFormat:@"0/%d字",self.maxLength.intValue];
    });
    if ([self.textView.text isEqualToString:@""]) {
        self.tipLabel.text = @"输入名称不能为空";
        return;
    }
    if (self.textView.text.length > self.maxLength.intValue) {
        self.tipLabel.text = [NSString stringWithFormat:@"输入名称长度不能超过%d个字符",self.maxLength.intValue];
        return;
    }
    
    if (self.errorTipBlock) {
        NSString *errorTipString = self.errorTipBlock(self.textView.text);
        if (errorTipString) {
            self.tipLabel.text = errorTipString;
            return;
        }
    }
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
