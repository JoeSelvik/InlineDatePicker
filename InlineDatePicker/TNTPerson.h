//
//  TNTPerson.h
//  InlineDatePicker
//
//  Created by Joe Selvik on 7/6/14.
//  Copyright (c) 2014 The New Tricks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNTPerson : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (copy, nonatomic) NSString *placeOfBirth;

- (id)initWithName:(NSString *)name dateOfBirth:(NSDate *)dateOfBirth placeOfBirth:(NSString *)placeOfBirth;

@end
