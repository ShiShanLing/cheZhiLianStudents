//
//  TabBarView.m
//  guangda_student
//
//  Created by 冯彦 on 15/10/28.
//  Copyright © 2015年 daoshun. All rights reserved.
//

#import "TabBarView.h"

#define LR_SPACE 32 // 左右间隙
#define ITEM_ICON_WIDTH 16.5 // 首末节点图标的宽度（未选中状态）
#define JUMP_HIGH 12 // item文字跳动高度
@interface TabBarView () {
    NSUInteger _itemIndex;
}
@property (assign, nonatomic) CGFloat midGap; // item之间的间隙
@property (strong, nonatomic) NSMutableArray *itemBtnArray; // 节点按钮数组
@property (strong, nonatomic) NSMutableArray *itemsIconArray; // 节点图标数组
@property (strong, nonatomic) NSMutableArray *itemsLabelArray; // 节点图标数组
@property (strong, nonatomic) UIImageView *selectItemIcon; // 选中节点的图标

@end

@implementation TabBarView
- (NSMutableArray *)itemBtnArray {
    if (!_itemBtnArray) {
        _itemBtnArray = [[NSMutableArray alloc] init];
    }
    return _itemBtnArray;
}

- (NSMutableArray *)itemsIconArray {
    if (!_itemsIconArray) {
        _itemsIconArray = [[NSMutableArray alloc] init];
    }
    return _itemsIconArray;
}

- (NSMutableArray *)itemsLabelArray {
    if (!_itemsLabelArray) {
        _itemsLabelArray = [[NSMutableArray alloc] init];
    }
    return _itemsLabelArray;
}

- (UIImageView *)selectItemIcon {
    if (!_selectItemIcon) {
        _selectItemIcon = [[UIImageView alloc] init];
        _selectItemIcon.width = 44;
        _selectItemIcon.height = 44;
        _selectItemIcon.backgroundColor = [UIColor clearColor];
        _selectItemIcon.image = [UIImage imageNamed:@"ic_learn_tab"];
    }
    return _selectItemIcon;
}

- (void)setItemsCount:(NSUInteger)itemsCount
{
    if (itemsCount < 2) {
        NSLog(@"节点数不能少于2个");
        return;
    }
    _itemsCount = itemsCount;
    // 横线
    UIImageView *bigLine = [[UIImageView alloc] init];
    [self addSubview:bigLine];
    bigLine.width = kScreen_widht - LR_SPACE * 2 - ITEM_ICON_WIDTH * 2;
    bigLine.height = 4.5;
    bigLine.x = LR_SPACE + ITEM_ICON_WIDTH;
    bigLine.centerY = self.height/2 - 5;
    [bigLine setImage:[UIImage imageNamed:@"icon_tab_line"]];
    
    self.midGap = (self.width - 2 * LR_SPACE - ITEM_ICON_WIDTH) / (itemsCount - 1);
    // 添加节点
    for (int i = 0; i < itemsCount; i++) {
        [self createItem:i];
    }
    
    // 添加选中图片
    UIImageView *secondItemIcon = self.itemsIconArray[1]; // 获得第二个节点
    self.selectItemIcon.center = secondItemIcon.center;
    [self addSubview:self.selectItemIcon];
    
    _itemIndex = 1;
}

// 根据索引创造节点
- (void)createItem:(NSUInteger)itemIndex
{
    // 图片
    UIImageView *itemIcon = [[UIImageView alloc] init];
    [self addSubview:itemIcon];
    itemIcon.width = ITEM_ICON_WIDTH;
    itemIcon.height = 15.5;
    if (itemIndex == 0) { // 首节点
        itemIcon.x = 32;
        [itemIcon setImage:[UIImage imageNamed:@"icon_tab_left"]];
    } else if (itemIndex == self.itemsCount - 1) { // 尾节点
        itemIcon.right = kScreen_widht - 32;
        [itemIcon setImage:[UIImage imageNamed:@"icon_tab_right"]];
    } else { // 中间节点
        itemIcon.width = 18;
        itemIcon.centerX = LR_SPACE + (ITEM_ICON_WIDTH / 2) + self.midGap * itemIndex;
        [itemIcon setImage:[UIImage imageNamed:@"icon_tab_middle"]];
    }
    itemIcon.centerY = self.height/2 - 5;
    itemIcon.backgroundColor = MColor(247, 247, 247);
    [self.itemsIconArray addObject:itemIcon];
    
    // 文字
    UILabel *itemLabel = [[UILabel alloc] init];
    [self addSubview:itemLabel];
    itemLabel.width = 40;
    itemLabel.height = 12;
    itemLabel.top = itemIcon.bottom + 7;
    itemLabel.centerX = itemIcon.centerX;
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.font = [UIFont systemFontOfSize:11];
    itemLabel.textColor = MColor(31, 31, 31);
    itemLabel.textAlignment = NSTextAlignmentCenter;
    itemLabel.text = @"item";
    if (itemIndex == 1) {
        itemLabel.y += JUMP_HIGH;
    }
    [self.itemsLabelArray addObject:itemLabel];
    
    // 按钮
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:itemBtn];
    itemBtn.width = 60;
    itemBtn.height = 60;
    itemBtn.center = itemIcon.center;

    itemBtn.tag = itemIndex;
    [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemBtnArray addObject:itemBtn];
}


- (void)itemBtnClick:(UIButton *)sender {
    
    NSUInteger itemIndex = sender.tag;
    if (itemIndex == _itemIndex) return;
    UILabel *oldItemLabel = self.itemsLabelArray[_itemIndex];
    UILabel *newItemLabel = self.itemsLabelArray[itemIndex];
    
    // 将选中图标移到相应位置
    UIImageView *itemIcon = self.itemsIconArray[itemIndex];
    // item对应的图标
    UIImage *icon = nil;
    switch (itemIndex) {
        case 0:
            icon = [UIImage imageNamed:@"ic_exercise_tab"];
            break;
            
        case 1:
            icon = [UIImage imageNamed:@"ic_learn_tab"];
            break;
            
        case 2:
            icon = [UIImage imageNamed:@"ic_peijia_tab"];
            break;
            
        case 3:
            icon = [UIImage imageNamed:@"ic_serve_tab"];
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:itemIndex];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.selectItemIcon.center = itemIcon.center;
        self.selectItemIcon.image = icon;
        oldItemLabel.y -= JUMP_HIGH;
        newItemLabel.y += JUMP_HIGH;
    }completion:^(BOOL finished) {}];
    
    _itemIndex = itemIndex;
}

- (void)itemClickToIndex:(NSUInteger)itemIndex
{
    UIButton *btn = self.itemBtnArray[itemIndex];
    [self itemBtnClick:btn];
}

- (void)itemsTitleConfig:(NSArray *)titleArray
{
    if (titleArray.count != self.itemsCount) {
        NSLog(@"标题数目不符");
        return;
    }
    for (int i = 0; i < titleArray.count; i++) {
        NSString *titleStr = titleArray[i];
        UILabel *itemLabel = self.itemsLabelArray[i];
        itemLabel.text = titleStr;
    }
}

@end
