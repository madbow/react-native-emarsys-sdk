#import "RNEmarsysInboxWrapper.h"

#import "Emarsys.h"
#import "EMSMessage.h"

@implementation RNEmarsysInboxWrapper

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(fetchMessages:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        [Emarsys.messageInbox fetchMessagesWithResultBlock:^(EMSInboxResult * _Nullable inboxResult, NSError * _Nullable error) {
            if (NULL != error) {
                reject(@"RNEmarsysWrapper", @"fetchMessages: ", error);
            } else {
                [self resolveMessages:inboxResult.messages resolver:resolve rejecter:reject methodName:@"fetchMessages" withError:error];
            }
        }];
    }
    @catch (NSException *exception) {
        reject(exception.name, exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(addTag:(NSString * _Nonnull)tag messageId:(NSString * _Nonnull)messageId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        [Emarsys.messageInbox addTag:tag forMessage:messageId completionBlock:^(NSError * _Nullable error) {
            if (NULL != error) {
                reject(@"RNEmarsysWrapper", @"addTag: ", error);
            } else {
                resolve([NSNumber numberWithBool:YES]);
            }
        }];
        
    }
    @catch (NSException *exception) {
        reject(exception.name, exception.reason, nil);
    }
}

RCT_EXPORT_METHOD(removeTag:(NSString * _Nonnull)tag messageId:(NSString * _Nonnull)messageId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        [Emarsys.messageInbox removeTag:tag fromMessage:messageId completionBlock:^(NSError * _Nullable error) {
            if (NULL != error) {
                reject(@"RNEmarsysWrapper", @"removeTag: ", error);
            } else {
                resolve([NSNumber numberWithBool:YES]);
            }
        }];
        
    }
    @catch (NSException *exception) {
        reject(exception.name, exception.reason, nil);
    }
}

- (void) resolveMessages:(NSArray * _Nonnull)messages resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject methodName: (NSString *) methodName withError: (NSError *) error {
    if (messages) {
        NSMutableArray *recMessages = [NSMutableArray array];
        for (EMSMessage *message in messages) {
            NSMutableDictionary<NSString *, NSString *> *recMessage = [self convertMessageToMap:message];
            [recMessages addObject:recMessage];
        }
        resolve(recMessages);
    } else {
        reject(@"RNEmarsysWrapper", [NSString stringWithFormat:@"%@", methodName], error);
    }
}

- (NSMutableDictionary *)convertMessageToMap:(EMSMessage *)message {
    
    NSMutableDictionary<NSString *, NSObject *> *map = [[NSMutableDictionary alloc] init];
    
    [map setObject: message.id forKey: @"messageId"];
    [map setObject: message.campaignId forKey: @"campaignId"];
    [map setObject: message.collapseId ?: @"" forKey: @"collapseId"];
    [map setObject: message.title forKey: @"title"];
    [map setObject: message.body forKey: @"body"];
    [map setObject: message.imageUrl ?: @"" forKey: @"imageUrl"];
    [map setObject: message.receivedAt forKey: @"receivedAt"];
    [map setObject: message.updatedAt ?: @"" forKey: @"updatedAt"];
    [map setObject: message.expiresAt ?: @"" forKey: @"expiresAt"];
    [map setObject: message.tags ?: @"" forKey: @"tags"];
    [map setObject: message.properties ?: @"" forKey: @"properties"];
    
    return map;
}

@end
