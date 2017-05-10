//
//  TVHomeViewController.m
//  todo-list
//
//  Created by Kyle Hillman on 5/9/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "TVHomeViewController.h"
#import "Todo.h"
#import "TVDetailViewController.h"
#import "FirebaseAPI.h"

@interface TVHomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSArray<Todo *> *allTodos;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    

//    ^(NSArray<Todo *>
    [FirebaseAPI fetchAllTodos:^(NSArray<Todo *> *allTodos)  {
        NSLog(@"%@", allTodos);
        self.allTodos = allTodos;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.allTodos[indexPath.row].title;
    cell.detailTextLabel.text = self.allTodos[indexPath.row].content;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTodos.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TVDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"TVDetailViewController"];
    detailView.TVTodo = self.allTodos[indexPath.row];
    
    [self presentViewController:detailView animated:YES completion:nil];
}

@end































