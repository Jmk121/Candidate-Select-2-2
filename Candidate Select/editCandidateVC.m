//
//  editCandidateVC.m
//  Candidate Select
//
//  Created by jmk121 on 8/23/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import "editCandidateVC.h"
#import "AppDelegate.h"
@interface editCandidateVC ()
@property (strong, nonatomic) IBOutlet UITextField *editNameTF;
@property (strong, nonatomic) IBOutlet UITextField *editAgeTF;
@property (strong, nonatomic) IBOutlet UITextField *editEmaiTF;
@property (strong, nonatomic) IBOutlet UITextField *editCityTF;
@property (strong, nonatomic) IBOutlet UITextField *editStateTF;
@property (strong, nonatomic) IBOutlet UITextField *editSkillTF;
@property (strong, nonatomic) IBOutlet UITextField *editRankTF;
@property (strong, nonatomic) IBOutlet UITextField *editExpTF;
@property (strong, nonatomic) IBOutlet UITextField *editlastNameTF;

@end

@implementation editCandidateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _editNameTF.text = _candidateToEdit.firstName;
    _editlastNameTF.text = _candidateToEdit.lastName;
    int age = [_candidateToEdit.age intValue];
    float rank = [_candidateToEdit.ranking floatValue];
    int exp = [_candidateToEdit.yearsOfExperience intValue];
    _editAgeTF.text =[NSString stringWithFormat:@"%i",age];
    _editEmaiTF.text = _candidateToEdit.email;
    _editCityTF.text = _candidateToEdit.locationCity;
    _editStateTF.text = _candidateToEdit.locationState;
    _editSkillTF.text = _candidateToEdit.skill;
    _editRankTF.text =[NSString stringWithFormat:@"%.01lf",rank];
    _editExpTF.text =[NSString stringWithFormat:@"%i",exp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(Candidate *)changeCandidateWithValue{

    _editNameTF.text = _candidateToEdit.firstName;
    _editlastNameTF.text = _candidateToEdit.lastName;
    int age = [_candidateToEdit.age intValue];
    float rank = [_candidateToEdit.ranking floatValue];
    int exp = [_candidateToEdit.yearsOfExperience intValue];
    _editAgeTF.text =[NSString stringWithFormat:@"%i",age];
    _editEmaiTF.text = _candidateToEdit.email;
    _editCityTF.text = _candidateToEdit.locationCity;
    _editStateTF.text = _candidateToEdit.locationState;
    _editSkillTF.text = _candidateToEdit.skill;
    _editRankTF.text =[NSString stringWithFormat:@"%.01lf",rank];
    _editExpTF.text =[NSString stringWithFormat:@"%i",exp];
    return _candidateToEdit;
}

- (IBAction)editButtonPressed:(id)sender {
    Candidate *cand = [self changeCandidateWithValue];
    [_delegate editCandidate:cand];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate save];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
