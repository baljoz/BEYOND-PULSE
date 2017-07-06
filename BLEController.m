//
//  BLEController.m
//  Activio
//
//  Created by Magnus on 2013-05-23. Updated for iOS 9 oct-15.
//  Copyright (c) 2013 Activio AB. All rights reserved.
//

#import "BLEController.h"

@interface BLEController ()
@property (readwrite, nonatomic)    Boolean isOK;
@property (nonatomic, assign)       Boolean userDisconnected;

@property (nonatomic, strong)       NSString *UUID;
@end

@implementation BLEController {

    CBCentralManager *manager;
    //CBPeripheral* peripheral;
    CBUUID *deviceInformationServiceUUID;
    CBUUID *manufacturerNameCharacteristicUUID;
    CBUUID *modelNumberCharacteristicUUID;
    CBUUID *serialNumberCharacteristicUUID;
    CBUUID *heartRateServiceUUID;
    CBUUID *heartRateMeasurementCharacteristicUUID;
    CBUUID *batteryServiceUUID;
    CBUUID *batteryLevelCharacteristicUUID;
    
}

@synthesize listOfperipheral;

- (id) init {
    self = [super init];
    if (self) {
        //Initiera här.
        [self status:@"Initierar CBCentralmanager"];
        self.isOK = NO;
        self.userDisconnected = NO;
        listOfperipheral = [NSMutableArray arrayWithCapacity:5];
        
        manager = [[CBCentralManager alloc]
                          initWithDelegate:self
                          queue:dispatch_get_main_queue()
                          options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
       // manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        
         [self setupCBUUID];
        
    }
    return self; 
}

/*! Ställ in de services och characteristics vi använder
 */
- (void) setupCBUUID {
    deviceInformationServiceUUID = [CBUUID UUIDWithString:@"180A"];
    heartRateServiceUUID = [CBUUID UUIDWithString:@"180D"];
    batteryServiceUUID = [CBUUID UUIDWithString:@"180F"];
    manufacturerNameCharacteristicUUID = [CBUUID UUIDWithString:@"2A29"];
    modelNumberCharacteristicUUID = [CBUUID UUIDWithString:@"2A24"];
    serialNumberCharacteristicUUID = [CBUUID UUIDWithString:@"2A25"];
    heartRateMeasurementCharacteristicUUID = [CBUUID UUIDWithString:@"2A37"];
    batteryLevelCharacteristicUUID = [CBUUID UUIDWithString:@"2A19"];
}

//Anropas efter att CBCentralManager har skapats   (U kom je stanju kontroler i da li postoji)
- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    [self status:@"BLEController - centralManagerDidUpdateState"];
    
    self.isOK = NO;

    switch (central.state) {
        case CBManagerStatePoweredOff:
            [self status:@"Bluetooth is currently powered off."];
            //[self.delegate bleStatus:0];
            self.isOK = NO;
            if (self.peripheral)
                [self cancelConnectionSilent:YES byUser:NO];
            break;
        case CBManagerStatePoweredOn:
            [self status:@"Bluetooth is currently powered on and ready to use."];
            self.isOK = YES;
            //[self.delegate bleStatus:1];
            [self connectHeartRateSensor];
            break;
        case CBManagerStateResetting:
            [self status:@"The connection with the system service was momentarily lost (resetting)."];
            //[self.delegate bleStatus:2];
            break;
        case CBManagerStateUnauthorized:
            [self status:@"The app is not authorized to use Bluetooth Low Energy."];
            //[self.delegate bleStatus:3];
            break;
        case CBManagerStateUnknown:
            [self status:@"The current state of the central manager is unknown."];
            //[self.delegate bleStatus:4];
            break;
        case CBManagerStateUnsupported:
            [self status:@"The platform does not support Bluetooth Low Energy."];
            //[self.delegate bleStatus:5];
            break;
        default:
            [self status:@"Unknown state."];
            //[self.delegate bleStatus:6];
            break;
    }
}

/*! Anslut automatiskt till ett sparat pulsband
 */
- (void) connectHeartRateSensor
{
    NSLog(@"Anslut till ett sparat pulsband!");
    if (self.isOK)
        [self loadUserPeripheral];
    else
        NSLog(@"Bluetooth is not ready!");
}

//Scannar efter Heart Rate Monitor (skenira uredjaje)
- (void) startScan {
    if (self.isOK)
    {
        [listOfperipheral removeAllObjects];
        
            NSLog(@"Finns ingen ansluten enhet till systemet, sök istället med scanForPeripheralsWithServices:");
                 [manager scanForPeripheralsWithServices:@[heartRateServiceUUID] options:nil];
         //   }
      
           }
}

// Stänger anslutningen till en ansluten peripheral  (prekida konekciju)
- (void) cancelConnectionSilent:(BOOL)silent byUser:(BOOL)user
{
    NSLog(@"cancelConnection");
    
    self.userDisconnected = user;
    
    if (self.peripheral)
    {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0 // 70000
        // iOS 6
        NSString *uuidString = [self UUIDString:self.peripheral.UUID];
#else
        // iOS 7 and above
        NSString *uuidString  = [self.peripheral.identifier UUIDString];
#endif
        
        if ([uuidString isEqualToString:self.UUID])
        {
            
                switch (self.peripheral.state)
                {
                    case CBPeripheralStateConnected:
                    case CBPeripheralStateConnecting:
                        NSLog(@"cancelPeripheralConnection identifier: %@", self.peripheral.identifier);
                        [manager cancelPeripheralConnection:self.peripheral];
                        break;
                        
                    default:
                        NSLog(@"Peripheral: %@ är inte ansluten", self.peripheral.name);
                        break;
                }
            }
                   }
        else
        {
            //Detta innebär att UUID i vår sparade peripheral inte längre stämmer med UUID på vår anslutna peripheral (iOS 6 uppvisar detta märkliga beteende ibland...)
            NSLog(@"Sparat UUID stämmer inte med sparad peripherals UUID!");
            
            // om användaren trycker på unpair utan att bandet har hunnits kopplas upp (inte påslaget) så bör vi inte visa något fel
            if (self.UUID == nil) {
                NSLog(@"Pulsbandet aldrig anslutet, visa ingen varning");
                silent = YES;
            }
            
           
        }
   
}

// Är pulsbandet anslutet?  (proverava da li je uredjaj povezan)
- (BOOL) isDeviceConnected
{
    BOOL connected = NO;
    
    if (self.peripheral)
    {
        
            switch (self.peripheral.state)
            {
                case CBPeripheralStateConnected:
                    connected = YES;
                    break;
                case CBPeripheralStateConnecting:
                case CBPeripheralStateDisconnected:
                default:
                    connected = NO;
                    break;
            }
        
    
    }
    else
        connected = NO;
    
    NSLog(@"isDeviceConnected: %@", connected ? @"YES" : @"NO");
    return connected;
}


//Stoppa scanning av BLE-enheter (prekida skeniranje uredjaja)
- (void) stopScan
{
    
    [manager stopScan];
}

//Anropas när en enhet med Heart Rate Monitor Service hittas (poziva se kada  nadje senzor)
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {

    NSLog(@"didDiscoverPeripheral\nPeripheral: %@\nRSSI: %@", aPeripheral, RSSI);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0 // 70000
    // iOS 6
    NSLog(@"UUID: %@", [self UUIDString:aPeripheral.UUID]);
#else
    // iOS 7 and above
    NSLog(@"UUID: %@", [aPeripheral.identifier UUIDString]);
#endif
    
    [self status:[NSString stringWithFormat:@"Found with name: %@\nRSSI: %@", aPeripheral.name, RSSI]];
    
    NSLog(@"Sluta scanna.");
    //Stefan komentariso
  //  [manager stopScan]; //ja sam zakomentarisao
    
    //NSLog(@"Anslut till peripheral");
    // Anslut till vår referens annars blir den dealloc'ed under anslutningen
   // self.peripheral = aPeripheral;//ja sam zakomentarisao
   // [manager connectPeripheral:self.peripheral options:nil]; //ja sam zakomentarisao
    
    // add the found HRM sensor to the scan list if new
    [self checkIfNotInList:aPeripheral];
}

-(void)checkIfNotInList:(CBPeripheral *)aPeripheral
{
    BOOL found = NO;
    
    for(CBPeripheral *listPeripheral in listOfperipheral)
    {
        //NSLog(@"UUID: %@", [self UUIDString:aPeripheral.UUID]);
        //if([[self UUIDString:per.UUID] isEqualToString:[self UUIDString:aPeripheral.UUID]])
        if([[listPeripheral.identifier UUIDString] isEqualToString:[aPeripheral.identifier UUIDString]])
            found = YES;
    }
    
    
    if(!found)
        [listOfperipheral addObject:aPeripheral];
}

-(void)tryToConnectToPeripheral:(CBPeripheral *)aPeripheral
{
    self.peripheral = aPeripheral;
    [manager connectPeripheral:aPeripheral options:nil];
}

//Anropas när en enhet blir ansluten  (kada se prikljuci uredjaj)
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    //****************************************javiti da nije uspeo!!!!****************************************
    //[[NSNotificationCenter defaultCenter] postNotificationName:kMyActivioNotification object:kBeltOK];
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:kHRSensorConnectedNotification object:kHRSensorConnectedStatus];
    
    [self status:[NSString stringWithFormat:@"didConnectPeripheral: %@", aPeripheral]];
    
    //Spara referens en gång till för det nu anslutna pulsbandet
    [self savePeripheral:aPeripheral];
    
    //Sätt oss till delegate för att ta emot events från enheten
    [self.peripheral setDelegate:self];
    
    self.userDisconnected = NO;
    
    //Upptäck fler services och därefter deras characteristics
    [self status:@"discoverServices"];
    NSArray *uuid = @[deviceInformationServiceUUID, heartRateServiceUUID, batteryServiceUUID];
    [self.peripheral discoverServices:uuid];
}

//Anropas när enheten kopplas ifrån (kada se iskljuci senzor)
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:kMyActivioNotification object:kBeltNotOK];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:kHRSensorConnectedNotification object:kHRSensorConnectedStatus];
    
	[self status:[NSString stringWithFormat:@"Disconnected from chest belt: %@ with UUID: %@", aPeripheral, [aPeripheral.identifier UUIDString]]];
    if ([error localizedDescription] != nil)
        NSLog(@"Error: %@",[error localizedDescription]);
    
    //Nollställ vår sparade UUID
    self.UUID = nil;
    
    if(aPeripheral && !self.userDisconnected)
    {
        // försök ansluta på nytt (om inte appen är på gång att avslutas)
        NSLog(@"Försök ansluta på nytt");
        [self savePeripheral:aPeripheral];
        [manager connectPeripheral:self.peripheral options:nil];
    }
}

- (void) savePeripheral:(CBPeripheral *)p {
    //Spara referens en gång till för det anslutna pulsbandet
    self.peripheral = p;
    
    // save UUID for our peripheral
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0 // 70000
    // iOS 6
    self.UUID = [self UUIDString:p.UUID];
#else
    // iOS 7 and later
    self.UUID = [p.identifier UUIDString];
#endif
    
    NSLog(@"Sparat referens för peripheral med UUID: %@", self.UUID);
}

//Anropas om en anslutning till en enhet misslyckades
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    //****************************************javiti da nije uspeo!!!!****************************************
    
    [self status:[NSString stringWithFormat:@"Failed to connect to the device: %@ (Error: %@)", aPeripheral, [error localizedDescription]]];
    
    //Nollställ vår sparade UUID
    self.UUID = nil;
    
    //Återställ vår sparade enhet
    if(aPeripheral && !self.userDisconnected)
    {
        // försök ansluta till ett sparat pulsband igen (annars sker det manuellt med en sökning)
        NSLog(@"Försök ansluta på nytt till sparat pulsband.");
        [self loadUserPeripheral];
    }
}

//Anropas efter en [discoverServices:]-begäran. Listar de Services som finns i den anslutna enheten.
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    for (CBService *aService in aPeripheral.services)
    {
        [self status:[NSString stringWithFormat:@"--- Service found with UUID: %@", aService.UUID.description]];
        
        /* Device Information Service */
        if ([aService.UUID isEqual:deviceInformationServiceUUID])
        {
            [self status:@"Found 'Device Information' service"];
            //Upptäck de characteristics vi är intresserade av i denna service
            NSArray *uuid = @[manufacturerNameCharacteristicUUID, modelNumberCharacteristicUUID, serialNumberCharacteristicUUID];
            [aPeripheral discoverCharacteristics:uuid forService:aService];
        }
        
        /* Heart Rate Service */
        if ([aService.UUID isEqual:heartRateServiceUUID])
        {
            [self status:@"Found 'Heart Rate' service"];
            //Upptäck den characteristic vi är intresserade av i denna service
            NSArray *uuid = @[heartRateMeasurementCharacteristicUUID];
            [aPeripheral discoverCharacteristics:uuid forService:aService];
        }
        
        /* Battery Service */
        if ([aService.UUID isEqual:batteryServiceUUID])
        {
            [self status:@"Found 'Battery' service"];
            //Upptäck den characteristic vi är intresserade av i denna service
            NSArray *uuid = @[batteryLevelCharacteristicUUID];
            [aPeripheral discoverCharacteristics:uuid forService:aService];
        }
    }
}

//Anropas efter en [discoverCharacteristics:forService:]-begäran. Ställ in olika värden för egenskaperna.
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if ([service.UUID isEqual:deviceInformationServiceUUID])
    {
        for (CBCharacteristic *aCharacteristic in service.characteristics)
        {
            /* Manufacturer Name */
            if ([aCharacteristic.UUID isEqual:manufacturerNameCharacteristicUUID])
            {
                NSLog(@"Found 'Device Manufacturer Name' characteristic");
                [aPeripheral readValueForCharacteristic:aCharacteristic];
            }
            
            /* Model Number */
            if ([aCharacteristic.UUID isEqual:modelNumberCharacteristicUUID])
            {
                NSLog(@"Found 'Model Number' characteristic");
                [aPeripheral readValueForCharacteristic:aCharacteristic];
            }
            
            /* Serial Number */
            if ([aCharacteristic.UUID isEqual:serialNumberCharacteristicUUID])
            {
                NSLog(@"Found 'Serial Number' characteristic");
                [aPeripheral readValueForCharacteristic:aCharacteristic];
            }
        }
    }
    
    #pragma mark Här ansluter vi till uppdateringen av pulsvärden
    
    if ([service.UUID isEqual:heartRateServiceUUID])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            /* Heart Rate Measurement */
            if ([aChar.UUID isEqual:heartRateMeasurementCharacteristicUUID])
            {
                NSLog(@"Found 'Heart Rate Measurement' characteristic");
                
                //Börja ta emot uppdateringar på HRM-värdet
                [aPeripheral setNotifyValue:YES forCharacteristic:aChar];
                
                //Spara UUID i User Defaults
                [self savePeripheralForUser];
                
                // meddelar SettingsViewController och ActivioGaugeControl att vi är anslutna nu
            //    [[NSNotificationCenter defaultCenter] postNotificationName:kHRSensorConnectedNotification object:kHRSensorConnectedStatus];
            }
        }
    }
    
    if ([service.UUID isEqual:batteryServiceUUID])
    {
        /* Battery Level */
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:batteryLevelCharacteristicUUID])
            {
                NSLog(@"Found 'Battery Level' characteristic");
                [aPeripheral readValueForCharacteristic:aChar];
            }
        }
    }
}

//Anropas efter en [readValueForCharacteristic:]-begäran eller när en notifiering tas emot.
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    /* Updated value for Heart Rate Measurement received */
    if ([characteristic.UUID isEqual:heartRateMeasurementCharacteristicUUID])
    {
        if((characteristic.value) || !error)
        {
            /* Update UI with heart rate data */
            [self updateHR:characteristic.value];
        }
    }
    /* Value for Manufacturer Name received */
    else if ([characteristic.UUID isEqual:manufacturerNameCharacteristicUUID])
    {
        NSString *manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Manufacturer Name = %@", manufacturer);
    }
    /* Value for Model Number received */
    else if ([characteristic.UUID isEqual:modelNumberCharacteristicUUID])
    {
        NSString *model = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Model Number = %@", model);
    }
    /* Value for Serial Number received */
    else if ([characteristic.UUID isEqual:serialNumberCharacteristicUUID])
    {
        NSString *serial = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Serial Number = %@", serial);
    }
    /* Value for Battery Level received */
    else if ([characteristic.UUID isEqual:batteryLevelCharacteristicUUID])
    {
        uint8_t batteryLevel = 0;
        [characteristic.value getBytes:&batteryLevel length:sizeof(batteryLevel)];
        NSLog(@"Battery Level = %d%%", batteryLevel);
    }
}

//Uppdatera HR-värdet
- (void) updateHR: (NSData *)data {
    const uint8_t *reportData = [data bytes];
    uint16_t value = 0;
    
    /* Endast debug
     int size = sizeof(reportData);
     NSLog(@"Size of reportData: %d", size);
     
     for (int i = 0; i < sizeof(reportData); i++) {
     NSLog(@"reportData[%d]: %d", i, reportData[i]);
     }
     */
    
    if ((reportData[0] & 0x01) == 0)
    {
        // uint8 bpm -- Används av Activio CSP8, UA39 och Wahoo HRM v2.0
        value = reportData[1];
    }
    else
    {
        // uint16 bpm
        NSLog(@"uint16");
        value = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
    }
    
    //Uppdatera UI
    //NSLog(@"BPM = %d", value);
    Byte bpm = 0;
    
    if ((value >= 0) && (value < 255)) {
        bpm = value;
    } else {
        bpm = 255; //255 indikerar att ngt är fel
    }
    
    //Rapportera pulsen till parent
    [self.delegate newHeartRateValue:bpm];
    
}

//Skriv ut status i appen och i loggen
- (void) status: (NSString *)str {
    NSLog(@"%@", str);
    
    //Lägg in en delegate/NSNotifier här som kan skicka status till parent-klassen.
    
    /*
     self.status.text = [NSString stringWithFormat:@"%@\n%@", self.status.text, status];
     //Scrolla ner till botten automatiskt
     NSRange range = NSMakeRange(self.status.text.length - 1, 1);
     [self.status scrollRangeToVisible:range];
     */
}

#pragma mark - Stored Peripheral

/*! Ladda in peripheral från User Defaults
 */
- (void) loadUserPeripheral
{
    if ([self isDeviceConnected]) {
        NSLog(@"Ett pulsband är redan anslutet");
        return;
    }
    NSString *uuidString = nil;
   // NSString *uuidString = [[NSUserDefaults standardUserDefaults] stringForKey:kHRSensorUUID];
    
    if (uuidString != nil) {
        NSLog(@"Kolla om UUID: %@ är en känd CBPeripheral?", uuidString);
        
                   NSUUID *nsuuid = [[NSUUID alloc] initWithUUIDString:uuidString];
            NSArray *peripherals = [manager retrievePeripheralsWithIdentifiers:@[nsuuid]];
            
            NSLog(@"retrievePeripheralsWithIdentifiers: %zd - %@", [peripherals count], peripherals);
            if (peripherals != nil && [peripherals count] > 0) {
                // ansluter automatiskt till den första i listan
                NSLog(@"Anslut till pulsbandet");
                self.peripheral = [peripherals objectAtIndex:0];
                [manager connectPeripheral:self.peripheral options:nil];
            } else {
                NSLog(@"UUID fanns inte i bland tidigare anslutna CBPeripherals.");
            }
        }
        
    
    else
    {
        NSLog(@"Finns ingen sparad UUID i User Defaults.");
    }
}

/*
 Invoked when the central manager retrieves the list of known peripherals. (iOS 6)
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"didRetrievePeripherals: count: %zd - %@", [peripherals count], peripherals);
    
    if([peripherals count] > 0)
    {
        // ansluter automatiskt till den första i listan
        NSLog(@"Anslut till pulsbandet");
        self.peripheral = [peripherals objectAtIndex:0];
        [manager connectPeripheral:self.peripheral options:nil];
    } else
    {
        NSLog(@"UUID fanns inte i bland tidigare anslutna CBPeripherals.");
    }
}

/*! Spara vår peripheral till User Defaults
 */
- (void) savePeripheralForUser
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0 // 70000
    // iOS 6
    NSString *uuidString  = [self UUIDString:self.peripheral.UUID];
#else
    // iOS 7 and above
    NSString *uuidString = [self.peripheral.identifier UUIDString];
#endif

    //[[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:kHRSensorUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Sparat i User Defaults");
}

/*! Konverterar en CFUUIDRef till en NSString (iOS 6)
 */
- (NSString *) UUIDString:(CFUUIDRef)uuid
{
    if (uuid != nil)
    {
        return (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    }
    else
    {
        return @"null";
    }
}

@end
