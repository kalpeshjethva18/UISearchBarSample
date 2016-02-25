//
//  secviewViewController.h
//  UISearchBarSample
//
//  Created by macpc on 19/02/16.
//
//

#import <UIKit/UIKit.h>

@interface secviewViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *originalData;
    NSMutableArray *searchData;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISearchDisplayController *searchDisplayController;
}

@end
