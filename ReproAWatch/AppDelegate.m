//
//  AppDelegate.m
//  ReproAWatch
//
//  Created by Ronan JANVRESSE on 07/10/2015.
//  Copyright © 2015 Ronan JANVRESSE. All rights reserved.
//

#import "AppDelegate.h"
#import <HealthKit/HealthKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"test");
    HKHealthStore* healstore=[HKHealthStore new];
    NSSet* readobject = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],[HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],nil];
    NSSet* shareobject = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass], nil];
    
    [healstore requestAuthorizationToShareTypes:shareobject readTypes:readobject completion:^(BOOL success, NSError *error) {
        
        if(success == YES)
        {
            NSLog(@"Perm OK");
            NSError *error;
            HKBiologicalSexObject *bioSex = [healstore biologicalSexWithError:&error];
            switch (bioSex.biologicalSex) {
                case HKBiologicalSexNotSet:
                    // undefined
                    NSLog(@"Not set");
                    break;
                case HKBiologicalSexFemale:
                    NSLog(@"Female");
                    // ...
                    break;
                case HKBiologicalSexMale:
                    NSLog(@"Male");
                    // ...
                    break;
                }
            
            // Some weight in gram
            double weightInGram = 83400.f;

            // Create an instance of HKQuantityType and
            // HKQuantity to specify the data type and value
            // you want to update
            NSDate *now = [NSDate date];
            HKQuantityType *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            HKQuantity *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:weightInGram];

            // Create the concrete sample
            HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType
                                                                 quantity:hkQuantity
                                                                startDate:now
                                                                  endDate:now];
            // Update the weight in the health store
            [healstore saveObject:weightSample withCompletion:^(BOOL success, NSError *error) {
                // ..
            }];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
