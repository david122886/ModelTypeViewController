//
//  ModelTypeView.h
//  ModelpoupoTypeController
//
//  Created by xxsy-ima001 on 14-5-30.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
/** ModelTypeView
 *
 * 弹出输入框，位置在键盘之上，输入框随着输入的内容自动增加
 */
@interface ModelTypeView : UIView<UITextViewDelegate>
/**
 * @brief
 *
 * @param  tip 提示字符串
 *
 * @return inputString 输入的字符
 */
+(void)presentModelTypeViewParentViewController:(UIViewController *)parentController withTipString:(NSString*)tip withMaxTypeLength:(NSNumber*)maxLength withFinishedInput:(void (^)(NSString *inputString))finished withCancel:(void(^)())cancel;
@end
