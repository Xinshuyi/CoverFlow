//
//  ViewController.m
//  CoverFlow(透视collectionView)
//
//  Created by xin on 2016/11/12.
//  Copyright © 2016年 DogeEggEgg. All rights reserved.
//

#import "ViewController.h"
#import "CoverFlow.h"
#import "CZAdditions.h"
#import "CoverCell.h"
#define ImageNum 13
static NSString *cellID = @"gouzidan";
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载collectionView的图片
    for (int i = 1; i <= ImageNum; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d",i]];
        [self.images addObject:image];
    }
    
    // 1. 新建一个自定义流水布局 关于每个cell样式的设置代码都在里面
    CoverFlow *coverFlow = [[CoverFlow alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) collectionViewLayout:coverFlow];
    collectionView.backgroundColor = [UIColor blackColor];
    
    // 添加到根视图上
    [self.view addSubview:collectionView];
    
    // 设置数据源和代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    // 注册
    [collectionView registerClass:[CoverCell class] forCellWithReuseIdentifier:cellID];
    
    
    
    
}
// images 懒加载
- (NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

// 实现三个数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cz_randomColor];
    cell.image = self.images[indexPath.item];
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
