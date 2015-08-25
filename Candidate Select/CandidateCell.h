//
//  CandidateCell.h
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CandidateCell;

@protocol CandidateCellDelegate <NSObject>

-(BOOL)updateSwitchForCell:(CandidateCell *)cell;

@end

@interface CandidateCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *skillLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *yoeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UISwitch *choiceSwitch;
@property (strong, nonatomic) IBOutlet UILabel *choiceLabel;

@property (weak, nonatomic) id <CandidateCellDelegate> delegate;

@end
