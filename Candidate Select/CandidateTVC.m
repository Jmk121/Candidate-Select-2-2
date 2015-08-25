//
//  CandidateTVC.m
//  Candidate Select
//
//  Created by jmk121 on 8/20/15.
//  Copyright (c) 2015 jmk121. All rights reserved.
//

#import "CandidateTVC.h"
#import "CandidateCell.h"

#import "CandidateDetailVC.h"
#import "AppDelegate.h"
#import "AddCandidate.h"
@interface CandidateTVC ()<UISearchBarDelegate,UISearchResultsUpdating,NSFetchedResultsControllerDelegate,AddCandidateDelegate,UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultCOntroller;
@property(strong,nonatomic)NSArray *filterSearch;
@property(strong,nonatomic)NSArray *candidates;
@property (strong,nonatomic)NSFetchRequest *searchFetchRequest;
@property(strong,nonatomic)UISearchController *searchController;
@property(assign,nonatomic)BOOL choiceMade;
typedef NS_ENUM(NSInteger, CandidataeSearchScope)
{
    searchScopeName = 0,
    searchScopeSkill = 1,
    searchScopeYears = 2,
    searchScopeRank = 3,
    searchScopeConsider = 4
};

@end

@implementation CandidateTVC

static NSString *cellID = @"CandidateCell";
static NSString *seguetoDetail = @"CandidateInfoDetail";

#pragma mark ====View Life Cycle Management

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CandidateList";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangePreferredContentSize:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.estimatedRowHeight = 100.0;
 //   self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    //Config search bar with scope of buttons and add to table header
    self.searchController.searchBar.scopeButtonTitles = @[@"Name",
                                                          @"Skill",
                                                          @"Years of Experience",
                                                          @"Rank",
                                                          @"Consider"];
    
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedObjectContext =[delegate managedObjectContext];
    [self.searchController.searchBar sizeToFit];
    _candidates = [[NSArray alloc]init];
   _candidates = [self getAllCandidates];
    [self.tableView reloadData];
}

-(void)didChangePreferredContentSize:(NSNotification*)notification{
    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.searchFetchRequest = nil;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}


-(NSArray *)getAllCandidates{
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor =[[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *candidateArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    _candidates = candidateArray;
    return candidateArray;

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.destinationViewController isKindOfClass:[CandidateDetailVC class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Candidate *candidate = nil;
        if (self.searchController.isActive) {
            candidate = [self.filterSearch objectAtIndex:indexPath.row];
        }
        else{
            candidate = [self.fetchedResultCOntroller objectAtIndexPath:indexPath];
        }
    CandidateDetailVC *cdvc = (CandidateDetailVC*)[segue destinationViewController];
    cdvc.candidate = candidate;
//    cdvc.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//    cdvc.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    else if([segue.destinationViewController isKindOfClass:[AddCandidate class]])
    {
        AddCandidate *acvc = (AddCandidate *)segue.destinationViewController;
        acvc.delegate = self;
        acvc.managedObjectContext = _managedObjectContext;
    }
}


#pragma Access


-(NSFetchRequest *)searchFetchRequest
{
    if(_searchFetchRequest !=nil)
    {
        return  _searchFetchRequest;
    }
    _searchFetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"skill" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    return _searchFetchRequest;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if(self.searchController.active){
        return 1;
    }
    else{
        return [[self.fetchedResultCOntroller sections]count];
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return  [self.filterSearch count];
    }
    else{
        id<NSFetchedResultsSectionInfo> sectionInfo =[[self.fetchedResultCOntroller sections]objectAtIndex:section];
    
      return [sectionInfo numberOfObjects];
    }
  
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CandidateCell *cell = (CandidateCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    Candidate *candidate =nil;
    
    if (self.searchController.active) {
        candidate = [self.filterSearch objectAtIndex:indexPath.row];
    }
    else if (!self.searchController.active){
        candidate = [self.fetchedResultCOntroller objectAtIndexPath:indexPath];
    }
    else{
        // display all candidates in listview
        candidate = [self.candidates objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = candidate.firstName;
    cell.skillLabel.text = candidate.skill;
    
    
    NSString *rankingString= [NSString stringWithFormat:@"%.01lf",[candidate.ranking floatValue]];
    NSString *yoeString = [NSString stringWithFormat:@"%i",[candidate.yearsOfExperience intValue]];
    cell.yoeLabel.text = yoeString;
    cell.rankLabel.text = rankingString;
    
    BOOL considered = [candidate.considering boolValue];
    [cell.choiceSwitch setOn:considered animated:YES];
    cell.choiceSwitch.enabled = NO;
    NSLog(@"ranking:%@",cell.rankLabel.text);
    NSLog(@"skill:%@",candidate.skill);
    NSLog(@"skill in label:%@",cell.skillLabel.text);
    // Configure the cell...
    
    
    
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!self.searchController.active) {
        id<NSFetchedResultsSectionInfo> sectionInfo =[[self.fetchedResultCOntroller sections]objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (!self.searchController.active)
    {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultCOntroller sectionIndexTitles];
        [index addObjectsFromArray:initials];
        return index;
    }
    return nil;

}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    if (!self.searchController.active) {
        if(index>0){
            return [self.fetchedResultCOntroller sectionForSectionIndexTitle:title atIndex:-1];
        }
        
        else{
        
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return  0;

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/**/
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       Candidate *deleteCandidates = _candidates[indexPath.row];
        [self.managedObjectContext deleteObject:deleteCandidates];
        _candidates =[self getAllCandidates];
        //
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        [self save];

    
    } 
}

-(void)updateSwitchForCell:(CandidateCell *)cell atIndexPath:(NSIndexPath *)path
{
    Candidate *candidate = _candidates[path.row];
    
    _choiceMade = [candidate.considering boolValue];
    
    if(cell.choiceSwitch.isOn)
    {
        _choiceMade = YES;
    }
    
    else if(!cell.choiceSwitch.isOn)
    {
        _choiceMade = NO;
    }
    
    [self save];
    [self.tableView reloadData];
}

#pragma  FETCHING
//-(NSFetchedResultsController *)fetchedResultCOntroller{
//    if(_fetchedResultCOntroller != nil){
//    
//        return _fetchedResultCOntroller;
//    }
//
//
//    
//    if (self.managedObjectContext) {
//        NSFetchRequest *requestFetched = [[NSFetchRequest alloc]init];
//        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:self.managedObjectContext];
//        [requestFetched setEntity:entityDesc];
//        
//        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"skill" ascending:YES];
//        NSArray *descriptorsSorted = [NSArray arrayWithObjects:sortDesc, nil];
//        [requestFetched setSortDescriptors:descriptorsSorted];
//        
//        
//    }
//    return _fetchedResultCOntroller;
//}


-(NSFetchedResultsController *)fetchedResultCOntroller{
    
    if(_fetchedResultCOntroller != nil){
        
        
        
        return _fetchedResultCOntroller;
        
    }
    
    
    
    
    
    
    
    if (self.managedObjectContext) {
        
        NSFetchRequest *requestFetched = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:self.managedObjectContext];
        
        [requestFetched setEntity:entityDesc];
        
        
        
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"skill" ascending:YES];
        
        NSArray *descriptorsSorted = [NSArray arrayWithObjects:sortDesc, nil];
        
        [requestFetched setSortDescriptors:descriptorsSorted];
        
        
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:requestFetched
                                           
                                                                              managedObjectContext:self.managedObjectContext
                                           
                                                                                sectionNameKeyPath:nil
                                           
                                                                                         cacheName:@"Candidate"];
        
        frc.delegate = self;
        
        self.fetchedResultCOntroller = frc;
        
        
        
        NSError *error = nil;
        
        if (![self.fetchedResultCOntroller performFetch:&error])
            
        {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
        }
        
        
        
    }
    
    return _fetchedResultCOntroller;
    
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{

    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];

}


#pragma mark UISearchResultsUdpating


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}


-(void)searchForText:(NSString*)searchText scope:(CandidataeSearchScope)scopeOption
{
    
    if (self.managedObjectContext) {
        NSString *predFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"firstName";
        
        if(scopeOption == searchScopeName){
            searchAttribute = @"firstName";
        
        }
        
        if (scopeOption == searchScopeSkill) {
            searchAttribute =@"skill";
        }
        
       else if (scopeOption == searchScopeYears) {
            
            searchAttribute = @"yearsOfExperience";
        }
        else if(scopeOption == searchScopeRank)
        {
            searchAttribute = @"ranking";
        }
        
       else if (scopeOption == searchScopeConsider)
        {
            searchAttribute = @"considering";

        }
        
        
        if ([searchAttribute isEqualToString:@"considering"]) {
            //NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"anAttribute == YES"];
            BOOL consider = [NSNumber numberWithBool:YES];
            
            NSString *predString = [NSString stringWithFormat:@"anAttribute == %i", consider];
            
            [predFormat isEqualToString:predString];
        }

        NSPredicate *predicate = [NSPredicate predicateWithFormat:predFormat,searchAttribute,searchText];
        
        [self.searchFetchRequest setPredicate:predicate];
        NSError *error = nil;
        self.filterSearch = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
        
        
        
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    
    }
}

-(void)addCandidate:(Candidate *)candidate{

    NSMutableArray *mutableCandidate = [_candidates mutableCopy];
    [mutableCandidate addObject:candidate];
    _candidates = [self getAllCandidates];
    [self.tableView reloadData];
    [self save];
}
-(void)save{
    NSError *error;
    if([self.managedObjectContext save:&error]){
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Success" message:@"Candidate List Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else {
        NSString *errorString= [NSString stringWithFormat:@"%@",error];
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation
*/


@end
