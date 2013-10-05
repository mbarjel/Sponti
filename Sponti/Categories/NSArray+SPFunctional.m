//
//  NSArray+SPFunctional.m
//  Sponti
//
//  Created by Jonas Budelmann on 17/09/2013.
//  Copyright (c) 2013 FoxSports. All rights reserved.
//

#import "NSArray+SPFunctional.h"

@implementation NSArray (SPFunctional)


- (id)firstObject {
    if (self.count) {
        return [self objectAtIndex:0];
    }
    return nil;
}

- (NSIndexSet *)indexesOfObjects:(NSArray *)objects {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id object in objects) {
        int index = [self indexOfObject:object];
        if (index != NSNotFound) {
            [indexes addIndex:index];
        }
    }
    return indexes;
}

- (id)safeObjectAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (void)each:(SPIterationBlock)block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj, idx);
	}];
}

- (id)match:(SPValidationBlock)block {
	NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return block(obj);
	}];
    
	if (index == NSNotFound)
		return nil;
    
	return [self objectAtIndex:index];
}

- (NSArray *)select:(SPValidationBlock)block {
	return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return block(obj);
	}]];
}

- (NSArray *)reject:(SPValidationBlock)block {
	return [self select:^BOOL(id obj) {
		return !block(obj);
	}];
}

- (NSArray *)map:(SPTransformBlock)block {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id value = block(obj);
		if (value)
			[result addObject:value];
	}];
    
	return result;
}

- (id)reduce:(id)initial withBlock:(SPAccumulationBlock)block {
	__block id result = initial;
    
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		result = block(result, obj);
	}];
    
	return result;
}

- (BOOL)any:(SPValidationBlock)block {
	return [self match: block] != nil;
}

- (BOOL)none:(SPValidationBlock)block {
	return [self match: block] == nil;
}

- (BOOL)all:(SPValidationBlock)block {
    __block BOOL result = YES;
    
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (!block(obj)) {
			result = NO;
			*stop = YES;
		}
	}];
    
    return result;
}

- (BOOL) corresponds: (NSArray *) list withBlock: (SPKeyValueValidationBlock) block {
    __block BOOL result = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < [list count]) {
            id obj2 = [list objectAtIndex: idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        *stop = !result;
	}];
    
    return result;
}

// Groups an array into an array of arrays of up to length size.
- (NSArray *)groupIntoSubArraysOfLength:(int)length {
    NSMutableArray *groups = [NSMutableArray array];
    int location = 0;
    int count = self.count;
    while (location < count) {
        int remaining = count - location;
        int thisCount = MIN(remaining, length);
        [groups addObject:[self subarrayWithRange:NSMakeRange(location, thisCount)]];
        location += thisCount;
    }
    return groups;
}

@end

@implementation NSMutableArray (FSAFunctional)

- (void)add:(NSInteger)maxCount objectsFromArray:(NSArray *)array {
    NSInteger addedCount = 0;
    for (id object in array) {
        if (addedCount < maxCount) {
            [self addObject:object];
            addedCount++;
        }
    }
}

@end
