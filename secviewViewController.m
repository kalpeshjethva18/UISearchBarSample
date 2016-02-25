//
//  secviewViewController.m
//  UISearchBarSample
//
//  Created by macpc on 19/02/16.
//
//

#import "secviewViewController.h"

@interface secviewViewController ()
{
    IBOutlet UITableView *tblview;
    
}
@end

@implementation secviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
// /   searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 77, 320, 44)];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
    
  //  searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchBar.delegate = self;
     tblview.tableHeaderView = searchBar;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [tblview addGestureRecognizer:tap];
    [self cityWS];
}
-(void)cancelBarButtonItemClicked:(id)sender
{
    [self searchBarCancelButtonClicked:searchBar];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    [self.view addSubview:searchDisplayController.searchBar];
    [self.view bringSubviewToFront:searchDisplayController.searchBar];
    [self.view addSubview:searchDisplayController.searchBar];
    [self.view addSubview:tblview];
}

-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:tblview];
    NSIndexPath *indexPath = [tblview indexPathForRowAtPoint:tapLocation];
    
    NSLog(@"dinex path %ld",(long)indexPath.row);
    
    if (indexPath) { //we are in a tableview cell, let the gesture be handled by the view
        recognizer.cancelsTouchesInView = NO;
    } else { // anywhere else, do what is needed for your case
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    if (tableView == tblview) {
        rows = [[[originalData objectAtIndex:0] objectAtIndex:0] count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (searchData.count == 0)
        {
            return 0;
        }
        else
        {
            rows = [[searchData objectAtIndex:0]count];
        }
    }
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (tableView == tblview) {
        cell.textLabel.text = [[[[originalData objectAtIndex:0] objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"city_name"];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        //        cell.textLabel.text = [[[[searchData objectAtIndex:0] objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"city_name"];
        cell.textLabel.text = [[searchData objectAtIndex:0] objectAtIndex:indexPath.row];
    }
    return cell;
}
#pragma mark - searchDisplayControllerDelegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        //isFiltered = FALSE;
    }
    else
    {
        [searchData removeAllObjects];
        NSArray *group;
        NSInteger counter = 0;
        for(group in [originalData objectAtIndex:0])
        {
            NSMutableArray *newGroup = [[NSMutableArray alloc] init];
            NSString *element;
            NSLog(@"group %@",group);
            
            
            for(element in [group valueForKey:@"city_name"])
            {
                NSRange range = [element rangeOfString:text options:NSCaseInsensitiveSearch];
                if (range.length > 0) {
                    [newGroup addObject:element];
                }
            }
            if ([newGroup count] > 0) {
                [searchData addObject:newGroup];
            }
            counter++;
            [newGroup release];
        }
    }
    
   // [tblview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UINavigationController *navi = [[UINavigationController alloc]init];
    navi.navigationBar.hidden = YES;
}
-(void)cityWS
{
    @try
    {
        // http://192.168.1.19/nearbyofferz4/merchants/api2/get_city.php?action=get_city
        
        NSString *apiString=@"";
        //apiString = NSLocalizedString(@"DomainUrl",nil);
        
        apiString = @"http://192.168.1.19/nearbyofferz4/merchants/api2/";
        apiString = [apiString stringByAppendingString:@"get_city.php?"];
        apiString = [apiString stringByAppendingString:@"action=get_city"];
        
        NSLog(@"api string home %@",apiString);
        
        NSData *requestData = [NSData dataWithBytes: [apiString UTF8String] length: [apiString length]];
        
        NSMutableURLRequest *apiRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[apiString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        [apiRequest setHTTPMethod:@"POST"];
        [apiRequest setHTTPBody:requestData];
        
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:apiRequest returningResponse: nil error: nil ];
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
        
        if(![responseString isKindOfClass:[NSNull class]])
        {
            NSError *jsonError;
            NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            if([[dict valueForKeyPath:@"header.status"] isEqualToString:@"200"])
            {
                NSMutableArray *data = [dict valueForKeyPath:@"data"];
                /*
                 NSMutableArray  *allTableData2 = [[NSMutableArray alloc] initWithObjects:
                 [[Food alloc] initWithName:[[data objectAtIndex:i] valueForKey:@"city_name"] andDescription:[[data objectAtIndex:i] valueForKey:@"city_name"]],nil ];
                 allTableData = [[NSMutableArray alloc] initWithObjects:
                 [[Food alloc] initWithName:@"veraval" andDescription:@"veraval"],nil ];
                 */
                // NSPredicate *pred = [NSPredicate predicateWithFormat:@"city_name %@"];
                //  NSArray *filtered = [data filteredArrayUsingPredicate:pred];
                //[allTableData addObject:[[data objectAtIndex:i] valueForKey:@"city_name"]];
                
                NSArray *group1 = [[NSArray alloc] initWithObjects:data, nil];
                originalData = [[NSArray alloc] initWithObjects:group1, nil];
                searchData = [[NSMutableArray alloc] init];
                [tblview reloadData];
            }
            else
            {
                if([dict valueForKeyPath:@"header.message"])
                {
                    UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"" message:[dict valueForKeyPath:@"header.message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alrt show];
                }
            }
        }
        else
        {
            UIAlertView *alrt=[[UIAlertView alloc] initWithTitle:@"" message:@"There is a problem in fetching data. Please try again or contact administrator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrt show];
        }
    }
    @catch (NSException *exception)
    {
        //..NSLog(@"Exvception Resson..%@",exception.reason);
    }
    @finally
    {
    }
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
