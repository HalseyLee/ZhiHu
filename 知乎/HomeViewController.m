//
//  HomeViewController.m
//  知乎
//
//  Created by Halsey on 8/24/16.
//  Copyright © 2016 Halsey. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "LatestModel.h"

#import <UITableView+SDAutoTableViewCellHeight.h>
#import "CarouselView.h"


#define CELLID @"HomeCell"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) latestModel *latestModel;
@property (strong, nonatomic) CarouselView *carouseView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *leftButton;


@end


@implementation HomeViewController

-(void)getLatest{
    
    [[AFHTTPSessionManager manager] GET:@"http://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [latestModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"stories":@"storiesModel",
                    
                     @"top_stories":@"topStoriesModel"
                      };
        }];
        latestModel *model = [latestModel mj_objectWithKeyValues:responseObject];
        
        self.dataArray = model.stories.mutableCopy;
        
        self.latestModel = model;
   
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 懒加载
-(UILabel *)titleLable{
    if (!_titleLable) {
      _titleLable = [UILabel new];
        _titleLable.attributedText = [[NSAttributedString alloc] initWithString:@"今日要闻" attributes:@{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                                }];

        [_titleLable sizeToFit];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLable;
}

-(UIView *)headerView{
    if (!_headerView) {
        
        _headerView = [UIView new];
        
        _headerView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:0];
        
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 56);
        
        [_headerView addSubview:self.titleLable];
        [_headerView addSubview:self.leftButton];
        
        _titleLable.sd_layout.centerXEqualToView(_headerView).centerYEqualToView(_headerView).widthIs(150).heightIs(30);
        _leftButton.sd_layout.leftSpaceToView(_headerView,4).topSpaceToView(_headerView,12).widthIs(35).heightIs(35);
    }
    
    return _headerView;
}

-(UITableView *)tableview{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [_tableview registerClass:[HomeTableViewCell class] forCellReuseIdentifier:CELLID];
        
        [_tableview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        
        _tableview.tableHeaderView = view;

    }
    return _tableview;
}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton new];
        [_leftButton addTarget:self action:@selector(didClickLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];

    }

    return _leftButton;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //contentoffset 向上滚为正,向下为负
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat contentOffsetY = self.tableview.contentOffset.y;
        if (contentOffsetY <= 0) {
            self.carouseView.height = 220 - contentOffsetY;//向下滚动需要拉伸 加上 滚动,负负得正
            CGRect frame = self.carouseView.frame;
            frame.origin.y = 0;
            self.carouseView.frame = frame;
        }else{
        
            CGRect frame = self.carouseView.frame;
            frame.origin.y = 0 - contentOffsetY; //向上滚动需要Y向上移动 需要负数
            self.carouseView.frame = frame;
        }
        
        CGFloat alpha = 0;
        
        if (contentOffsetY < 100) {
            alpha = 0;
        }else if (contentOffsetY < 165){
            alpha = (contentOffsetY - 100) / (165-100);
        }else{
            alpha = 1;
        }
        NSLog(@"%f",contentOffsetY);
        _headerView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:alpha];;
        
    }

}


-(CarouselView *)carouseView{
    
    if (!_carouseView) {
        
        _carouseView = [CarouselView new];
        
        _carouseView.frame = CGRectMake(0, 0, kScreenWidth, 240);
        
    }
    return _carouseView;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.tableview reloadData];
}

-(void)setLatestModel:(latestModel *)latestModel{
    
    _latestModel = latestModel;
    self.carouseView.images = latestModel.top_stories;
 
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - 自动返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableview cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[HomeTableViewCell class] contentViewWidth:kScreenWidth];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加tableView
    [self.view addSubview:self.tableview];
    
    [self.view addSubview:self.carouseView];

    [self.view addSubview:self.headerView];
    //获取数据
    [self getLatest];
  
}

-(void)didClickLeftBtnAction:(UIButton *)sender{


}

@end
