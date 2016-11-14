//
//  CoverFlow.m
//  CoverFlow(透视collectionView)
//
//  Created by xin on 2016/11/12.
//  Copyright © 2016年 DogeEggEgg. All rights reserved.
//

#import "CoverFlow.h"

@implementation CoverFlow
- (void)prepareLayout{
    // 设置布局 水平方向移动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置每个item的大小 间距
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width * 0.45, self.collectionView.bounds.size.height * 0.85);
    self.minimumLineSpacing = 30;
    
    // 取消
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 增加组内间距 增加第一个item左边和最后一个item右边的内间距
    self.sectionInset = UIEdgeInsetsMake(0, (self.collectionView.bounds.size.width - self.itemSize.width)/2, 0, (self.collectionView.bounds.size.width - self.itemSize.width)/2);
}

// 设置每个item的布局对象
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 取得系统的布局对象们
    NSArray *superArr = [super layoutAttributesForElementsInRect:rect];
    
    // 解决输出问题
    NSArray *layoutArr = [[NSArray alloc]initWithArray:superArr copyItems:YES];
    
    
    // 遍历item们的布局对象们 依次修改item的布局
    for (UICollectionViewLayoutAttributes *attribute in layoutArr) {
        
        // 1. 先解决item的大小 先求出每个item离collection的距离 距离越近 item就越大
        // item距离屏幕中心
        CGFloat itemCenterX = attribute.center.x;
        
        // collection的中线点
        CGFloat collectionCenterX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2;
        
        // item距离view的距离
        CGFloat distance = ABS( itemCenterX - collectionCenterX );
        
        // item放大缩小比例
        CGFloat ratio = 1 - 0.002 * distance;
        
        // 创建一个catransform3D
        CATransform3D transform = CATransform3DIdentity;
        
        // 进行缩放
        transform = CATransform3DScale(transform, ratio, ratio, 1);
//        transform = CATransform3DMakeScale(ratio, ratio, 1);
        
        // 修改 m34 值 有灭点(透视)效果
        transform.m34 = -1.0 / 800;

        
        // 进行角度判断
        BOOL isLeft = itemCenterX < collectionCenterX;
        // 正负判断
        int num = isLeft ? 1 : -1;
        // 倾斜角度大小和距离成正比
        CGFloat angle = M_PI_4 * num * (1 - ratio) * 2;
        transform = CATransform3DRotate(transform, angle, 0, 1, 0);
        
        attribute.transform3D = transform;
        
        
    }
    return layoutArr;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    // 停止位置上的rect
    CGRect rect = CGRectZero;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.bounds.size;
    
    // 找到停止位置上的布局参数
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [self layoutAttributesForElementsInRect:rect];
    
    // 中心点距离左上角距离
    CGFloat collectionCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width/2;
    
    // 遍历数组 寻找最小值
    CGFloat minDistance = attributes[0].center.x - collectionCenterX;
    for(int i = 0; i < attributes.count; i++){
        
        UICollectionViewLayoutAttributes *attribute = attributes[i];
        // 停止状态下的item距离左上角距离
        CGFloat itemCenter = attribute.center.x;
        
        // 偏差值
        CGFloat distance = itemCenter - collectionCenterX;
        
        // 找到最小值
        if (minDistance < distance) {
            minDistance = distance;
        }
    }
    
    // 在原有预计偏差值基础上进行改动
    return CGPointMake(proposedContentOffset.x + minDistance, proposedContentOffset.y);
}

#pragma mark
#pragma mark - 当进行拖拽的时候是否需要刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end
