//
//  DetailViewController.m
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/25/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

CGPoint lastOffset;
UIBarButtonItem *flexSpace;
UIBarButtonItem *minus;
UIBarButtonItem *plus;
UIBarButtonItem *email;

bool inFullScreen = NO;
CGRect normalNavBarFrame;
CGRect hiddenNavBarFrame;
CGRect normalViewFrame;
CGRect fullViewFrame;
CGRect normalToolBarFrame;
CGRect hiddenToolBarFrame;
float animationDuration = 0.5;
bool toolbarInitialized = NO;
float delta = 25.0f;

UIColor *navBarColor;

#pragma mark - Managing the detail item

- (void)setPrayerItem:(Prayer *)newPrayerItem
{
    if (_prayerItem != newPrayerItem) {
        _prayerItem = newPrayerItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    if(SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        delta = 0.0f;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self loadContent];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    self.webView.scrollView.delegate = self;
    [[self.webView scrollView] setBounces: NO];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if(toolbarInitialized) {
            [self setupToolbar];
            
        }
    }
    
    if(inFullScreen) {
        [self toggleFullScreen];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    navBarColor = [UIColor colorWithRed:59/255.0f green:64/255.0f blue:68/255.0f alpha:1.0f];
	
    [self configureView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.webView addGestureRecognizer:doubleTap];
}

- (void) setupFullScreen
{
    // The normal navigation bar frame, i.e. fully visible
    normalNavBarFrame = self.navigationController.navigationBar.frame;
    
    normalToolBarFrame = self.navigationController.toolbar.frame;
    
    // The frame of the hidden navigation bar (moved up by its height)
    hiddenNavBarFrame = normalNavBarFrame;
    hiddenNavBarFrame.origin.y -= CGRectGetHeight(normalNavBarFrame) + delta;
    hiddenToolBarFrame = normalToolBarFrame;
    hiddenToolBarFrame.origin.y += CGRectGetHeight(normalToolBarFrame);
    
    // The frame of your view as specified in the nib file
    normalViewFrame = self.view.frame;
    
    // The frame of your view moved up by the height of the navigation bar
    // and increased in height by the same amount
    fullViewFrame = normalViewFrame;
    fullViewFrame.origin.y -= (CGRectGetHeight(normalNavBarFrame) + CGRectGetHeight(normalToolBarFrame) - 2 * delta);
    fullViewFrame.size.height += (CGRectGetHeight(normalNavBarFrame) + 2 * CGRectGetHeight(normalToolBarFrame));
}

- (void) doubleTapHandler
{
    NSLog(@"doubleTapHandler");
}

- (void) toggleFullScreen
{
    if(inFullScreen) {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.navigationBar.frame = normalNavBarFrame;
                             self.view.frame = normalViewFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.toolbar.frame = normalToolBarFrame;
                             self.view.frame = normalViewFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else {
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.navigationBar.frame = hiddenNavBarFrame;
                             self.view.frame = fullViewFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.navigationController.toolbar.frame = hiddenToolBarFrame;
                             self.view.frame = fullViewFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    inFullScreen = !inFullScreen;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Prayers";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResign)name:UIApplicationWillResignActiveNotification object:nil];
    
    [self setupButtons];
    [self setupToolbar];
    [self setupFullScreen];
}

- (void) applicationWillResign
{
    NSLog(@"applicationWillResign");
    inFullScreen = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) setupButtons
{
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    minus = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"minus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(decreaseFont)];
    plus = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus.png"] style:UIBarButtonItemStylePlain target:self action:@selector(increaseFont)];
    email = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email.png"] style:UIBarButtonItemStylePlain target:self action:@selector(composeEmail)];
    
    self.navigationController.toolbar.tintColor = navBarColor;
}

- (void) setupToolbar
{
    NSLog(@"setupToolbar");

    [self.navigationController setToolbarHidden:NO animated:YES];
    
    if([self.day isEqualToString:@"Preface"] || [self.day isEqualToString:@"About"]) {
        [self.navigationController.toolbar setItems:@[minus, flexSpace, plus] animated:YES];
    }
    else {
        [self.navigationController.toolbar setItems:@[minus, flexSpace, email, flexSpace, plus] animated:YES];
    }
    toolbarInitialized = YES;
}

- (void) decreaseFont
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"resizeText(-1);"];    
}

- (void) increaseFont
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"resizeText(1);"];
}

- (void) loadContent
{
    NSString *filename = nil;
    
    NSLog(@"day: %@", self.day);
    
    if([self.day isEqualToString:@"Preface"] || [self.day isEqualToString:@"About"]) {
        self.title = self.day;
        filename = self.day;
    }
    else {
        self.title = self.prayerItem.label;
        filename = [NSString stringWithFormat:@"%@-%@", self.day, self.prayerItem.key];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"html"];
    NSLog(@"path: %@ %@", filename, path);
    if(path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    }
}

-(void) composeEmail {
    if(self.prayerItem) {
        NSString *filename = [NSString stringWithFormat:@"%@-%@", self.day, self.prayerItem.key];
        NSError* error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"html"];
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:[NSString stringWithFormat:@"Sh'himo: %@ @ %@", self.prayerItem.label, self.prayerItem.time]];
        [mc setMessageBody:content isHTML:YES];
        
        [[mc navigationBar] setTintColor:navBarColor];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) scrollViewDidScroll :(UIScrollView *)scrollView {
    int delta = 5;
    if(scrollView == self.webView.scrollView && scrollView.contentOffset.y > 0) {
        if (scrollView.contentOffset.y > lastOffset.y + delta) {
            if(!inFullScreen) {
                [self toggleFullScreen];
            }
        }
        else if (scrollView.contentOffset.y < lastOffset.y - delta || scrollView.contentOffset.y <= 0) {
            if(inFullScreen) {
                [self toggleFullScreen];
            }
        }
        lastOffset = scrollView.contentOffset;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation");
    [self setupFullScreen];
    inFullScreen = NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest");
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

@end
