//
//  TVDetailViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "TVDetailViewController.h"

@interface TVDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation TVDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel setText:self.TVTodo.title];
    [self.contentLabel setText:self.TVTodo.content];
    
}


@end
