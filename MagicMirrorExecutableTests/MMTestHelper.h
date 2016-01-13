//
//  MMTestHelper.h
//  MagicMirror2
//
//  Created by James Tang on 14/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#ifndef MMTestHelper_h
#define MMTestHelper_h


#define XCTAssertEqualPoint(point1, point2) XCTAssertEqualObjects(NSStringFromPoint(point1), NSStringFromPoint(point2))
#define XCTAssertEqualSize(size1, size2) XCTAssertEqualObjects(NSStringFromSize(size1), NSStringFromSize(size2))

#endif /* MMTestHelper_h */
