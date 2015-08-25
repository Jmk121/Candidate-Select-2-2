//
//  CandidateDetailVC.h
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Candidate.h"
#import "editCandidateVC.h"
@interface CandidateDetailVC : UIViewController
@property(nonatomic,strong)Candidate *candidate;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *skillLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankingLabel;
@property (strong, nonatomic) IBOutlet UILabel *yoeLabel;
@property (strong, nonatomic) IBOutlet UITextView *notesTV;
@property (strong, nonatomic) IBOutlet UILabel *choiceLabel;


@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@end
