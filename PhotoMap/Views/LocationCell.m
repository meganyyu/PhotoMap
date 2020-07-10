//
//  LocationCell.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "LocationCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

static NSString *const kCategoriesKey = @"categories";
static NSString *const kIconPrefixKey = @"icon.prefix";
static NSString *const kIconSuffixKey = @"icon.suffix";
static NSString *const kLocationAddressKey = @"location.address";
static NSString *const kNameKey = @"name";

#pragma mark - Interface

@interface LocationCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) NSDictionary *location;

@end

#pragma mark - Implementation

@implementation LocationCell

#pragma mark - Setup

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Update Data

- (void)updateWithLocation:(NSDictionary *)location {
    self.nameLabel.text = location[kNameKey];
    self.addressLabel.text = [location valueForKeyPath:kLocationAddressKey];
    
    NSArray *categories = location[kCategoriesKey];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:kIconPrefixKey];
        NSString *urlSuffix = [category valueForKeyPath:kIconSuffixKey];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
        NSURL *url = [NSURL URLWithString:urlString];
        [self.categoryImageView setImageWithURL:url];
    }
}

@end
