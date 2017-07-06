//
//  Constants.h
//  Activio
//
//  Created by Magnus on 2013-09-25.
//  Copyright (c) 2013 Activio AB. All rights reserved.
//

// Keys för NSUserDefaults och Settings.plist
//
#define kMaxHR              @"MaxHR"            // spara maxpulsen
#define kHRSensorUUID       @"HRSensorUUID"     // spara UUID för ett pulsband
#define kMyActivioUsername  @"kUsername"        // spara myActivio username
#define kMyActivioDNNID     @"kDNNID"           // spara myActivio DNN-ID
#define kWorkoutTime        @"WorkoutTime"      // spara workout max time, styr progress-ringen runt tiden
#define kVoiceTime          @"VoiceTime"        // spara voice time, styr hur ofta pulsvärdena blir upplästa

#define kShowCalories   @"ShowCalories"
#define kShowGraph      @"ShowGraph"
#define kShowLockscreen @"ShowLockscreen"

//dodao Vlada
#define kPercentageVoice    @"EnablePercentageVoice"
//

#define kMyActivioWeight        @"kWeight"
#define kMyActivioChestBeltID   @"kChestBeltID"

#define kMyActivioUserDate      @"kMyActivioUserDate"
#define kMyActivioUserGender    @"kMyActivioUserGender"

// Identifiering för NSNotification
// anslutning av pulsband
#define kHRSensorConnectedNotification  @"com.activiofitness.activio.HRSensorConnectedNotification"
#define kHRSensorConnectedStatus        @"kHRSensorConnectedStatus"
#define kHRSensorConnectedFailStatus    @"kHRSensorConnectedFailStatus"

// myActivio.com
#define kMyActivioNotification          @"com.activiofitness.activio.MyActivioNotification"
#define kMyActivioNotConnected          @"kMyActivioNotConnected"       // kan inte ladda upp pulsdata då användaren har inte anslutit till myActivio
#define kMyActivioNetworkError          @"kMyActivioNetworkError"       // kan inte ladda pga av nätverksfel i iPhone/mobildata
#define kMyActivioUploaded              @"kMyActivioUploaded"           // lyckades att ladda upp pulsdata
#define kMyActivioUserOK                @"kMyActivioUserOK"             // användarens username och password är ok (verifierat)
#define kMyActivioUserFail              @"kMyActivioUserFail"           // verifiering misslyckades
#define kMyActivioServerFail            @"kMyActivioServerFail"         // server error
#define kMyActivioUploadUnauthorized    @"kMyActivioUploadUnauthorized" // Unauthorized problem
#define kBeltOK                         @"kBeltOK"
#define kBeltNotOK                      @"kBeltNotOK"

// Class Profile
#define kClassProfileNotification       @"classProfilesNotifications"
#define kNewProfileSelected             @"newProfileSelected"

// Kontrollera iOS-version 6.x.x eller 7.x.x
//
#define SYSTEM_IS_IOS_6     ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending) // SANT om vänster < höger
#define SYSTEM_IS_iOS_7     ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) // SANT om vänster >= höger
#define SYSTEM_IS_iOS_9     ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) // SANT om vänster >= höger

// Kontrollera specifika iOS-versioner på följande sätt:
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
/* Exempel:
 if (SYSTEM_VERSION_LESS_THAN(@"5.1")) {
    // code here
 }
 if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.2")) {
    // code here
 }
 */

static NSString *clssProfilesDefault = @"{"
"\"VTPGID\": 1,"
"\"VTPGName\": \"Name of the profile group\","
"\"VTPGDescription\": \"Some group description here\","
"\"VTPGStartDate\": \"1999-01-01T00:00:00\","
"\"VTPGEndDate\": \"2001-01-01T00:00:00\","
"\"VTProfiles\": [{"
"\"VTPID\": 1,"
"\"VTPName\": \"Easy Ride\","
"\"VTPData\": \"<VTPData vtXmlVersion=\\\"4\\\"><Views><Views /><TimeHrCoordinates><Coordinate orderIndex=\\\"1\\\" title=\\\"inledning\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>0</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"2\\\" title=\\\"inledning\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"3\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"4\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"5\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"6\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"7\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"8\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"9\\\" title=\\\"eurodancer\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"10\\\" title=\\\"eurodancer (Tungt sista 1:30)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"11\\\" title=\\\"faith\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"12\\\" title=\\\"faith\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"13\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"14\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"15\\\" title=\\\"Cannonball- stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"16\\\" title=\\\"Cannonball\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"17\\\" title=\\\"ugly heart- sittande ej under 80\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"18\\\" title=\\\"ugly heart\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"19\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"20\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"21\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"22\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"23\\\" title=\\\"every time we toutch\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"24\\\" title=\\\"every time we toutch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"25\\\" title=\\\"Budapest)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"26\\\" title=\\\"Budapest )\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"27\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"28\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2711</Time><Percent>59</Percent></Coordinate></TimeHrCoordinates><Blocks><Block orderIndex=\\\"1\\\" title=\\\"\\\" firstCoordinate=\\\"1\\\" lastCoordinate=\\\"8\\\" /><Block orderIndex=\\\"2\\\" title=\\\"\\\" firstCoordinate=\\\"9\\\" lastCoordinate=\\\"14\\\" /><Block orderIndex=\\\"3\\\" title=\\\"\\\" firstCoordinate=\\\"15\\\" lastCoordinate=\\\"18\\\" /><Block orderIndex=\\\"4\\\" title=\\\"\\\" firstCoordinate=\\\"19\\\" lastCoordinate=\\\"24\\\" /><Block orderIndex=\\\"5\\\" tite=\\\"\\\"firstCoordinate = \\\"25\\\" lastCoordinate=\\\"28\\\" /></Blocks></VTPData>\","
"\"VTPDate\": \"2011-06-10T11:16:37.187\","
"\"VTPChangedDate\": \"2011-06-13T10:37:50.64\","
"\"VTPComment\": \"That would be great, yeah\","
"\"VTPGID\": 1,"
"\"VTPPoints\": 0.0,"
"\"VTPCalories\": 0"
"},{"
"\"VTPID\": 2,"
"\"VTPName\": \"Medium Ride\","
"\"VTPData\": \"<VTPData vtXmlVersion=\\\"4\\\"><Views><Views /><TimeHrCoordinates><Coordinate orderIndex=\\\"1\\\" title=\\\"inledning\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>0</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"2\\\" title=\\\"inledning\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"3\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"4\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"5\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"6\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"7\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"8\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"9\\\" title=\\\"eurodancer\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"10\\\" title=\\\"eurodancer (Tungt sista 1:30)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"11\\\" title=\\\"faith\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"12\\\" title=\\\"faith\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"13\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"14\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"15\\\" title=\\\"Cannonball- stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"16\\\" title=\\\"Cannonball\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"17\\\" title=\\\"ugly heart- sittande ej under 80\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"18\\\" title=\\\"ugly heart\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"19\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"20\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"21\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"22\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"23\\\" title=\\\"every time we toutch\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"24\\\" title=\\\"every time we toutch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"25\\\" title=\\\"Budapest)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"26\\\" title=\\\"Budapest )\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"27\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"28\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2711</Time><Percent>59</Percent></Coordinate></TimeHrCoordinates><Blocks><Block orderIndex=\\\"1\\\" title=\\\"\\\" firstCoordinate=\\\"1\\\" lastCoordinate=\\\"8\\\" /><Block orderIndex=\\\"2\\\" title=\\\"\\\" firstCoordinate=\\\"9\\\" lastCoordinate=\\\"14\\\" /><Block orderIndex=\\\"3\\\" title=\\\"\\\" firstCoordinate=\\\"15\\\" lastCoordinate=\\\"18\\\" /><Block orderIndex=\\\"4\\\" title=\\\"\\\" firstCoordinate=\\\"19\\\" lastCoordinate=\\\"24\\\" /><Block orderIndex=\\\"5\\\" tite=\\\"\\\"firstCoordinate = \\\"25\\\" lastCoordinate=\\\"28\\\" /></Blocks></VTPData>\","
"\"VTPDate\": \"2011-06-10T11:16:37.187\","
"\"VTPChangedDate\": \"2011-06-13T10:37:50.64\","
"\"VTPComment\": \"That would be great, yeah\","
"\"VTPGID\": 1,"
"\"VTPPoints\": 0.0,"
"\"VTPCalories\": 0"
"},{"
"\"VTPID\": 3,"
"\"VTPName\": \"Hard Ride\","
"\"VTPData\": \"<VTPData vtXmlVersion=\\\"4\\\"><Views><Views /><TimeHrCoordinates><Coordinate orderIndex=\\\"1\\\" title=\\\"inledning\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>0</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"2\\\" title=\\\"inledning\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"3\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>90</Time><Percent>60</Percent></Coordinate><Coordinate orderIndex=\\\"4\\\" title=\\\"Gatorna tillhör oss - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"5\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>298</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"6\\\" title=\\\"We Found Love - sittande (eget tempo)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"7\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>511</Time><Percent>80</Percent></Coordinate><Coordinate orderIndex=\\\"8\\\" title=\\\"seek bromance - stående\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"9\\\" title=\\\"eurodancer\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>712</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"10\\\" title=\\\"eurodancer (Tungt sista 1:30)\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"11\\\" title=\\\"faith\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>909</Time><Percent>92</Percent></Coordinate><Coordinate orderIndex=\\\"12\\\" title=\\\"faith\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"13\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1093</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"14\\\" title=\\\"ggeronimo - håll pulsen på 85 hela låten\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"15\\\" title=\\\"Cannonball- stående\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1311</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"16\\\" title=\\\"Cannonball\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"17\\\" title=\\\"ugly heart- sittande ej under 80\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1504</Time><Percent>94</Percent></Coordinate><Coordinate orderIndex=\\\"18\\\" title=\\\"ugly heart\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"19\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1702</Time><Percent>84</Percent></Coordinate><Coordinate orderIndex=\\\"20\\\" title=\\\"Black pearl\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"21\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>1903</Time><Percent>89</Percent></Coordinate><Coordinate orderIndex=\\\"22\\\" title=\\\"Truckers hitch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"23\\\" title=\\\"every time we toutch\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2107</Time><Percent>95</Percent></Coordinate><Coordinate orderIndex=\\\"24\\\" title=\\\"every time we toutch \\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"25\\\" title=\\\"Budapest)\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2304</Time><Percent>85</Percent></Coordinate><Coordinate orderIndex=\\\"26\\\" title=\\\"Budapest )\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"27\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"false\\\" bpm=\\\"\\\"><Time>2505</Time><Percent>75</Percent></Coordinate><Coordinate orderIndex=\\\"28\\\" title=\\\"Overjoyed\\\" useForCountdown=\\\"true\\\" bpm=\\\"\\\"><Time>2711</Time><Percent>59</Percent></Coordinate></TimeHrCoordinates><Blocks><Block orderIndex=\\\"1\\\" title=\\\"\\\" firstCoordinate=\\\"1\\\" lastCoordinate=\\\"8\\\" /><Block orderIndex=\\\"2\\\" title=\\\"\\\" firstCoordinate=\\\"9\\\" lastCoordinate=\\\"14\\\" /><Block orderIndex=\\\"3\\\" title=\\\"\\\" firstCoordinate=\\\"15\\\" lastCoordinate=\\\"18\\\" /><Block orderIndex=\\\"4\\\" title=\\\"\\\" firstCoordinate=\\\"19\\\" lastCoordinate=\\\"24\\\" /><Block orderIndex=\\\"5\\\" tite=\\\"\\\"firstCoordinate = \\\"25\\\" lastCoordinate=\\\"28\\\" /></Blocks></VTPData>\","
"\"VTPDate\": \"2011-06-10T11:16:37.187\","
"\"VTPChangedDate\": \"2011-06-13T10:37:50.64\","
"\"VTPComment\": \"That would be great, yeah\","
"\"VTPGID\": 1,"
"\"VTPPoints\": 0.0,"
"\"VTPCalories\": 0"
"}]"
"}";

// History

#define kLoginForHistory   @"LoginForHistory"
#define kUserLoggedIn       @"kUserLoggedIn"
#define kTrainingDataRecieved       @"kTrainingDataRecieved "
#define kTrainingDeleted       @"kTrainingDeleted"
#define kTrainingDeleteError @"kTrainingDeleteError"
#define kRemoveTrainingFromArray @"kRemoveTrainingFromArray"
#define kCommentEdited       @"kCommentEdited"

#define kCellImageWidth 70
#define kCellImageHeight 56
