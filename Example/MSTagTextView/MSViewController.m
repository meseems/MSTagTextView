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

@end

@implementation MSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tagView.dataSource = self;
    [self.tagView setFont:[UIFont systemFontOfSize:17.0]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    [self.tagView setTypingAttributes:attrsDictionary];
    self.tagView.layoutManager.delegate = self;
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 20; // For really wide spacing; pick your own value
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) tagTextViewNumberOfTags:(MSTagTextView*)tagTextView;
{
    return 6;
}
-(NSString*) tagTextView:(MSTagTextView*)tagTextView stringForItemAtIndex:(int)index;
{
    switch (index) {
        case 0:
            return @"Hello";
        case 1:
            return @"Hello1";
        case 2:
            return @"Hi HI hi h i n an lgn 2 matematica";
        case 3:
            return @"MeSeems";
        case 4:
            return @"me2";
        default:
            return @"Goodbye";
    }
}
-(UIColor*) tagTextView:(MSTagTextView*)tagTextView colorForItemAtIndex:(int)index;
{
    switch (index%3) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor orangeColor];
        default:
            return [UIColor purpleColor];
    }
}
@end
