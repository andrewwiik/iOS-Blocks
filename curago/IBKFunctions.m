#import <Foundation/Foundation.h>

#import "IBKFunctions.h"

struct SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}