//
//  TDViewController.m
//  NSThreadDeno
//
//  Created by tenric on 13-7-31.
//  Copyright (c) 2013年 tenric.com. All rights reserved.
//

#import "TDViewController.h"

@interface TDViewController ()

@end

@implementation TDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Download Image" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 150, 30);
    [button addTarget:self action:@selector(doDownloadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 200, 400)];
    [self.view addSubview:_imageView];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"线程同步(Lock)" forState:UIControlStateNormal];
    button.frame = CGRectMake(160, 0, 150, 30);
    [button addTarget:self action:@selector(doThreadSyncUseLock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"线程同步(Sync)" forState:UIControlStateNormal];
    button.frame = CGRectMake(160, 40, 150, 30);
    [button addTarget:self action:@selector(doThreadSyncUseSync) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doDownloadImage
{
    NSString* imageUrl = @"http://img.my.csdn.net/uploads/201111/14/0_1321288486r841.gif";
    NSThread *myThread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoadImage:) object:imageUrl];
    [myThread start];
}

- (void)downLoadImage:(id)argu
{
    NSString* imageUrl = (NSString*)argu;
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage* image = [UIImage imageWithData:data];
    [_imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

- (void)doThreadSyncUseLock
{
    _ticketsSold = 0;
    _ticketsRemain = 100;
    _lock = [[NSLock alloc] init];
    NSLog(@"doThreadSyncUseLock");
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseLock) object:nil];
    thread1.name = @"Thread1";
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseLock) object:nil];
    thread2.name = @"Thread2";
    [thread2 start];
    
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseLock) object:nil];
    thread3.name = @"Thread3";
    [thread3 start];
}

- (void)soldUseLock
{
    while (YES)
    {
        [_lock lock];
        if (_ticketsRemain>0)
        {
            [NSThread sleepForTimeInterval:0.1];
            _ticketsSold++;
            _ticketsRemain--;
            NSLog(@"Thread:%@,Sold:%d,Remain:%d,Total:%d",[NSThread currentThread].name,_ticketsSold,_ticketsRemain,_ticketsSold+_ticketsRemain);
            if (_ticketsRemain<=0)
            {
                break;
            }
        }
        [_lock unlock];
    }
}

- (void)doThreadSyncUseSync
{
    _ticketsSold = 0;
    _ticketsRemain = 100;
    
    NSLog(@"doThreadSyncUseSync");
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseSync) object:nil];
    thread1.name = @"Thread1";
    [thread1 start];
    
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseSync) object:nil];
    thread2.name = @"Thread2";
    [thread2 start];
    
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(soldUseSync) object:nil];
    thread3.name = @"Thread3";
    [thread3 start];
}

- (void)soldUseSync
{
    while (YES)
    {
        @synchronized(self)
        {
            if (_ticketsRemain>0)
            {
                [NSThread sleepForTimeInterval:0.1];
                _ticketsSold++;
                _ticketsRemain--;
                NSLog(@"Thread:%@,Sold:%d,Remain:%d,Total:%d",[NSThread currentThread].name,_ticketsSold,_ticketsRemain,_ticketsSold+_ticketsRemain);
                if (_ticketsRemain<=0)
                {
                    break;
                }
            }
        }
    }
}


@end
