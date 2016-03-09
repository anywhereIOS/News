//
//  ViewController.m
//  简单模仿网易新闻滚动条
//
//  Created by 王涛 on 16/1/26.
//  Copyright © 2016年 304. All rights reserved.
//

#import "ViewController.h"
#import "WTNavController.h"
#import "WTOneViewController.h"
#import "WTTwoViewController.h"
#import "WTThreeViewController.h"
/**获取屏幕的宽度NSInteger*/
#define CurrentScreenWidth [UIScreen mainScreen].bounds.size.width
/**获取屏幕的高度NSInteger*/
#define CurrentScreenHeight [UIScreen mainScreen].bounds.size.height
#define pading 10
@interface ViewController ()<UIScrollViewDelegate>
/**
 *  滚动条
 */
@property (nonatomic,strong) UIScrollView *topScrollView;
/**
 *  按钮的容器
 */
@property (nonatomic,strong) UIView *btnView;
/**
 *  内容控制器的scrollView
 */
@property (nonatomic,strong) UIScrollView *contentScrollView;
/**
 *  临时变量
 */
@property (nonatomic,assign) CGFloat tempW;
/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;
/**
 *  控制器
 */
@property (nonatomic,strong) WTOneViewController *one;
@property (nonatomic,strong) WTTwoViewController *two;
@property (nonatomic,strong) WTThreeViewController *three;

@property (nonatomic,strong) NSMutableArray *btnArray;


@end

@implementation ViewController
/**
 *  懒加载,控制器
 */
-(WTOneViewController *)one
{
    if (_one == nil) {
        _one = [[WTOneViewController alloc] init];
        _one.view.frame = CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight);
        _one.view.clipsToBounds = YES;
    }
    return _one;
}
-(WTTwoViewController *)two
{
    if (_two == nil) {
        _two = [[WTTwoViewController alloc] init];
        _two.view.frame = CGRectMake(CurrentScreenWidth, 0, CurrentScreenWidth, CurrentScreenHeight);
        _two.view.clipsToBounds = YES;
    }
    return _two;
}
-(WTThreeViewController *)three
{
    if (_three == nil) {
        _three = [[WTThreeViewController alloc] init];
        _three.view.frame = CGRectMake(CurrentScreenWidth*2, 0, CurrentScreenWidth, CurrentScreenHeight);
        _three.view.clipsToBounds = YES;
    }
    return _three;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网易新闻";
    self.view.backgroundColor = [UIColor whiteColor];

    //创建头部的滚动条
    [self creatTopScrollView];
    //创建按钮
    [self creatBtn];
    //创建内容滚动容器
    [self creatContentScrollView];
}
/**
 *  创建头部的滚动条
 */
-(void)creatTopScrollView
{
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.frame = CGRectMake(0, 64, CurrentScreenWidth,30);
    self.topScrollView.contentSize = CGSizeMake(17*28 + 15*pading, 30);
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.bounces = YES;
    self.topScrollView.pagingEnabled = NO;
    self.topScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.topScrollView];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18*28+15*pading, 30)];
    self.btnView = btnView;
    [self.topScrollView addSubview:btnView];
}
/**
 *  创建按钮添加到scrollView
 */
-(void)creatBtn
{
    self.btnArray = [NSMutableArray array];
    int i = 0;
    NSArray *titleArray = @[@"头条",@"热点",@"体育",@"北京",@"订阅",@"财经",@"科技",@"汽车",@"时尚",@"图片",@"跟帖",@"房产",@"直播",@"轻松一刻",@"军事",@"历史"];
    for (NSString *title in titleArray) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(i*pading + _tempW, 0, 50, 50);
        [btn setTitle:title forState:UIControlStateNormal];
        btn.tag = i;
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn sizeToFit];
        [self.btnArray addObject:btn];
        _tempW += btn.frame.size.width;
        [self.btnView addSubview:btn];
        i++;
        if (btn.tag == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        }
    }
}
/**
 *  创建内容滚动容器
 */
-(void)creatContentScrollView
{
    //创建内容scrollView
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.frame = CGRectMake(0, 0, CurrentScreenWidth, CurrentScreenHeight);
    self.contentScrollView.contentSize = CGSizeMake(CurrentScreenWidth*3, CurrentScreenHeight);
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
    [self.view insertSubview:self.contentScrollView belowSubview:self.topScrollView];
    self.contentScrollView.delegate = self;
    //注册控制器
    [self configSonViewController];
}
-(void)titleBtnClick:(UIButton *)btn
{
    if (btn.frame.origin.x > 0.5*CurrentScreenWidth) {
        CGFloat contentOffSetX = btn.center.x - 0.5*CurrentScreenWidth;
        self.topScrollView.contentOffset = CGPointMake(contentOffSetX, 0);
    }else{
        self.topScrollView.contentOffset = CGPointMake(0, 0);
    }
    if (btn!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        btn.selected = YES;
        self.selectedBtn = btn;
    }else{
        self.selectedBtn.selected = YES;
    }
    [btn sizeToFit];
    switch (btn.tag) {
        case 0:
            self.contentScrollView.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            self.contentScrollView.contentOffset = CGPointMake(CurrentScreenWidth, 0);
            break;
        case 2:
            self.contentScrollView.contentOffset = CGPointMake(CurrentScreenWidth*2, 0);
            break;
            
        default:
            break;
    }
}
-(void)configSonViewController
{
    [self.contentScrollView addSubview:self.one.view];
    [self.contentScrollView addSubview:self.two.view];
    [self.contentScrollView addSubview:self.three.view];
    
    [self addChildViewController:self.one];
    [self addChildViewController:self.two];
    [self addChildViewController:self.three];
    
}
#pragma mark - scrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.contentScrollView.contentOffset.x == 0) {
        self.selectedBtn.selected = NO;
        self.selectedBtn = self.btnArray[0];
        self.selectedBtn.selected = YES;
    }else if (self.contentScrollView.contentOffset.x == CurrentScreenWidth){
        self.selectedBtn.selected = NO;
        self.selectedBtn = self.btnArray[1];
        self.selectedBtn.selected = YES;
    }else{
        self.selectedBtn.selected = NO;
        self.selectedBtn = self.btnArray[2];
        self.selectedBtn.selected = YES;
        
    }
    
}
@end
