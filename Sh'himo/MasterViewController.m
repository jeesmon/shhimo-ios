//
//  MasterViewController.m
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/25/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "PrayerViewController.h"
#import "Prayer.h"

@interface MasterViewController () {
    NSArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sh'himo";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupToolbar];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.title = @"Sh'himo";
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = _objects[indexPath.row];
    if(![[object description] isEqualToString:@"Preface"]) {
        self.prayerViewController = [[PrayerViewController alloc] initWithNibName:@"PrayerViewController" bundle:nil];
        self.prayerViewController.detailViewController = self.detailViewController;
        self.prayerViewController.day = object;
        self.title = object;
        [self.navigationController pushViewController:self.prayerViewController animated:YES];
    }
    else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (!self.detailViewController) {
                self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            }
            self.detailViewController.day = object;
            [self.detailViewController configureView];
            [self.navigationController pushViewController:self.detailViewController animated:YES];
        } else {
            self.detailViewController.day = object;
            [self.detailViewController configureView];
        }
    }
}

- (void) infoClicked
{
    NSLog(@"infoClicked");
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (!self.detailViewController) {
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        self.detailViewController.day = @"About";
        [self.detailViewController configureView];
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.day = @"About";
        [self.detailViewController configureView];
    }
}

- (void) nowClicked
{
    NSLog(@"nowClicked");
    
    NSDate *now = [NSDate date];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components:(NSHourCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    int hour = [dateComps hour];
    int weekday = [dateComps weekday];
    
    if(weekday == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There are no Sh'himo prayers for Sunday" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    NSString *day = _objects[weekday - 1];
    
    NSLog(@"Week Day: %i, Hour: %i, Day: %@", weekday, hour, day);
    
    NSArray *prayers = [[[Prayer alloc] init] getPrayers];
    
    Prayer *currentPrayer = nil;
    if(hour >= 18 && hour < 21) {
        currentPrayer  = prayers[0];
    }
    else if (hour >= 21 && hour < 24) {
        currentPrayer  = prayers[1];
    }
    else if (hour >= 0 && hour < 6) {
        currentPrayer  = prayers[2];
    }
    else if (hour >= 6 && hour < 9) {
        currentPrayer  = prayers[3];
    }
    else if (hour >= 9 && hour < 12) {
        currentPrayer  = prayers[4];
    }
    else if (hour >= 12 && hour < 15) {
        currentPrayer  = prayers[5];
    }
    else if (hour >= 15 && hour < 18) {
        currentPrayer  = prayers[6];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (!self.detailViewController) {
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        self.detailViewController.day = day;
        self.detailViewController.prayerItem = currentPrayer;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.day = day;
        self.detailViewController.prayerItem = currentPrayer;
    }
}

- (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void) loadData
{
    NSLog(@"loadData");
    
    _objects = @[@"Preface", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
}

- (void) setupToolbar
{
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(infoClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];    
    
    NSDate *now = [NSDate date];    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components:(NSHourCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    int weekday = [dateComps weekday];
    
    if(weekday > 1) {
        UIBarButtonItem *nowButton = [[UIBarButtonItem alloc] initWithTitle:@"Now" style:UIBarButtonItemStyleBordered target:self action:@selector(nowClicked)];
        self.navigationItem.rightBarButtonItem = nowButton;
    }
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

@end
