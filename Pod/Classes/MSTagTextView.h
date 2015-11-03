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

@protocol MSTagTextViewDelegate <NSObject>
@optional
-(CGFloat) tagTextView:(MSTagTextView*)tagTextView tagSpacingForItemAtIndex:(NSUInteger)index;
-(CGFloat) tagTextView:(MSTagTextView*)tagTextView tagPaddingForItemAtIndex:(NSUInteger)index;
@end

@protocol MSTagTextViewLayoutManagerDelegate <NSObject>
@required
-(CGFloat) layoutManager:(NSLayoutManager*)layoutManager tagPaddingForItemAtIndex:(NSUInteger)index;
@end

@interface MSTagTextView : UITextView<NSLayoutManagerDelegate, MSTagTextViewLayoutManagerDelegate>
@property (nonatomic,weak) id<MSTagTextViewDataSource> dataSource;
@property (nonatomic,weak) id<MSTagTextViewDelegate> customDelegate;
-(void) reloadData;
@end

@interface MyLayoutManager : NSLayoutManager
@property (nonatomic,weak) id<MSTagTextViewLayoutManagerDelegate> customDelegate;
@end