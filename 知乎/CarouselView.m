//
//  CarouselView.m
//  知乎
//
//  Created by Halsey on 8/27/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import "CarouselView.h"
#import "topStoriesModel.h"
#import "CarouselImageView.h"

@interface CarouselView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *imageArray;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation CarouselView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIScrollView *scrollView = [UIScrollView new];
        [self addSubview:scrollView];
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        self.scrollView  = scrollView;
        
        UIPageControl *pageControl = [UIPageControl new];
        self.pageControl = pageControl;
        [self addSubview:pageControl];
        
        scrollView.sd_layout.topSpaceToView(self,0).leftSpaceToView(self,0).rightSpaceToView(self,0).bottomSpaceToView(self,0);
        pageControl.sd_layout.centerXEqualToView(self).widthIs(60).heightIs(15).bottomSpaceToView(self,20);
   
    }
    return self;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    int currentPage = (int)(xOffset/self.width+0.5);
    self.pageControl.currentPage = currentPage;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self addTimer];
}


-(void)setImages:(NSArray *)images{
    _images = images;
    
    self.pageControl.numberOfPages = images.count;
    for (topStoriesModel *model in images) {
        
        CarouselImageView *imageView = [CarouselImageView new];
        imageView.model = model;
        
        [self.scrollView addSubview:imageView];
        
        if (self.imageArray.count == 0) {
            imageView.sd_layout.topSpaceToView(self.scrollView,0).leftSpaceToView(self.scrollView,0).bottomSpaceToView(self.scrollView,0).widthRatioToView(self.scrollView,1);
        }else{
            imageView.sd_layout.topSpaceToView(self.scrollView,0).leftSpaceToView([self.imageArray lastObject],0).bottomSpaceToView(self.scrollView,0).widthRatioToView(self.scrollView,1);
        }
        
        [self.imageArray addObject:imageView];
        self.scrollView.contentSize = CGSizeMake(self.imageArray.count * self.width, self.height);
    }
    
    [self addTimer];
}

-(void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

-(void)removeTimer{

    [self.timer invalidate];

}

-(void)nextImage{
    
    //取余
    NSInteger page = (self.pageControl.currentPage+1) % self.pageControl.numberOfPages;
    
    CGFloat xOffset = page * self.width;
    
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];

}

-(NSMutableArray *)imageArray{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

@end
