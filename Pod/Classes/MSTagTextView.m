//
//  MSTagTextView.m
//  Pods
//
//  Created by Nick-Retina on 10/29/15.
//
//

#import "MSTagTextView.h"

@implementation MSTagTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        // setup text handling
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."];
        
        // use our subclass of NSLayoutManager
        MyLayoutManager *textLayout = [[MyLayoutManager alloc] init];
        
        [textStorage addLayoutManager:textLayout];

        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
        
        [textLayout addTextContainer:textContainer];
        self = [super initWithFrame:self.frame textContainer:textContainer];
    } else {
        
    }
    return self;
    
}

-(void)setDataSource:(id<MSTagTextViewDataSource>)dataSource
{
    
    if(!dataSource) {
        // Exception
    }
    _dataSource = dataSource;
    
    [self.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:nil]];
    
    for(int i = 0; i < [_dataSource tagTextViewNumberOfTags:self]; i++) {
        NSString *tagString = [NSString stringWithFormat:@" %@ ",[_dataSource tagTextView:self stringForItemAtIndex:i]];
        [self.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:tagString]];
        [self.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [self setTagWithString:tagString
                      andColor:[_dataSource tagTextView:self colorForItemAtIndex:i]];
    }
}

-(void) setTagWithString:(NSString*)aString andColor:(UIColor*)aColor
{
    
    // set some background color to our text
    [self.textStorage addAttribute:NSBackgroundColorAttributeName value:aColor range:[self.textStorage.string rangeOfString:aString]];
//    [self.textStorage setAttributes:[NSDictionary dictionaryWithObject:aColor forKey:NSBackgroundColorAttributeName] range:[self.textStorage.string rangeOfString:aString]];
}

@end

@implementation MyLayoutManager

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGFloat radius = 8.; // change this to change corners radius
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // One line only
    if(rectCount == 1) {
        CGFloat minX = CGRectGetMinX(rectArray[0]);
        CGFloat maxX = CGRectGetMaxX(rectArray[0]);
        CGFloat minY = CGRectGetMinY(rectArray[0]);
        CGFloat maxY = CGRectGetMaxY(rectArray[0]);
        CGPathMoveToPoint(path, NULL, minX,minY+radius);
        CGPathAddArcToPoint(path, NULL, minX,minY+radius, minX+radius,minY,radius);
        CGPathAddArcToPoint(path, NULL, minX+radius,minY, minX+radius,minY,radius);
        CGPathCloseSubpath(path);
    }
    
//    if (rectCount == 1
//        || (rectCount == 2 && (CGRectGetMaxX(rectArray[1]) < CGRectGetMinX(rectArray[0])))
//        )
//    {
//        // 1 rect or 2 rects without edges in contact
//        
//        CGPathAddRect(path, NULL, CGRectInset(rectArray[0], halfLineWidth, halfLineWidth));
//        if (rectCount == 2)
//            CGPathAddRect(path, NULL, CGRectInset(rectArray[1], halfLineWidth, halfLineWidth));
//    }
//    else
//    {
//        // 2 or 3 rects
//        NSUInteger lastRect = rectCount - 1;
//        
//        CGPathMoveToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);
//        
//        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
//        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
//        
//        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
//        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
//        
//        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
//        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
//        
//        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);
//        CGPathCloseSubpath(path);
//    }
    
    [color set]; // set fill and stroke color
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGContextSetAllowsAntialiasing(ctx, YES);
//    CGContextSetShouldAntialias(ctx, YES);
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end