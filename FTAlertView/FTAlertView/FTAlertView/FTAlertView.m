//
//  FTAlertView.m
//  FTAlertView
//
//  Created by xiaodou on 2016/11/22.
//  Copyright © 2016 xiaodouxiaodou. All rights reserved.
//

#import "FTAlertView.h"

const CGFloat kAnimationTime = 0.2f;

@interface FTAlertView () {
    CGFloat kScreenWidth;     /**< 屏幕宽度 */
    CGFloat kScreenHeight;    /**< 屏幕高度 */
    
    CGFloat dialogWidth;      /**< 整个对话框视图 宽度 */
    CGFloat dialogHeight;     /**< 整个对话框视图 高度 */
    
    CGFloat contentHeight;    /**< 自定义内容显示视图 高度 */
    CGFloat interactHeight;   /**< 自定义交互视图 高度 */
}

@property (nonatomic, strong) UIView *dialogView;     /**< 整个对话框视图 */
@property (nonatomic, strong) UIView *contentView;    /**< 自定义内容显示视图 */
@property (nonatomic, strong) UIView *interactView;   /**< 自定义交互视图 比如按钮 */

@property (nonatomic, copy) void(^clickBlock)(NSInteger buttonIndex);   /**< 按钮点击事件响应Block */

@end

@implementation FTAlertView

- (instancetype)init {
    if (self = [super init]) {
        kScreenWidth = [UIScreen mainScreen].bounds.size.width;
        kScreenHeight = [UIScreen mainScreen].bounds.size.height;
        contentHeight = 200;     // 内容视图高度 宽度与父视图一致
        interactHeight = 40;     // 交互视图高度 宽度与父视图一致
        
        dialogWidth = 0.8*kScreenWidth;                  // 对话框默认宽度
        dialogHeight = contentHeight + interactHeight;   // 对话框默认高度
        _buttonTitles = @[@"Close"];                     // 交互视图默认一个按钮
        _buttonHeight = interactHeight;                  // 初始按钮高度
        
    }
    return self;
}

#pragma mark - public

/** 设置弹框大小 默认大小为0.8倍屏宽 高240 */
- (void)setAlertViewSize:(CGSize)size {
    dialogWidth = size.width;
    dialogHeight = size.height;
    contentHeight = dialogHeight - interactHeight;
}

/** 自定义内容视图 */
- (void)customContentView:(UIView *)customView {
    _contentView = customView;
}

/** 显示弹框 */
- (void)show {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    [self addSubview:self.dialogView];
    [self.dialogView addSubview:self.contentView];
    [self.dialogView addSubview:self.interactView];
    [self addButtonsToInteractionView];
    
    _dialogView.layer.transform = CATransform3DMakeScale(0.6f, 0.6f, 1.0f);
    _dialogView.alpha = 0;
    
    [UIView animateWithDuration:kAnimationTime delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
        _dialogView.alpha = 1.0f;
    } completion:nil];
}

/** 按钮响应事件 */
- (void)clickButtonAction:(void(^)(NSInteger buttonIndex))block {
    _clickBlock = block;
}

#pragma mark - set

/** 设置按钮标题 若为nil则不显示按钮 */
- (void)setButtonTitles:(NSArray *)buttonTitles {
    _buttonTitles = buttonTitles;
    
    if (buttonTitles == nil || [buttonTitles isEqual:NULL]) {
        interactHeight = 0;
        contentHeight = dialogHeight - interactHeight;
        
        // 若没有按钮则用点击其他地方让弹框消失
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:tap];
        [tap addTarget:self action:@selector(dismiss)];
        return;
    }
}

/** 设置按钮标题高度 */
- (void)setButtonHeight:(CGFloat)buttonHeight {
    _buttonHeight = buttonHeight;
    
    if (_buttonTitles) {
        if (_buttonHeight != interactHeight) {
            interactHeight = _buttonHeight;
            contentHeight = dialogHeight - interactHeight;
        }
    }
}

#pragma mark - get

- (UIView *)dialogView {
    if (_dialogView == nil) {
        CGFloat dialogY = kScreenHeight/2 - (contentHeight + interactHeight)/2;
        _dialogView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-dialogWidth)/2, dialogY, dialogWidth, dialogHeight)];
        _dialogView.backgroundColor = [UIColor clearColor];
        _dialogView.layer.cornerRadius = 6.0;
        _dialogView.layer.masksToBounds = YES;
    }
    return _dialogView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dialogWidth, contentHeight)];
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _contentView;
}

- (UIView *)interactView {
    if (_interactView == nil) {
        _interactView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight, dialogWidth, interactHeight)];
        _interactView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dialogWidth, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_interactView addSubview:lineView];
    }
    return _interactView;
}

#pragma mark - private

/** 将按钮添加在交互视图上 */
- (void)addButtonsToInteractionView {
    CGFloat buttonWidth = dialogWidth / _buttonTitles.count;
    
    for (int i=0; i<_buttonTitles.count; i++) {
        
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.frame = CGRectMake(i * buttonWidth, interactHeight - _buttonHeight, buttonWidth, _buttonHeight);
        closeButton.tag = i;
        [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        closeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        closeButton.layer.borderWidth = 0.25;
        [self customButton:closeButton];            // 外部自定义按钮
        [_interactView addSubview:closeButton];
        
        [closeButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 自定义按钮 */
- (void)customButton:(UIButton *)button {
    if (self.buttonTitleNormalColor) {
        [button setTitleColor:_buttonTitleNormalColor forState:UIControlStateNormal];
    }
    if (self.buttonTitleHighlightColor) {
        [button setTitleColor:_buttonTitleHighlightColor forState:UIControlStateHighlighted];
    }
    if (self.buttonTitleFontSize) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:_buttonTitleFontSize]];
    }
    
    if (self.buttonBackgroundColor) {
        button.backgroundColor = _buttonBackgroundColor;
    }
    if (self.buttonBackgroundNormalImage) {
        [button setBackgroundImage:_buttonBackgroundNormalImage forState:UIControlStateNormal];
    }
    if (self.buttonBackgroundHighlightImage) {
        [button setBackgroundImage:_buttonBackgroundHighlightImage forState:UIControlStateHighlighted];
    }
}

#pragma mark - action

- (void)clickButton:(UIButton *)button {
    if (_clickBlock) {
        _clickBlock(button.tag);
    }
    [self dismiss];
}

- (void)dismiss {
    CATransform3D currentTransform = _dialogView.layer.transform;
    _dialogView.alpha = 1.0f;
    [UIView animateWithDuration:kAnimationTime delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0f));
                         _dialogView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

@end
