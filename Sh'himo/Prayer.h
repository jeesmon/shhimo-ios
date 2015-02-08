//
//  Prayer.h
//  Sh'himo
//
//  Created by Jacob, Jeesmon on 8/26/13.
//  Copyright (c) 2013 Jacob, Jeesmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prayer : NSObject {
    
}

@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) NSString *label;
@property (weak, nonatomic) NSString *time;

- (NSArray *) getPrayers;

@end
