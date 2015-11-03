//
//  MSTagTextView.h
//  Pods
//
//  Created by Nick-Retina on 10/29/15.
//
//

#import <UIKit/UIKit.h>

@class MSTagTextView;
@protocol MSTagTextViewDataSource <NSObject>

@required
-(int) tagTextViewNumberOfTags:(MSTagTextView*)tagTextView;
-(NSString*) tagTextView:(MSTagTextView*)tagTextView stringForItemAtIndex:(int)index;
-(UIColor*) tagTextView:(MSTagTextView*)tagTextView colorForItemAtIndex:(int)index;
@end

@interface MSTagTextView : UITextView
@property (nonatomic,weak) id<MSTagTextViewDataSource> dataSource;
-(void) setTagWithString:(NSString*)aString andColor:(UIColor*)aColor;
@end

@interface MyLayoutManager : NSLayoutManager
@end