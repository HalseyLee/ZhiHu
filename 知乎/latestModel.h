//
//  latestModel.h
//  知乎
//
//  Created by Halsey on 8/24/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import <Foundation/Foundation.h>
@class storiesModel;

@interface latestModel : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSArray<storiesModel*> *stories;
@property (nonatomic, strong) NSArray *top_stories;

@end
