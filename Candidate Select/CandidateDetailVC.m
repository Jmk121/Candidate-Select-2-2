//
//  CandidateDetailVC.m
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import "CandidateDetailVC.h"
#import "CandidateTVC.h"
#import "AppDelegate.h"
@interface CandidateDetailVC ()<MFMailComposeViewControllerDelegate,UITextViewDelegate>


@property (assign, nonatomic) BOOL considered;
@property (strong, nonatomic) IBOutlet UISwitch *considerSwitch;
- (IBAction)changeConsidered:(id)sender;
@end

@implementation CandidateDetailVC
-(void)setCandidate:(Candidate *)newCandidate{
  if(_candidate != newCandidate)
  {
      _candidate = newCandidate;
      
  }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = _candidate.firstName;
    self.lastNameLabel = _lastNameLabel;
    NSString *ageString =[NSString stringWithFormat:@"%i",[_candidate.age intValue]];
    NSLog(@"Name: %@",_candidate.firstName);
    NSLog(@"Name in Label: %@",self.nameLabel.text);
    self.ageLabel.text = ageString;
    self.emailLabel.text = _candidate.email;
    self.cityLabel.text = _candidate.locationCity;
    self.stateLabel.text = _candidate.locationState;
    NSString *rankString =[NSString stringWithFormat:@"%.01lf",[_candidate.ranking floatValue]];
    self.rankingLabel.text = rankString;
    NSString *yoeString = [NSString stringWithFormat:@"%i",[_candidate.yearsOfExperience intValue]];
    self.yoeLabel.text = yoeString;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext =[delegate managedObjectContext];
    _notesTV.delegate =self;
    _notesTV.text = _candidate.notes;
    NSLog(@"%i", [_candidate.considering boolValue]);
    _considered = [_candidate.considering boolValue];
    
    if(_considered == YES)
    {
        [_considerSwitch setOn:YES animated:YES];
    }
    
    else
    {
        [_considerSwitch setOn:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)editCandidate:(Candidate *)candidate{
//    self.nameLabel.text = candidate.firstName;
//    self.lastNameLabel.text = candidate.locationState;
//    NSString *ageString =[NSString stringWithFormat:@"%i",[candidate.age intValue]];
//    NSLog(@"Name: %@",candidate.firstName);
//    NSLog(@"Name in Label: %@",self.nameLabel.text);
//    self.ageLabel.text = ageString;
//    self.emailLabel.text = candidate.email;
//    self.cityLabel.text = candidate.locationCity;
//    self.stateLabel.text = candidate.locationState;
//    NSString *rankString =[NSString stringWithFormat:@"%.01lf",[candidate.ranking floatValue]];
//    self.rankingLabel.text = rankString;
//    NSString *yoeString = [NSString stringWithFormat:@"%i",[candidate.yearsOfExperience intValue]];
//    self.yoeLabel.text = yoeString;
//   self.notes
    candidate.firstName = _nameLabel.text;
    candidate.lastName = _lastNameLabel.text;
    candidate.age = [NSNumber numberWithInt:[_ageLabel.text intValue]];
    candidate.email = _emailLabel.text;
    candidate.locationCity = _cityLabel.text;
    candidate.locationState = _stateLabel.text;
    candidate.ranking = [NSNumber numberWithInt:[_rankingLabel.text floatValue]];
    candidate.yearsOfExperience = [NSNumber numberWithInt:[_yoeLabel.text intValue]];
    candidate.notes = _notesTV.text;
    BOOL consider = _considerSwitch.isOn;
    candidate.considering = [NSNumber numberWithBool:consider];
    
    if(_considerSwitch.isOn)
    {
        _considered = YES;
        _choiceLabel.text = @"Considered";
    }
    
    else
    {
        _considered = NO;
        _choiceLabel.text = @"Not Considered";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;

}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

/**/
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[editCandidateVC class]]) {
        editCandidateVC *edvc = (editCandidateVC*)segue.destinationViewController;
        edvc.delegate = self;
        edvc.candidateToEdit = _candidate;
    }}

- (IBAction)sendEmailBtn:(id)sender {
    //Subject
    NSString *emailTite =@" Interested in you.";
    NSString *message = [NSString stringWithFormat:@"Greetings %@, I have reviewed you resume and want to contact ou about a position in NuTech.",_candidate.firstName];
    NSArray *toRecipent = [NSArray arrayWithObject:_candidate.email];
    MFMailComposeViewController *mcv = [[MFMailComposeViewController alloc]init];
    mcv.mailComposeDelegate = self;
    [mcv setSubject:emailTite];
    [mcv setMessageBody:message isHTML:NO];
    [mcv setToRecipients:toRecipent];
    [self presentViewController:mcv animated:YES completion:NULL];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveNotes:(id)sender {

    NSError *error;
    [self editCandidate:_candidate];
    if([self.managedObjectContext save:&error]){
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Success" message:@"Notes Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        NSString *errorString= [NSString stringWithFormat:@"%@",error];
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }

    [self.notesTV reloadInputViews];
}


-(IBAction)changeConsidered:(id)sender
{
//    if(!_considerSwitch.isOn)
//    {
//        [_considerSwitch setOn:YES];
//    }
//    
//    else
//    {
//        [_considerSwitch setOn:NO];
//    }
    _considered = _considerSwitch.isOn;
}
@end
