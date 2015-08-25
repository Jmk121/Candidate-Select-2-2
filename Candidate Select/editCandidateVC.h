//
//  editCandidateVC.h
//  Candidate Select
//
//  Created by jmk121 on 8/23/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"

@protocol EditCandidateDelegate <NSObject>

-(void)save;
-(void)editCandidate:(Candidate *)changeCandidate;
@end

@interface editCandidateVC : UIViewController

@property(strong,nonatomic)id<EditCandidateDelegate>delegate;
@property(nonatomic,strong)Candidate *candidateToEdit;

@end
