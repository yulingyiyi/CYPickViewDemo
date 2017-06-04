//
//  HLPickView.h
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYPickView;
typedef void (^CYPickViewBlock)(NSString *str);

@interface CYPickView : UIView<UIPickerViewDelegate>




+ (void)showDateViewWithTitle:(NSString *)title cancel:(NSString *)cancel ok:(NSString *)ok block:(CYPickViewBlock)block;
+ (void)showDataViewWithItem:(NSArray *)items title:(NSString *)title  cancel:(NSString *)cancel ok:(NSString *)ok block:(CYPickViewBlock)block;

@end
