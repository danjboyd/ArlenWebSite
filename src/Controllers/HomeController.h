#import "ALNController.h"

@class ALNContext;

@interface HomeController : ALNController
- (id)landing:(ALNContext *)ctx;
- (id)docs:(ALNContext *)ctx;
- (id)docsLatest:(ALNContext *)ctx;
- (id)getStarted:(ALNContext *)ctx;
- (id)showcase:(ALNContext *)ctx;
- (id)download:(ALNContext *)ctx;
- (id)dogfood:(ALNContext *)ctx;
- (id)healthz:(ALNContext *)ctx;
@end
