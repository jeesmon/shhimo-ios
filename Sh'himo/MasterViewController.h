//
//  MasterViewController.h
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/25/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class PrayerViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) PrayerViewController *prayerViewController;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
