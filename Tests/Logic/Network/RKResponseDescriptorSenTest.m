//
//  RKResponseDescriptorSenTest.m
//  RestKit
//
//  Created by Kurry Tran on 12/27/13.
//  Copyright (c) 2013 RestKit. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RKTestEnvironment.h"
#import "RKTestUser.h"

@interface RKResponseDescriptorSenTest : SenTestCase
@end

@implementation RKResponseDescriptorSenTest

- (void)testBaseURLAndPathPatternIsNilDescriptorMatchesAll
{
    NSURL *baseURL = nil;
    NSURL *URL = [NSURL URLWithString:@"http://restkit.org/monkeys/1234.json"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:nil parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(YES);
}

- (void)testBaseURLIsNilAndPathPatternAndURLMatch
{
    NSURL *baseURL = nil;
    NSURL *URL = [NSURL URLWithString:@"http://restkit.org/monkeys/1234.json"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(YES);
}

- (void)testBaseURLIsNilAndPathPatternAndURLAreNotMatch
{
    NSURL *baseURL = nil;
    NSURL *URL = [NSURL URLWithString:@"http://restkit.org/mismatch"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(YES);
}

- (void)testBaseURLNotNilAndPathPatternNilAndGivenURLHostnameDoesNotMatch
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:nil parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *URL = [NSURL URLWithString:@"http://google.com/monkeys/1234.json"];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(NO);
}

- (void)testBaseURLNotNilAndPathPatternNilAndGivenURLHostnameMatch
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:nil parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *URL = [NSURL URLWithString:@"http://restkit.org/whatever"];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(YES);
}

- (void)testIdenticalPathPatternsWithDifferentBaseURL
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *otherBaseURL = [NSURL URLWithString:@"http://google.com"];
    NSURL *URL = [NSURL URLWithString:@"/monkeys/1234.json" relativeToURL:otherBaseURL];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(NO);
}

- (void)testIdenticalPathPatternsWithMatchingBaseURLAndPathAndQueryStringMatchPathPattern
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *URL = [NSURL URLWithString:@"/monkeys/1234.json" relativeToURL:baseURL];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(YES);
}

- (void)testIdenticalPathPatternsWithMatchingBaseURLAndPathAndQueryStringDoNotMatchPathPattern
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *URL = [NSURL URLWithString:@"/mismatch" relativeToURL:baseURL];
    expect([responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]).to.equal(NO);
}

- (void)testIdenticalPathPatternsWithMatchingBaseURLAndPathIncludesQueryString
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org"];
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RKTestUser class]];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMethods:RKHTTPMethodAny pathTemplateString:@"/monkeys/{monkeyID}.json" parameterConstraints:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) mapping:mapping];
    NSURL *URL = [NSURL URLWithString:@"/monkeys/1234.json?param1=val1&param2=val2" relativeToURL:baseURL];
    expect(^{ [responseDescriptor matchesURL:URL relativeToBaseURL:baseURL parameters:nil]; }).to.raise(NSInvalidArgumentException);
}

@end
