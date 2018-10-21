//
//  ViewController.m
//  LCWebView
//
//  Created by care on 2017/12/19.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import "ViewController.h"
#import "LCWebViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray=@[@"加载网页",@"加载本地html文件",@"加载后台返回htmlString"];
    _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strId=@"strId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strId];
    }
    cell.textLabel.text=dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        LCWebViewController *webVC=[[LCWebViewController alloc]init];
        NSURL *url=[NSURL URLWithString:@"https://www.baidu.com"];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [webVC loadRequest:request];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(indexPath.row==1){
        LCWebViewController *webVC=[[LCWebViewController alloc]init];
        
        [webVC loadHTMLFileName:@"airportSituation"];
 
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (indexPath.row==2){
        NSString *headStr = @"<head><style>img{width:100% !important}</style></head>";
        
        NSString *image1 = [NSString stringWithFormat:@"<div style=\"margin: -8px -8px;\"><img src='%@'/></div>",@"http://d.ifengimg.com/mw978_mh598/p0.ifengimg.com/pmop/2018/0101/F9D4C07373C0D9B013D71C834D420D6B9FC282AE_size100_w899_h627.jpeg"];
        NSString *contentStr = @"此处为文字,啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦了";
        NSString *htmlURlStr = [NSString stringWithFormat:@"%@<body style='background-color:#ffffff'>%@<br><div style=\"margin: 15pt 15pt;\">%@</div></body>", headStr, image1, contentStr];
        LCWebViewController *webVC=[[LCWebViewController alloc]init];
        [webVC loadHTMLString:htmlURlStr baseURL:nil];
        
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
