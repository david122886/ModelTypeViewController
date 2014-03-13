//
//  ModelTypeViewController.m
//  cjzyb_ios
//
//  Created by david on 14-3-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ModelTypeViewController.h"

@interface ModelTypeViewController ()
@property (nonatomic,strong) UIWindow *presentWindow;

@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)OKButtonClicked:(id)sender;

- (IBAction)backgroundClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

+(id)defaultModelTypeViewController;
@end

@implementation ModelTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+(id)defaultModelTypeViewController{
    static ModelTypeViewController *modelController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelController = [[ModelTypeViewController alloc] initWithNibName:@"ModelTypeViewController" bundle:nil];
    });
    modelController.presentWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    modelController.presentWindow.rootViewController = modelController;
    modelController.presentWindow.windowLevel = UIWindowLevelAlert;
    return modelController;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    float height = value.
    [UIView animateWithDuration:animationDuration animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OKButtonClicked:(id)sender {
}

- (IBAction)backgroundClicked:(id)sender {
    [self.textView resignFirstResponder];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.textView resignFirstResponder];
}


#pragma mark uitextviewDelegate

#pragma mark --
@end
