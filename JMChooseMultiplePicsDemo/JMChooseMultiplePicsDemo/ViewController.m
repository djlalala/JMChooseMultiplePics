//
//  ViewController.m
//  JMChooseMultiplePicsDemo
//
//  Created by JiangMing on 15/9/5.
//  Copyright (c) 2015年 JiangMing. All rights reserved.
//

#import "ViewController.h"
#import "JMChooseMultiplePicsController.h"

@interface ViewController ()
- (IBAction)enterClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterClick:(UIButton *)sender {
    
    JMChooseMultiplePicsController *vc=[[JMChooseMultiplePicsController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
@end
