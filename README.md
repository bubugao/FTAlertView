# FTAlertView使用

![](https://github.com/bubugao/FTAlertView/raw/master/FTAlertView/FTAlertView/hehe.gif)

```
    FTAlertView *alertView = [[FTAlertView alloc] init];
    // 设置提醒框大小
    [alertView setAlertViewSize:CGSizeMake(0.8*CGRectGetWidth([UIScreen mainScreen].bounds), 150)];
    
    // 自定义提醒框内容视图
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
    customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [alertView customContentView:customView];
    
    // 设置对话框按钮 若不需要按钮 参数传nil即可
    [alertView setButtonTitles:@[@"Cancel",@"Next",@"OK"]];
    // 设置按钮高度 按钮可以自定义
    alertView.buttonHeight = 50.0;
    
    // 按钮点击事件响应 buttonIndex与数组titles索引一致
    [alertView clickButtonAction:^(NSInteger buttonIndex) {
        NSLog(@"---button %ld", buttonIndex);
    }];
    
    [alertView show];
```

