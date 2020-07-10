//
//  LocationsViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "LocationsViewController.h"

#import "APIManager.h"
#import "LocationCell.h"

#pragma mark - Interface

@interface LocationsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *const searchBar;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) APIManager *manager;

@end

#pragma mark - Implementation

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _searchBar.delegate = self;
    
    _manager = [[APIManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    [cell updateWithLocation:_results[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = _results[indexPath.row];
    NSNumber *lat = [venue valueForKeyPath:@"location.lat"];
    NSNumber *lng = [venue valueForKeyPath:@"location.lng"];
    NSLog(@"%@, %@", lat, lng);
    
    [_delegate locationsViewController:self didPickLocationWithLatitude:lat longitude:lng];
}

#pragma mark - Search Bar

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [_manager fetchLocationsWithQuery:newText
                             nearCity:@"San Francisco"
                           completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        if (results) {
            self.results = results;
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to retrieve search data!");
        }
    }];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_manager fetchLocationsWithQuery:searchBar.text
                             nearCity:@"San Francisco"
                           completion:^(NSArray * _Nonnull results, NSError * _Nonnull error) {
        if (results) {
            self.results = results;
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to retrieve search data!");
        }
    }];
}

@end
