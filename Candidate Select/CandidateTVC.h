//
//  CandidateTVC.h
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
@interface CandidateTVC : UITableViewController
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
