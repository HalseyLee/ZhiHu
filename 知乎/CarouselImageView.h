//
//  CarouselImageView.h
//  知乎
//
//  Created by Halsey on 8/30/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "topStoriesModel.h"

@interface CarouselImageView : UIImageView

@property (strong, nonatomic) topStoriesModel *model;

@end
