//
//  TodoTableViewCell.h
//  todo-list
//
//  Created by Kyle Hillman on 5/8/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *contentText;


@end
