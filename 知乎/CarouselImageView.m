//
//  CarouselImageView.m
//  知乎
//
//  Created by Halsey on 8/30/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import "CarouselImageView.h"

@interface CarouselImageView ()

@property (strong, nonatomic) UILabel *titleLabel;


@end

@implementation CarouselImageView
- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.sd_layout
        .centerXEqualToView(self)
        .rightSpaceToView(self,25)
        .leftSpaceToView(self,25)
        .bottomSpaceToView(self,25)
        .autoHeightRatio(0);
    }
    return self;
}

-(void)setModel:(topStoriesModel *)model{
    _model = model;
    [self sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
}

@end
