//
//  AddCandidate.m
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import "AddCandidate.h"

@interface AddCandidate ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTF;

@property (strong, nonatomic) IBOutlet UITextField *ageTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *cityTF;
@property (strong, nonatomic) IBOutlet UITextField *stateTF;
@property (strong, nonatomic) IBOutlet UITextField *skillTF;
@property (strong, nonatomic) IBOutlet UITextField *rankingTF;
@property (strong, nonatomic) IBOutlet UITextField *yoeTF;

@end

@implementation AddCandidate

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameTF.delegate = self;
    _ageTF.delegate = self;
    _emailTF.delegate = self;
    _cityTF.delegate = self;
    _stateTF.delegate =self;
    _skillTF.delegate = self;
    _rankingTF.delegate = self;
    _yoeTF.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Candidate *)makeCandidateWithInfo{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:_managedObjectContext];
    Candidate *makeCandidate = [[Candidate alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:_managedObjectContext];
    makeCandidate.skill = _skillTF.text;
    makeCandidate.firstName = _nameTF.text;
    makeCandidate.lastName = _lastNameTF.text;
    makeCandidate.email = _emailTF.text;
    makeCandidate.locationCity = _cityTF.text;
    makeCandidate.locationState = _stateTF.text;
    int ageNum =[_ageTF.text intValue];
    float rankNum = [_rankingTF.text floatValue];
    int yoeNum = [_yoeTF.text intValue];
    makeCandidate.age = [NSNumber numberWithInt:ageNum];
    makeCandidate.ranking =[NSNumber numberWithFloat:rankNum];
    makeCandidate.yearsOfExperience = [NSNumber numberWithInt:yoeNum];
    
    return makeCandidate;
}
- (IBAction)addCandidateToList:(id)sender {
    Candidate *cad= [self makeCandidateWithInfo];
    [_delegate addCandidate:cad];
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if ([_nameTF isFirstResponder] && [touch view]!= _nameTF) {
        [_nameTF resignFirstResponder];
    }
    
    if([_ageTF isFirstResponder] && [touch view]!= _ageTF){
        [_ageTF resignFirstResponder];
    }

    if ([_emailTF isFirstResponder] && [touch view]!=_emailTF) {
        [_emailTF resignFirstResponder];
    }
    
    if ([_cityTF isFirstResponder] && [touch view]!= _cityTF) {
        [_cityTF resignFirstResponder];
    }
    
    if([_stateTF isFirstResponder] && [touch view]!= _stateTF){
        [_stateTF resignFirstResponder];
    }
    
    if ([_rankingTF isFirstResponder] && [touch view]!=_rankingTF) {
        [_rankingTF resignFirstResponder];
    }
    
    if ([_skillTF isFirstResponder] && [touch view]!= _skillTF) {
        [_skillTF resignFirstResponder];
    }
    
    if([_yoeTF isFirstResponder] && [touch view]!= _yoeTF){
        [_yoeTF resignFirstResponder];
    }
    
   
    [super touchesBegan:touches withEvent:event];
    
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
