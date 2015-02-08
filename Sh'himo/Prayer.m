//
//  Prayer.m
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/26/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import "Prayer.h"

@implementation Prayer

- (NSArray *) getPrayers
{
    NSArray *prayers = @[[self createPrayerObject:@"Ramsho" label:@"Ramsho (Vespers)" time:@"6 PM"], [self createPrayerObject:@"Soutoro" label:@"Soutoro (Compline)" time:@"9 PM"], [self createPrayerObject:@"Lilio" label:@"Lilio (Nocturns)" time:@"12 AM"], [self createPrayerObject:@"Sapro" label:@"Sapro (Matins)" time:@"6 AM"], [self createPrayerObject:@"Thloth" label:@"Thloth Sho'in (Third Hour)" time:@"9 AM"], [self createPrayerObject:@"Phalgeh" label:@"Phalgeh D'yaumo (Sixth Hour)" time:@"12 PM"], [self createPrayerObject:@"Thsha" label:@"Thsha's Sho'in (Ninth Hour)" time:@"3 PM"]];
    
    return prayers;
}

- (Prayer *) createPrayerObject:(NSString *) key label:(NSString *) label time:(NSString *) time
{
    Prayer *p = [[Prayer alloc] init];
    p.key = key;
    p.label = label;
    p.time = time;
    
    return p;
}

@end
