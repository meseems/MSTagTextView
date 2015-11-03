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
        NSTextStorage *textStorage = [[NSTextStorage alloc] init];
        
        // use our subclass of NSLayoutManager
        MyLayoutManager *textLayout = [[MyLayoutManager alloc] init];
        textLayout.delegate = self;
        textLayout.customDelegate = self;
        
        [textStorage addLayoutManager:textLayout];

        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
        
        [textLayout addTextContainer:textContainer];
        self = [super initWithFrame:self.frame textContainer:textContainer];
    } else {
        
    }
    return self;
    
}

-(void) reloadData;
{
    [self setDataSource:self.dataSource];
}

-(void)setDataSource:(id<MSTagTextViewDataSource>)dataSource
{
    
    if(!dataSource) {
        // Exception
    }
    _dataSource = dataSource;
    
    [self.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@"" attributes:nil]];
    
    for(int i = 0; i < [_dataSource tagTextViewNumberOfTags:self]; i++) {
        NSString *dataString = [_dataSource tagTextView:self stringForItemAtIndex:i];
        NSString *tagString = [NSString stringWithFormat:@" %@ ",dataString];
        NSUInteger lastCharacter = [self.textStorage length];
        [self.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:tagString]];
        [self.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [self.textStorage addAttribute:NSBackgroundColorAttributeName
                                 value:[_dataSource tagTextView:self colorForItemAtIndex:i]
                                 range:NSMakeRange(lastCharacter+1, [dataString length])];
    }
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    if([self.customDelegate respondsToSelector:@selector(tagTextView:tagSpacingForItemAtIndex:)]) {
        return [self.customDelegate tagTextView:self tagSpacingForItemAtIndex:glyphIndex];
    }
    return 5; // For really wide spacing; pick your own value
}

- (CGFloat) layoutManager:(NSLayoutManager *)layoutManager tagPaddingForItemAtIndex:(NSUInteger)index
{
    if([self.customDelegate respondsToSelector:@selector(tagTextView:tagPaddingForItemAtIndex:)]) {
        return [self.customDelegate tagTextView:self tagPaddingForItemAtIndex:index];
    }
    return 4; // For really wide spacing; pick your own value
}

@end

@implementation MyLayoutManager

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color
{
    CGFloat radius = 4.; // change this to change corners radius
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // One line only
    
    CGFloat spacing = 0.;
    CGFloat padding = 0.;
    
    if([self.customDelegate respondsToSelector:@selector(layoutManager:tagPaddingForItemAtIndex:)])
        padding = [self.customDelegate layoutManager:self tagPaddingForItemAtIndex:0];
    if([self.delegate respondsToSelector:@selector(layoutManager:lineSpacingAfterGlyphAtIndex:withProposedLineFragmentRect:)])
        spacing = [self.delegate layoutManager:self lineSpacingAfterGlyphAtIndex:0 withProposedLineFragmentRect:CGRectZero];
    
    if(rectCount == 1) {
        CGFloat minX = CGRectGetMinX(rectArray[0])-padding;
        CGFloat maxX = CGRectGetMaxX(rectArray[0])+padding;
        CGFloat minY = CGRectGetMinY(rectArray[0]);
        CGFloat maxY = CGRectGetMaxY(rectArray[0])-spacing;
        CGPathMoveToPoint(path, NULL,   minX+radius,minY);
        CGPathAddArcToPoint(path, NULL, minX,minY, minX, minY+radius, radius);
        CGPathAddArcToPoint(path, NULL, minX,maxY, maxX-radius, maxY, radius);
        CGPathAddArcToPoint(path, NULL, maxX,maxY, maxX, minY+radius, radius);
        CGPathAddArcToPoint(path, NULL, maxX,minY, minX+radius, minY, radius);
        CGPathCloseSubpath(path);
    } else {
        
        // First rect
        CGFloat minX = CGRectGetMinX(rectArray[0])-padding;
        CGFloat maxX = CGRectGetMaxX(rectArray[0])+padding;
        CGFloat minY = CGRectGetMinY(rectArray[0]);
        CGFloat maxY = CGRectGetMaxY(rectArray[0])-spacing;
        CGPathMoveToPoint(path, NULL,   minX+radius,minY);
        CGPathAddArcToPoint(path, NULL, minX,minY, minX, minY+radius, radius);
        CGPathAddArcToPoint(path, NULL, minX,maxY, maxX-radius, maxY, radius);
        CGPathAddLineToPoint(path, NULL, maxX,maxY);
        CGPathAddLineToPoint(path, NULL, maxX,minY);
        CGPathCloseSubpath(path);
        
        for(int i = 1; i < rectCount-1; i++) {
            minX = CGRectGetMinX(rectArray[i])-padding;
            maxX = CGRectGetMaxX(rectArray[i])+padding;
            minY = CGRectGetMinY(rectArray[i]);
            maxY = CGRectGetMaxY(rectArray[i])-spacing;
            CGPathMoveToPoint(path, NULL,   minX,minY);
            CGPathAddLineToPoint(path, NULL,   minX,maxY);
            CGPathAddLineToPoint(path, NULL,   maxX,maxY);
            CGPathAddLineToPoint(path, NULL,   maxX,minY);
            CGPathCloseSubpath(path);
        }
        
        // Last rect
        minX = CGRectGetMinX(rectArray[rectCount-1])-padding;
        maxX = CGRectGetMaxX(rectArray[rectCount-1])+padding;
        minY = CGRectGetMinY(rectArray[rectCount-1]);
        maxY = CGRectGetMaxY(rectArray[rectCount-1])-spacing;
        CGPathMoveToPoint(path, NULL,   minX,minY);
        CGPathAddLineToPoint(path, NULL,    minX,maxY);
        CGPathAddArcToPoint(path, NULL, maxX,maxY, maxX, minY+radius, radius);
        CGPathAddArcToPoint(path, NULL, maxX,minY, minX+radius, minY, radius);
        CGPathCloseSubpath(path);
    }
    
    [color set]; // set fill and stroke color
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetShouldAntialias(ctx, YES);
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextAddPath(ctx, path);
    CGPathRelease(path);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end