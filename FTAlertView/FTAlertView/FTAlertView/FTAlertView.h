//
//  FTAlertView.h
//  FTAlertView
//
//  Created by xiaodou on 2016/11/22.
//  Copyright © 2016 xiaodouxiaodou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTAlertView : UIView

@property (nonatomic, strong) NSArray *buttonTitles;                     /**< 设置按钮标题 若为nil则不显示按钮 */
@property (nonatomic, assign) CGFloat buttonHeight;                      /**< 设置按钮高度 */

@property (nonatomic, strong) UIColor *buttonTitleNormalColor;           /**< 设置按钮标题正常颜色 默认蓝色 */
@property (nonatomic, strong) UIColor *buttonTitleHighlightColor;        /**< 设置按钮标题高亮颜色 默认灰色 */
@property (nonatomic, assign) CGFloat buttonTitleFontSize;               /**< 设置按钮字体大小 默认15.0 */

@property (nonatomic, strong) UIColor *buttonBackgroundColor;                /**< 设置按钮背景颜色 */
@property (nonatomic, strong) UIImage *buttonBackgroundNormalImage;          /**< 设置按钮正常状态下背景图片 */
@property (nonatomic, strong) UIImage *buttonBackgroundHighlightImage;       /**< 设置按钮高亮状态下背景图片 */

/** 设置弹框大小 默认大小为0.8倍屏宽 高240 */
- (void)setAlertViewSize:(CGSize)size;

/** 自定义内容视图 */
- (void)customContentView:(UIView *)customView;

/** 显示弹框 */
- (void)show;

/** 按钮响应事件 */
- (void)clickButtonAction:(void(^)(NSInteger buttonIndex))block;

@end
