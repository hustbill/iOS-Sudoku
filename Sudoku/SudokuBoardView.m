//
//  SudokuBoardView.m
//  SudokuBoard
//
//  Created by Hua Zhang on 2/20/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "SudokuBoardView.h"
#import "SudokuBoard.h"

@interface SudokuBoardView ()

@end

@implementation SudokuBoardView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTapGesttureRecognizer];
        NSLog(@"SudokuBoardView:initWithFrame:");
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
     NSLog(@"awakeFromNib:");
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]){
        NSLog(@"SudokuBoardView:initWithCoder");
    }
    return self;
}

-(void) selectFirstAvailableCell {
    NSLog(@"selectFirstAvailableCell");
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            if (![_boardModel numberIsFixedAtRow:row Column:col]) {
                _selectedCol = col;
                _selectedRow = row;
                return;
            }
        }
    }
}

-(void) handleTap:(UITapGestureRecognizer *)sender {
    //NSLog(@"handleTap:");
    const CGPoint tapPoint = [sender locationInView:sender.view];
    const CGRect myBounds = [self bounds];
    const CGFloat gridSize = (myBounds.size.width < myBounds.size.height) ? myBounds.size.width : myBounds.size.height;
    const CGPoint center = CGPointMake(myBounds.size.width/2, myBounds.size.height/2);
    
    // compute gridOrigin and d as done in drawRect: ...
    const CGPoint origin = CGPointMake(center.x - gridSize/2, center.y - gridSize/2);
    const CGFloat delta = gridSize / 3;
    const CGFloat d = delta / 3;
    
    const int row = (int) ((tapPoint.y - origin.y) / d);
    const int col = (int) ((tapPoint.x - origin.x) / d);
    if (0 <= row && row < 9 && 0 <= col && col < 9) {
        if (row != _selectedRow || col != _selectedCol) {
            if (_boardModel != nil && ![_boardModel numberIsFixedAtRow:row Column:col]) {
                _selectedRow = row;
                _selectedCol = col;
                //NSLog(@"row=%d, col=%d", row, col);
                [self setNeedsDisplay];
            }
        }
    }
}


-(void)addTapGesttureRecognizer {
    
    UITapGestureRecognizer *tapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGestureRecongnizer.numberOfTapsRequired =1;
    [self addGestureRecognizer:tapGestureRecongnizer];
}

//Draw the grids
-(void)drawGrids: (CGRect)myBounds andNumber:(int)number
       andColour:(UIColor *)colour andRow:(int)nRow andCol:(int)nCol;{
    //NSLog(@"draw gridS");
    const CGFloat size = (myBounds.size.width <myBounds.size.height) ? myBounds.size.width -6: myBounds.size.height -6 ;
    const CGPoint myCenter = CGPointMake(myBounds.size.width/2, myBounds.size.height/2);
    const CGPoint origin = CGPointMake(myCenter.x - size/2, myCenter.y - size/2);
    const CGFloat delta = size/3;
    const CGFloat d = delta/3;
    
    //Code from Dr.Cochran's hw2 instruction begin
    UIFont *font = [UIFont boldSystemFontOfSize:30];
    const NSString *text = [NSString stringWithFormat:@"%d", number];
    const CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName:font};
    const CGFloat x = origin.x + nCol * d + 0.5*(d - textSize.width);
    const CGFloat y = origin.y + nRow * d + 0.5*(d - textSize.height);
    const CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
    [text drawInRect:textRect withAttributes:attributes];
    //Code from Dr.Cochran's hw2 instruction end
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();  //Return pointer similar as c language.
    const CGRect myBounds = self.bounds;
    const CGFloat size = (myBounds.size.width <myBounds.size.height) ? myBounds.size.width -6: myBounds.size.height -6 ;
    const CGPoint myCenter = CGPointMake(myBounds.size.width/2, myBounds.size.height/2);
    const CGPoint origin = CGPointMake(myCenter.x - size/2, myCenter.y - size/2);
    const CGFloat delta = size/3;
    const CGFloat d = delta/3;
    const CGFloat s = d/3;
    
    CGContextSetLineWidth(context, 5);
    [[UIColor blackColor] setStroke];
    CGContextAddRect(context, CGRectMake(origin.x, origin.y, size, size));
    [[UIColor lightGrayColor] setFill];
    CGContextFillRect(context, CGRectMake(origin.x + _selectedCol * d,
                                          origin.y + _selectedRow * d,
                                          d, d));
    // Draw delta squares 3x3
    for(int row = 0; row < 3; row++) {
        for(int col = 0; col < 3; col++) {
            // Draw internal delta grid 3x3
            for (int dRow = 0; dRow < 3; dRow++) {
                for (int dCol = 0; dCol < 3 ; dCol++) {
                    CGContextSetLineWidth(context, 1);
                    const int nRow = row * 3 + dRow;
                    const int nCol = col * 3 + dCol;
                    [[UIColor blackColor] setStroke];
                    CGContextAddRect(context, CGRectMake(origin.x + col * delta + dCol * d,
                                                         origin.y + row * delta + dRow * d,
                                                         d, d));
                    CGContextStrokePath(context);
                    
                    UIColor *colour = [UIColor blackColor];  //set the color of number in tile
                    if ([_boardModel numberIsFixedAtRow:nRow Column:nCol]) {
                        colour = [UIColor blackColor];
                    } else if ([_boardModel isConflictingEntryAtRow:nRow Column:nCol]) {
                        colour = [UIColor redColor];
                    } else {
                        colour = [UIColor blueColor];
                    }
                    int number = [_boardModel numberAtRow:nRow Column:nCol];
                    
                    if (number != 0 && ![_boardModel anyPencilsSetAtRow:nRow Column:nCol]) {
                        [self drawGrids:myBounds
                              andNumber:number
                              andColour:colour
                                 andRow:nRow
                                 andCol:nCol];
                       
                    } else if ([_boardModel anyPencilsSetAtRow:nRow Column:nCol]) {
                        //Draw internal grids when pencil is enabled
                        for (int sRow = 0; sRow < 3; sRow++) {
                            for (int sCol = 0; sCol < 3 ; sCol++) {
                                CGContextSetLineWidth(context, 1);
                                [[UIColor blackColor] setStroke];
                                CGContextAddRect(context, CGRectMake(origin.x + col * delta + dCol * d + sCol * s,
                                                                     origin.y + row * delta + dRow * d + sRow * s,
                                                                     s, s));
                                CGContextStrokePath(context);
                                const int sNum = sRow * 3 + sCol + 1;
                                if ([_boardModel isSetPencil:sNum AtRow:nRow Column:nCol]) {
                                    UIFont *font = [UIFont boldSystemFontOfSize:12];
                                    [[UIColor blackColor] setFill];
                                    const NSString *text = [NSString stringWithFormat:@"%d", sNum];
                                    const CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
                                    const CGFloat x = origin.x + nCol * d + s * sCol + 0.5*(s - textSize.width);
                                    const CGFloat y = origin.y + nRow * d + s * sRow + 0.5*(s - textSize.height);
                                    const CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
                                    [text drawInRect:textRect withAttributes:@{NSFontAttributeName:font}];
                                }
                            }
                        }
                    }
                }
            }
            CGContextSetLineWidth(context, 3);
            [[UIColor blackColor] setStroke];
            CGContextAddRect(context, CGRectMake(origin.x + col * delta, origin.y + row * delta, delta, delta));
            CGContextStrokePath(context);
        }
    }
    
}

@end
