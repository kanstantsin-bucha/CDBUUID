//
//  CDBUUID.h
//  CDBUUID
//

#import <Foundation/Foundation.h>


/**
 * The CDBUUID class provides methods for generating compact, unique ids.
 * It based on `Identify` class of https://github.com/weaver/Identify
 * but with removed ASIdentifierManager which has issue when submitting to the app store
 *
 * Ids are encoded as urlsafe base64 (letters, numbers, underscores, dashes),
 * any `=` padding is stripped off, and they are given a single character 
 * prefix.
 */


@interface CDBUUID : NSObject

/**--------------------------------------------------------------------
 * @name Class Methods
 * ---------------------------------------------------------------------
 */

/** 
 * Generate a new, unique, id. 
 *
 * This method uses `CFUUID` to create new ids. The encoded result is 23 
 * characters long.
 *
 * @return a unique id
 */
+ (NSString *)UUIDString;

/**
 * Hash together several ids to synthesize a new id.
 *
 * This method concatenates the ids together into a sha1 hash. The encoded
 * result is 28 characters long.
 *
 * @param ident any number of string ids
 * @param ... terminate `ident` sequence with `nil`
 *
 * @return a synthetic id
 */
+ (NSString *)sha1UsingUUIDStrings:(NSString *)ident, ...NS_REQUIRES_NIL_TERMINATION;

@end