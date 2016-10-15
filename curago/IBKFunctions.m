#import <Foundation/Foundation.h>

#import "IBKFunctions.h"

struct SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}

CGFloat IBKFloatFloorForScale(CGFloat value, CGFloat scale) {
	scale = scale == 0 ? [[UIScreen mainScreen] scale] : scale;
	return (CGFloat)((floor(value * scale)) / scale);
}