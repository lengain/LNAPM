//
//  LNAPMProvider.h
//  LNAPM_Example
//
//  Created by lengain on 2019/1/19.
//  Copyright © 2019 lengain@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LNAPMProvider <NSObject>

- (nullable id)provideMonitorValue;

@end


NS_ASSUME_NONNULL_END
