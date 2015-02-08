//
//  PrayerViewController.h
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/26/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface PrayerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (strong, nonatomic) NSString *day;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
