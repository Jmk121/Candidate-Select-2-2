//
//  Candidate.h
//  Candidate Select
//
//  Created by jmk121 on 8/24/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Candidate : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * locationCity;
@property (nonatomic, retain) NSString * locationState;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * ranking;
@property (nonatomic, retain) NSString * skill;
@property (nonatomic, retain) NSNumber * yearsOfExperience;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * considering;

@end
