//
//  MSViewController.m
//  MSTagTextView
//
//  Created by nickmm on 10/29/2015.
//  Copyright (c) 2015 nickmm. All rights reserved.
//

#import "MSViewController.h"
#import "MSTagTextView.h"
@interface MSViewController () <MSTagTextViewDataSource>
@property (weak, nonatomic) IBOutlet MSTagTextView *tagView;
@property (assign, nonatomic) int num;
@end

@implementation MSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _num = 0;
    self.tagView.dataSource = self;
    [self.tagView setFont:[UIFont systemFontOfSize:17.0]];
    [self.tagView setEditable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onButtonPressed:(id)sender {
    _num++;
    [self.tagView reloadData];
    [self.tagView setFont:[UIFont systemFontOfSize:17.0]];
}

-(int) tagTextViewNumberOfTags:(MSTagTextView*)tagTextView;
{
    return 6;
}
-(NSString*) tagTextView:(MSTagTextView*)tagTextView stringForItemAtIndex:(int)index;
{
    switch ((index+_num)%6) {
        case 0:
            return @"Hello";
        case 1:
            return @"I want to say Hello";
        case 2:
            return @"One two three four five six seven eight nine ten";
        case 3:
            return @"MeSeems";
        case 4:
            return @"Eleven Twelve Thirteen Fourteen Fifteen Sixteen Seventeen Eighteen Nineteen Twenty";
        default:
            return @"Goodbye";
    }
}
-(UIColor*) tagTextView:(MSTagTextView*)tagTextView colorForItemAtIndex:(int)index;
{
    switch ((index+_num)%3) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor orangeColor];
        default:
            return [UIColor purpleColor];
    }
}
@end
