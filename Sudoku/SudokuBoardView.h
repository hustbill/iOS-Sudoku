//
//  SudokuBoardView.h
//  SudokuBoard
//
//  Created by Hua Zhang on 2/20/14
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuBoard.h"

@interface SudokuBoardView : UIView


@property (strong, nonatomic) SudokuBoard *boardModel;
@property (assign) NSInteger selectedRow;
@property (assign) NSInteger selectedCol;

-(void) selectFirstAvailableCell;

//Draw grids.
-(void)drawGrids: (CGRect)myBounds andNumber:(int)number
       andColour:(UIColor *)colour andRow:(int)nRow andCol:(int)nCol;

@end
