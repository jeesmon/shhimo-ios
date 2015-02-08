//
//  DetailViewController.h
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/25/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import "Prayer.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate> {
}

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) Prayer *prayerItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void)configureView;
- (void)setupToolbar;

@end
