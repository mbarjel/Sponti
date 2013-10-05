//
//  NSArray+SPFunctional.h
//  Sponti
//
//  Created by Melad Barjel on 17/09/2013.
//  Copyright (c) 2013 FoxSports. All rights reserved.
//
//  Slightly modified version of https://github.com/zwaldowski/BlocksKit/blob/master/BlocksKit/NSArray%2BBlocksKit.h

typedef void (^SPIterationBlock)(id obj, int i);
typedef BOOL (^SPValidationBlock)(id obj);
typedef id (^SPTransformBlock)(id obj);
typedef id (^SPAccumulationBlock)(id sum, id obj);
typedef BOOL (^SPKeyValueValidationBlock)(id key, id obj);

@interface NSArray (SPFunctional)

- (id)firstObject;
- (NSIndexSet *)indexesOfObjects:(NSArray *)objects;
- (id)safeObjectAtIndex:(NSInteger)index;

/** Loops through an array and executes the given block with each object.
 
 @param block A single-argument, void-returning code block.
 */
- (void)each:(SPIterationBlock)block;

/** Loops through an array to find the object matching the block.
 
 match: is functionally identical to select:, but will stop and return
 on the first match.
 
 @param block A single-argument, `BOOL`-returning code block.
 @return Returns the object, if found, or `nil`.
 @see select:
 */
- (id)match:(SPValidationBlock)block;

/** Loops through an array to find the objects matching the block.
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of the objects found.
 @see match:
 */
- (NSArray *)select:(SPValidationBlock)block;

/** Loops through an array to find the objects not matching the block.
 
 This selector performs *literally* the exact same function as select: but in reverse.
 
 This is useful, as one may expect, for removing objects from an array.
 NSArray *new = [computers reject:^BOOL(id obj) {
 return ([obj isUgly]);
 }];
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of all objects not found.
 */
- (NSArray *)reject:(SPValidationBlock)block;

/** Call the block once for each object and create an array of the return values.
 
 This is sometimes referred to as a transform, mutating one of each object:
 NSArray *new = [stringArray map:^id(id obj) {
 return [obj stringByAppendingString:@".png"]);
 }];
 
 @param block A single-argument, object-returning code block.
 @return Returns an array of the objects returned by the block.
 */
- (NSArray *)map:(SPTransformBlock)block;

/** Arbitrarily accumulate objects using a block.
 
 The concept of this selector is difficult to illustrate in words. The sum can
 be any NSObject, including (but not limited to) an NSString, NSNumber, or NSValue.
 
 For example, you can concentate the strings in an array:
 NSString *concentrated = [stringArray reduce:@"" withBlock:^id(id sum, id obj) {
 return [sum stringByAppendingString:obj];
 }];
 
 You can also do something like summing the lengths of strings in an array:
 NSNumber *sum = [stringArray reduce:nil withBlock:^id(id sum, id obj) {
 return [NSNumber numberWithInteger: [sum integerValue] + obj.length];
 }];
 NSUInteger value = [sum integerValue];
 
 @param initial The value of the reduction at its start.
 @param block A block that takes the current sum and the next object to return the new sum.
 @return An accumulated value.
 */
- (id)reduce:(id)initial withBlock:(SPAccumulationBlock)block;

/** Loops through an array to find whether any object matches the block.
 
 This method is similar to the Scala list `exists`. It is functionally
 identical to match: but returns a `BOOL` instead. It is not recommended
 to use any: as a check condition before executing match:, since it would
 require two loops through the array.
 
 For example, you can find if a string in an array starts with a certain letter:
 
 NSString *letter = @"A";
 BOOL containsLetter = [stringArray any: ^(id obj) {
 return [obj hasPrefix: @"A"];
 }];
 
 @param block A single-argument, BOOL-returning code block.
 @return YES for the first time the block returns YES for an object, NO otherwise.
 */
- (BOOL)any:(SPValidationBlock)block;

/** Loops through an array to find whether no objects match the block.
 
 This selector performs *literally* the exact same function as all: but in reverse.
 
 @param block A single-argument, BOOL-returning code block.
 @return YES if the block returns NO for all objects in the array, NO otherwise.
 */
- (BOOL)none:(SPValidationBlock)block;

/** Loops through an array to find whether all objects match the block.
 
 @param block A single-argument, BOOL-returning code block.
 @return YES if the block returns YES for all objects in the array, NO otherwise.
 */
- (BOOL) all: (SPValidationBlock)block;

/** Tests whether every element of this array relates to the corresponding element of another array according to match by block.
 
 For example, finding if a list of numbers corresponds to their sequenced string values;
 NSArray *numbers = [NSArray arrayWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil];
 NSArray *letters = [NSArray arrayWithObjects: @"1", @"2", @"3", nil];
 BOOL doesCorrespond = [numbers corresponds: letters withBlock: ^(id number, id letter) {
 return [[number stringValue] isEqualToString: letter];
 }];
 
 @param block A two-argument, BOOL-returning code block.
 @return Returns a BOOL, true if every element of array relates to corresponding element in another array.
 */
- (BOOL) corresponds: (NSArray *) list withBlock: (SPKeyValueValidationBlock) block;

// Groups an array into an array of arrays of up to length size.
- (NSArray *)groupIntoSubArraysOfLength:(int)length;

@end

@interface NSMutableArray (FSAFunctional)

- (void)add:(NSInteger)maxCount objectsFromArray:(NSArray *)array;

@end
