//
//  HomeTableViewCell.m
//  知乎
//
//  Created by Halsey on 8/24/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import "HomeTableViewCell.h"


@interface HomeTableViewCell ()

@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIImageView *iconImageView;

@end

@implementation HomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
    if (self) {
        
        [self creatShadowbgView];
        
        self.label = [UILabel new];
        [self.shadowView addSubview:self.label];
        
        self.iconImageView = [UIImageView new];
        [self.shadowView addSubview:self.iconImageView];
        
        self.iconImageView.sd_layout.topSpaceToView(self.shadowView,10).leftSpaceToView(self.shadowView,10).widthIs(70).heightIs(60);

        self.label.sd_layout.topEqualToView(self.iconImageView).leftSpaceToView(self.iconImageView,10).rightSpaceToView(self.shadowView,10).autoHeightRatio(0);
        
        [self.shadowView setupAutoHeightWithBottomViewsArray:@[self.iconImageView,self.label] bottomMargin:10];
        
        [self setupAutoHeightWithBottomViewsArray:@[self.shadowView] bottomMargin:5];
    }
    return self;
}

-(void)creatShadowbgView{
    self.shadowView = [UIView new];
    self.shadowView.backgroundColor = [UIColor whiteColor];
    self.shadowView.layer.shadowOffset = CGSizeMake(1, 1);
    self.shadowView.layer.shadowOpacity = 0.3;
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.contentView addSubview:self.shadowView];
    
    self.shadowView.sd_layout.topSpaceToView(self.contentView,5).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10);

}

-(void)setModel:(storiesModel *)model{
    self.label.text = model.title;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.images firstObject]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    }else{
        self.shadowView.backgroundColor = [UIColor whiteColor];
    }

}

@end
