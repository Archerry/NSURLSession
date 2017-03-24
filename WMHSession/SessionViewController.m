//
//  SessionViewController.m
//  WMHSession
//
//  Created by Archer on 2017/3/24.
//  Copyright © 2017年 jiuji. All rights reserved.
//

#import "SessionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WMHFile.h"

@interface SessionViewController ()<NSURLSessionDelegate>
{
    AVPlayer *_player;
    NSURLSession *_resumeSession;
    NSURLSessionDownloadTask *_resumeTask;
    NSData *_resumeData;
}
@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _titleStr;
    if ([_whichOne isEqualToString:@"0"]) {
        [self createUIOne];
    }
    else if ([_whichOne isEqualToString:@"1"]){
        [self createUITwo];
    }
    else if ([_whichOne isEqualToString:@"2"]){
        [self createUIThree];
    }
    else if ([_whichOne isEqualToString:@"3"]){
        [self createUIFour];
    }
}

#pragma mark - 下载(图片)
-(void)createUIOne{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 84, AllScreen.width - 40, AllScreen.width - 40)];
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 1000;
    [self.view addSubview:imageView];
    
    UIButton *downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 30, AllScreen.width / 2, 40)];
    downLoadBtn.tag = 1001;
    downLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [downLoadBtn addTarget:self action:@selector(downLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(AllScreen.width / 2, CGRectGetMaxY(imageView.frame) + 30, AllScreen.width / 2, 40)];
    cancelBtn.tag = 1002;
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(pressCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

-(void)downLoadImage:(UIButton *)sender{
    UIImageView *imageView = (id)[self.view viewWithTag:1000];
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    NSString *imgStr = @"http://a3.topitme.com/f/74/9f/11281073948639f74fo.jpg";
    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    
    NSURLSession *ImgSession = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *ImgDownTask = [ImgSession downloadTaskWithURL:imgUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       //下载到沙盒的地址
        NSLog(@"%@=",location);
        
        //response.suggestedFilename 响应信息中的资源文件名
        NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"缓存地址%@----------------%@",cachePath,DateTime);
        
        //获取文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //将临时文件移到缓存目录下
        //[NSURL fileURLWithPath:cachesPath] 将本地路径转化为URL类型
        //URL如果地址不正确，生成的url对象为空
        [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:cachePath] error:NULL];
        
        UIImage *image = [UIImage imageWithContentsOfFile:cachePath];
        
        //更新UI需要调取主线程，否则在分线程中执行，图片加载会很慢
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    }];
    
    [ImgDownTask resume];
}

-(void)pressCancel:(UIButton *)sender{
    UIImageView *imageView = (id)[self.view viewWithTag:1000];
    UIButton *selectBtn = (id)[self.view viewWithTag:1001];
    selectBtn.selected = NO;
    selectBtn.userInteractionEnabled = YES;
    imageView.image = nil;
}

#pragma mark - 大文件下载
-(void)createUITwo{
    UILabel *downLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, AllScreen.height - 200, AllScreen.width, 40)];
    downLbl.text = @"大文件下载";
    downLbl.tag = 2001;
    downLbl.textAlignment = NSTextAlignmentCenter;
    downLbl.textColor = [UIColor blackColor];
    downLbl.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:downLbl];
    
    UIButton *downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, AllScreen.height - 160, AllScreen.width, 40)];
    downLoadBtn.tag = 2002;
    downLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [downLoadBtn addTarget:self action:@selector(downLoadBigFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
}

-(void)downLoadBigFile:(UIButton *)sender{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:@"https://moa.ch999.com/office/file/2b7d301dfc75be810fb5dda9f6920726d41d8cd98f00b204e9800998ecf8427e.mp4"]];
    
    [downloadTask resume];
}

#pragma mark - 断点续传
-(void)createUIThree{
    UILabel *downLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, AllScreen.height - 200, AllScreen.width, 40)];
    downLbl.text = @"断点续传";
    downLbl.tag = 3001;
    downLbl.textAlignment = NSTextAlignmentCenter;
    downLbl.textColor = [UIColor blackColor];
    downLbl.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:downLbl];
    
    UIButton *downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, AllScreen.height - 160, AllScreen.width / 3, 40)];
    downLoadBtn.tag = 3002;
    downLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [downLoadBtn addTarget:self action:@selector(pressPR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
    
    UIButton *pauseBtn = [[UIButton alloc]initWithFrame:CGRectMake(AllScreen.width / 3, AllScreen.height - 160, AllScreen.width / 3, 40)];
    pauseBtn.tag = 3003;
    pauseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    pauseBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pauseBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [pauseBtn addTarget:self action:@selector(pressPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseBtn];
    
    UIButton *resumeBtn = [[UIButton alloc]initWithFrame:CGRectMake(AllScreen.width / 3 * 2, AllScreen.height - 160, AllScreen.width / 3, 40)];
    resumeBtn.tag = 3004;
    resumeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    resumeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [resumeBtn setTitle:@"继续" forState:UIControlStateNormal];
    [resumeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [resumeBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [resumeBtn addTarget:self action:@selector(pressResume:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resumeBtn];
}

//点击任务开始
-(void)pressPR:(UIButton *)sender{
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    
    _resumeSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    _resumeTask = [_resumeSession downloadTaskWithURL:[NSURL URLWithString:@"https://moa.ch999.com/office/file/2b7d301dfc75be810fb5dda9f6920726d41d8cd98f00b204e9800998ecf8427e.mp4"]];
    
    [_resumeTask resume];
}

//点击暂停任务挂起
-(void)pressPause:(UIButton *)sender{
    UIButton *resumeBtn = (id)[self.view viewWithTag:3004];
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    resumeBtn.userInteractionEnabled = YES;
    resumeBtn.selected = NO;
    
    //将任务挂起
    [_resumeTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
       //将已下载的数据进行保存
        _resumeData = resumeData;
    }];
}

//点击继续
-(void)pressResume:(UIButton *)sender{
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    UIButton *pauseBtn = (id)[self.view viewWithTag:3003];
    pauseBtn.userInteractionEnabled = YES;
    pauseBtn.selected = NO;

    //使用rusumeData创建任务
    _resumeTask = [_resumeSession downloadTaskWithResumeData:_resumeData];
    
    [_resumeTask resume];
}

#pragma mark - 上传文件
-(void)createUIFour{
    UILabel *BackLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 84, AllScreen.width, AllScreen.height - 200)];
    BackLbl.tag = 4000;
    BackLbl.textAlignment = NSTextAlignmentCenter;
    BackLbl.font = [UIFont systemFontOfSize:14];
    BackLbl.textColor = [UIColor blackColor];
    BackLbl.text = @"上传文件返回数据";
    BackLbl.numberOfLines = 0;
    [self.view addSubview:BackLbl];
    
    UIButton *downLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(BackLbl.frame) + 30, AllScreen.width / 2, 40)];
    downLoadBtn.tag = 4001;
    downLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downLoadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [downLoadBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [downLoadBtn addTarget:self action:@selector(uploadFile:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downLoadBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(AllScreen.width / 2, CGRectGetMaxY(BackLbl.frame) + 30, AllScreen.width / 2, 40)];
    cancelBtn.tag = 4002;
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(pressCancelUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

-(void)uploadFile:(UIButton *)sender{
    NSURL *uploadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.9ji.com/app/3_0/UserHandler.ashx?act=UploadImage"]];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadUrl];
    
    uploadRequest.HTTPMethod = @"POST";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
    
    [uploadRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    UIImage *image = [UIImage imageNamed:@"图片1.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"图片2.jpg"];
    
    NSMutableArray *imaArr = [[NSMutableArray alloc]init];
    [imaArr addObject:image];
    [imaArr addObject:image2];
    
    uploadRequest.HTTPBody = [self getDataBodyWithImgArr:imaArr];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:uploadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            UILabel *textLbl = (id)[self.view viewWithTag:4000];
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                textLbl.text = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            });
        } else {
            NSLog(@"upload error:%@",error);
        }
        
    }] resume];
}

-(NSData *)getDataBodyWithImgArr:(NSArray *)imgArr{
    //每个文件上传须遵守W3C规则进行表单拼接
    NSMutableData * data=[NSMutableData data];
    
    for (int i = 0; i < 2; i++) {
        NSMutableString *headerStrM =[NSMutableString string];
        [headerStrM appendFormat:@"\r\n--%@\r\n",@"boundary"];
        [headerStrM appendFormat:@"Content-Disposition: form-data; name=\"file%d\"; filename=\"filename%d\"\r\n",i,i];
        [headerStrM appendFormat:@"Content-Type: application/octet-stream\r\n\r\n"];
        [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *imgData = UIImageJPEGRepresentation(imgArr[i], 0.5);
        [data appendData:imgData];
    }
    
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",@"boundary"];
    [data appendData:[footerStrM  dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

-(void)pressCancelUpload:(UIButton *)sender{
    UILabel *textLbl = (id)[self.view viewWithTag:4000];
    textLbl.text = @"上传多个文件";
}

#pragma mark - NSURLSessionDelegate
/*
 监测临时文件下载的数据大小，当每次写入临时文件时，就会调用一次
 bytesWritten 单次写入多少
 totalBytesWritten 已经写入了多少
 totalBytesExpectedToWrite 文件总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if ([session isEqual:_resumeSession]) {
        UILabel *resumeLbl = (id)[self.view viewWithTag:3001];
        
//        NSLog(@"已下载%f%%",totalBytesWritten * 1.0 / totalBytesExpectedToWrite * 100);
        
        resumeLbl.text = [NSString stringWithFormat:@"已下载%.2f%%",totalBytesWritten * 1.0 / totalBytesExpectedToWrite * 100];
        
    }else{
        UILabel *bigDownLbl = (id)[self.view viewWithTag:2001];
        UIButton *bigDownBtn = (id)[self.view viewWithTag:2002];
        bigDownBtn.selected = YES;
        bigDownBtn.userInteractionEnabled = NO;
        
        //打印下载百分比
//        NSLog(@"已下载%f%%",totalBytesWritten * 1.0 / totalBytesExpectedToWrite * 100);
        
        bigDownLbl.text = [NSString stringWithFormat:@"已下载%.2f%%",totalBytesWritten * 1.0 / totalBytesExpectedToWrite * 100];
        
//        NSLog(@"%.2fM",totalBytesExpectedToWrite / 1000.0 / 1000.0);
    }
}

//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *catchPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:catchPath] error:NULL];
    
    //获取本地视频元素
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:catchPath]];
    //创建视频播放器
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    //创建视屏显示的图层
    AVPlayerLayer *showLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    showLayer.frame = CGRectMake((AllScreen.width - (AllScreen.height - 200) / AllScreen.height * AllScreen.width) / 2, 20, (AllScreen.height - 200) / AllScreen.height * AllScreen.width, (AllScreen.height - 200) / AllScreen.height *AllScreen.height);
    [self.view.layer addSublayer:showLayer];
    //播放视频
    [_player play];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"%@",error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
