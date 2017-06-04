//
//  HLPickView.m
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import "CYPickView.h"
#define SCREENSIZE UIScreen.mainScreen.bounds.size
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHieght  [UIScreen mainScreen].bounds.size.height
#define kH  250
@interface CYPickView ()
{
    UIView *_backgroundView;
    UIView * _actionSheetView;
     NSString *selectedStr;
    NSArray *proTitleList;
}
@property (assign) BOOL isDate;;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic,copy) CYPickViewBlock block;
@end

@implementation CYPickView
- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80 ,29.5)];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_leftBtn setBackgroundColor:[UIColor whiteColor]];
         _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];;
        [_leftBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftBtn;
}

- (UIButton *)rightBtn{

    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 80, 0, 80 ,29.5)];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor whiteColor]];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_rightBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)titleL{

    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, SCREENSIZE.width - 160, 29.5)];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [UIColor darkTextColor];

        _titleL.backgroundColor = [UIColor whiteColor];
        _titleL.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    }
    return _titleL;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.alpha = 1.0;
        _actionSheetView.frame =  CGRectMake(0, kHieght - kH, self.frame.size.width, kH);
    }];

}
- (void)hide
{
    [UIView animateWithDuration:0.35 animations:^{
        _backgroundView.alpha = 0;
        _actionSheetView.frame =  CGRectMake(0, kHieght, self.frame.size.width, kH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _block = nil;
    }];
}
- (void)initSubviews{
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHieght)];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    _backgroundView.alpha = 0;
    [self addSubview:_backgroundView];
    
    _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, kHieght, kWidth, kH)];
    _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _actionSheetView.backgroundColor = [UIColor lightTextColor];
    [_actionSheetView addSubview:self.leftBtn];
    [_actionSheetView addSubview:self.rightBtn];
    [_actionSheetView addSubview:self.titleL];
    [self addSubview:_actionSheetView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_backgroundView];
    if (!CGRectContainsPoint(_actionSheetView.frame, point)) {
        [self hide];
    }
}
- (instancetype)initWithTitle:(NSString *)title item:(NSArray *)items cancel:(NSString *)cancel ok:(NSString *)ok block:(CYPickViewBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, SCREENSIZE.height)];
    if (self) {
    
        _block = block;
        [self initSubviews];
        if (items) {
            _isDate = YES;
            proTitleList = items;
            UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, SCREENSIZE.width, 270)];
            
            pick.delegate = self;
            pick.backgroundColor = [UIColor whiteColor];
            [_actionSheetView addSubview:pick];
        }else{
            // 1.日期Picker
            _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, SCREENSIZE.width, 270)];
            _datePicker.backgroundColor = [UIColor whiteColor];
            // 1.1选择datePickr的显示风格
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            
            // 1.2查询所有可用的地区
            //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
            
            // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文
            [_datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
            
            // 1.4监听datePickr的数值变化
            [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            
            NSDate *date = [NSDate date];
            
            // 2.3 将转换后的日期设置给日期选择控件
            [_datePicker setDate:date];
  
            [_actionSheetView addSubview:_datePicker];
        
        }
        
        if (title && title.length > 0) {
            _titleL.text = title;
        }
        if (cancel && cancel.length) {
            [_leftBtn setTitle:cancel forState:UIControlStateNormal];
        }
        if (ok && ok.length) {
            [_rightBtn setTitle:ok forState:UIControlStateNormal];
        }
    }
    return self;
}


+ (void)showDateViewWithTitle:(NSString *)title cancel:(NSString *)cancel ok:(NSString *)ok block:(CYPickViewBlock)block
{
    CYPickView *pick = [[self alloc] initWithTitle:title item:nil cancel:cancel ok:ok block:block];
    pick.isDate = YES;
    [pick show];
    
}
+ (void)showDataViewWithItem:(NSArray *)items title:(NSString *)title cancel:(NSString *)cancel ok:(NSString *)ok block:(CYPickViewBlock)block
{
    CYPickView *pick = [[self alloc] initWithTitle:title item:items cancel:cancel ok:ok block:block];
    pick.isDate = NO;
    
    [pick show];
}
#pragma mark DatePicker监听方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    
    // 1.要转换日期格式, 必须得用到NSDateFormatter, 专门用来转换日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 1.1 先设置日期的格式字符串
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 1.2 使用格式字符串, 将日期转换成字符串
    selectedStr = [formatter stringFromDate:datePicker.date];
}
- (void)cancel:(UIButton *)btn
{
    [self hide];
    
}
- (void)submit:(UIButton *)btn
{
    NSString *pickStr = selectedStr;
    if (!pickStr || pickStr.length == 0) {
        if(_isDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            pickStr = [formatter stringFromDate:[NSDate date]];
        } else {
            if([proTitleList count] > 0) {
                pickStr = proTitleList[0];
            }
        }
    }
    if (_block) {
        _block(pickStr);
    }
    [self hide];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [proTitleList count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedStr = [proTitleList objectAtIndex:row];
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [proTitleList objectAtIndex:row];

}
- (UIColor *)getColor:(NSString*)hexColor

{
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}

- (CGSize)workOutSizeWithStr:(NSString *_Nonnull)str andFont:(NSInteger)fontSize value:(NSValue *)value{
    CGSize size;
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    return size;
}
@end

