//
//  TDViewController.h
//  NSThreadDeno
//
//  Created by tenric on 13-7-31.
//  Copyright (c) 2013年 tenric.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDViewController : UIViewController
{
    UIImageView* _imageView;
    int _ticketsSold;
    int _ticketsRemain;
    NSLock* _lock;
    
    
}
@property (nonatomic,strong) NSOperationQueue *queue;
@end
