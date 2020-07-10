//
//  FullImageViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "FullImageViewController.h"

#pragma mark - Interface

@interface FullImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *const fullImageView;

@end

#pragma mark - Implementation

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_fullImageView setImage:_selectedImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
