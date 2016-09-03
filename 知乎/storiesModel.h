//
//  storiesModel.h
//  知乎
//
//  Created by Halsey on 8/24/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface storiesModel : NSObject

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) long long id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *ga_prefix;
@property (nonatomic, copy) NSString *title;



@end
