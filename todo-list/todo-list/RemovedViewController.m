//
//  RemovedViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "RemovedViewController.h"
#import "RemovedTableViewCell.h"
#import "Todo.h"

@import Firebase;

@interface RemovedViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;
@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic) NSMutableArray *allTodos;

@end

@implementation RemovedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemovedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    cell.titleText.text = currentTodo.title;
    cell.contentText.text = currentTodo.content;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTodos.count;
}


@end
