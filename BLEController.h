//
//  BLEController.h
//  Activio
//
//  Created by Magnus on 2013-05-23.
//  Copyright (c) 2013 Activio AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@protocol BLEControllerDelegate <NSObject>
/*! Rapportera nya pulsvärden
 */
- (void) newHeartRateValue:(Byte)bpm;
@end

@interface BLEController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
}

/*! Delegaten för BLEController för att rapportera newHeartRateValue.
 */
@property (nonatomic, weak) id<BLEControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *listOfperipheral;

@property (nonatomic, strong)       CBPeripheral *peripheral;

@property (nonatomic, strong)  NSString *beltNumber;

-(void)tryToConnectToPeripheral:(CBPeripheral *)aPeripheral;

/*! Scannar efter BLE-enheter
 */
- (void) startScan;

/*! Stoppa scanning */
- (void) stopScan;

- (void) connectHeartRateSensor;

/*! Avbruter anslutningen till en ansluten peripheral (eller ett pågående anslutningsförsök).
 @param silent Visa inget felmeddelande för användaren
 @param user Om anropet skedde pga att användaren valde det (då ska vi inte försöka ansluta igen)
 */
- (void) cancelConnectionSilent:(BOOL)silent byUser:(BOOL)user;

/*! Är pulsbandet anslutet?
 */
- (BOOL) isDeviceConnected;

/*! Ladda in en sparad Heart Rate Sensor från user defaults
 */
- (void) loadUserPeripheral;


/*! Är BLE OK att användas? */
@property (readonly, nonatomic) Boolean isOK;
@end
