//
//  JumioMobileSDKNetverify.m
//
//  Copyright © 2018 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKNetverify.h"
#import "AppDelegate.h"
@import Netverify;

@interface JumioMobileSDKNetverify() <NetverifyViewControllerDelegate>

@property (nonatomic, strong) NetverifyViewController *netverifyViewController;
@property (strong) NetverifyConfiguration* netverifyConfiguration;

@end

@implementation JumioMobileSDKNetverify

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventError", @"EventDocumentData"];
}

RCT_EXPORT_METHOD(initNetverify:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initNetverifyWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

RCT_EXPORT_METHOD(enableEMRTD) {
    // only working on android
    // method does nothing!
}

- (void)initNetverifyHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    
    // Initialization
    _netverifyConfiguration = [NetverifyConfiguration new];
    _netverifyConfiguration.delegate = self;
    _netverifyConfiguration.merchantApiToken = apiToken;
    _netverifyConfiguration.merchantApiSecret = apiSecret;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    _netverifyConfiguration.dataCenter = ([dataCenterLowercase isEqualToString: @"eu"]) ? JumioDataCenterEU : JumioDataCenterUS;
    
    // Configuration
    if (![options isEqual:[NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"requireVerification"]) {
                _netverifyConfiguration.requireVerification = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"callbackUrl"]) {
                _netverifyConfiguration.callbackUrl = [options objectForKey: key];
            } else if ([key isEqualToString: @"requireFaceMatch"]) {
                _netverifyConfiguration.requireFaceMatch = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"preselectedCountry"]) {
                _netverifyConfiguration.preselectedCountry = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantScanReference"]) {
                _netverifyConfiguration.merchantScanReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantReportingCriteria"]) {
                _netverifyConfiguration.merchantReportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerId"]) {
                _netverifyConfiguration.customerId = [options objectForKey: key];
            } else if ([key isEqualToString: @"additionalInformation"]) {
                _netverifyConfiguration.additionalInformation = [options objectForKey: key];
            } else if ([key isEqualToString: @"sendDebugInfoToJumio"]) {
                _netverifyConfiguration.sendDebugInfoToJumio = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"dataExtractionOnMobileOnly"]) {
                _netverifyConfiguration.dataExtractionOnMobileOnly = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"cameraPosition"]) {
                NSString *cameraString = [[options objectForKey: key] lowercaseString];
                JumioCameraPosition cameraPosition = ([cameraString isEqualToString: @"front"]) ? JumioCameraPositionFront : JumioCameraPositionBack;
                _netverifyConfiguration.cameraPosition = cameraPosition;
            } else if ([key isEqualToString: @"preselectedDocumentVariant"]) {
                NSString *variantString = [[options objectForKey: key] lowercaseString];
                NetverifyDocumentVariant variant = ([variantString isEqualToString: @"paper"]) ? NetverifyDocumentVariantPaper : NetverifyDocumentVariantPlastic;
                _netverifyConfiguration.preselectedDocumentVariant = variant;
            } else if ([key isEqualToString: @"documentTypes"]) {
                NSMutableArray *jsonTypes = [options objectForKey: key];
                NetverifyDocumentType documentTypes = 0;
                
                int i;
                for (i = 0; i < [jsonTypes count]; i++) {
                    id type = [jsonTypes objectAtIndex: i];
                    
                    if ([[type lowercaseString] isEqualToString: @"passport"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypePassport;
                    } else if ([[type lowercaseString] isEqualToString: @"driver_license"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeDriverLicense;
                    } else if ([[type lowercaseString] isEqualToString: @"identity_card"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeIdentityCard;
                    } else if ([[type lowercaseString] isEqualToString: @"visa"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeVisa;
                    }
                }
                
                _netverifyConfiguration.preselectedDocumentTypes = documentTypes;
            }
        }
    }
    
    // Customization
    //if (![customization isEqual:[NSNull null]]) {
        //for (NSString *key in customization) {
            //if ([key isEqualToString: @"disableBlur"]) {
                //[[NetverifyBaseView netverifyAppearance] setDisableBlur: @YES];
            //} else {
              #define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
              // Below you find the corresponding settings to your changes on the
              // main screen.
              // NavigationBar tintColor
              [[UINavigationBar netverifyAppearance] setTintColor: RGBA(97,91,115,1)];
              // NavigationBar textTitleColor
              [[UINavigationBar netverifyAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:RGBA(97,91,115,1)}];
              // General appearance - foreground color
              [[NetverifyBaseView netverifyAppearance] setForegroundColor: RGBA(97,91,115,1)];
              // Document Selection Button (State: Normal) - Background Color
              [[NetverifyDocumentSelectionButton netverifyAppearance] setBackgroundColor: RGBA(255,255,255,1) forState:UIControlStateNormal];
              // Document Selection Button (State: Normal) - Icon Color
              [[NetverifyDocumentSelectionButton netverifyAppearance] setIconColor: RGBA(127,72,251,1) forState:UIControlStateNormal];
              // Document Selection Button (State: Normal) - Title Color
              [[NetverifyDocumentSelectionButton netverifyAppearance] setTitleColor: RGBA(97,91,115,1) forState:UIControlStateNormal];
              // Document Selection Header (State: Normal) - Background Color
              [[NetverifyDocumentSelectionHeaderView netverifyAppearance] setBackgroundColor: RGBA(255,255,255,1)];
              // Document Selection Header (State: Normal) - Icon Color
              [[NetverifyDocumentSelectionHeaderView netverifyAppearance] setIconColor: RGBA(127,72,251,1)];
              // Document Selection Header (State: Normal) - Title Color
              [[NetverifyDocumentSelectionHeaderView netverifyAppearance] setTitleColor: RGBA(97,91,115,1)];
              // Positive Button - Background Color
              [[NetverifyPositiveButton netverifyAppearance] setBackgroundColor: RGBA(127,72,251,1) forState:UIControlStateNormal];
              // Negative Button - Border Color
              [[NetverifyNegativeButton netverifyAppearance] setBorderColor: RGBA(97,91,115,1)];
              // Negative Button - Title Color
              [[NetverifyNegativeButton netverifyAppearance] setTitleColor: RGBA(97,91,115,1) forState:UIControlStateNormal];
              // Fallback Button Background Color
              [[NetverifyFallbackButton netverifyAppearance] setBackgroundColor: RGBA(255,255,255,1) forState:UIControlStateNormal];
              // Fallback Button Border Color
              [[NetverifyFallbackButton netverifyAppearance] setBorderColor: RGBA(230,232,240,1)];
              // Fallback Button Title Color
              [[NetverifyFallbackButton netverifyAppearance] setTitleColor: RGBA(127,72,251,1) forState:UIControlStateNormal];
              // Color Overlay Standard Color
              [[NetverifyScanOverlayView netverifyAppearance] setColorOverlayStandard: RGBA(127,72,251,1)];
              // Color Overlay Valid Color
              [[NetverifyScanOverlayView netverifyAppearance] setColorOverlayValid: RGBA(255,255,255,1)];
              // Color Overlay Invalid Color
              [[NetverifyScanOverlayView netverifyAppearance] setColorOverlayInvalid: RGBA(255,255,255,1)];
         //   }
      //  }
    //}
    
    _netverifyViewController = [[NetverifyViewController alloc] initWithConfiguration: _netverifyConfiguration];
}

RCT_EXPORT_METHOD(startNetverify) {
    if (_netverifyViewController == nil) {
        NSLog(@"The Netverify SDK is not initialized yet. Call initNetverify() first.");
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [delegate.window.rootViewController presentViewController: _netverifyViewController animated:YES completion: nil];
    });
}

#pragma mark - Netverify Delegates

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishWithDocumentData:(NetverifyDocumentData *)documentData scanReference:(NSString *)scanReference {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS"];
  
    [result setValue: documentData.selectedCountry forKey: @"selectedCountry"];
    if (documentData.selectedDocumentType == NetverifyDocumentTypePassport) {
        [result setValue: @"PASSPORT" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeDriverLicense) {
        [result setValue: @"DRIVER_LICENSE" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeIdentityCard) {
        [result setValue: @"IDENTITY_CARD" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeVisa) {
        [result setValue: @"VISA" forKey: @"selectedDocumentType"];
    }
    [result setValue: documentData.idNumber forKey: @"idNumber"];
    [result setValue: documentData.personalNumber forKey: @"personalNumber"];
    [result setValue: [formatter stringFromDate: documentData.issuingDate] forKey: @"issuingDate"];
    [result setValue: [formatter stringFromDate: documentData.expiryDate] forKey: @"expiryDate"];
    [result setValue: documentData.issuingCountry forKey: @"issuingCountry"];
    [result setValue: documentData.lastName forKey: @"lastName"];
    [result setValue: documentData.firstName forKey: @"firstName"];
    [result setValue: documentData.middleName forKey: @"middleName"];
    [result setValue: [formatter stringFromDate: documentData.dob] forKey: @"dob"];
    if (documentData.gender == NetverifyGenderM) {
        [result setValue: @"m" forKey: @"gender"];
    } else if (documentData.gender == NetverifyGenderF) {
        [result setValue: @"f" forKey: @"gender"];
    }
    [result setValue: documentData.originatingCountry forKey: @"originatingCountry"];
    [result setValue: documentData.addressLine forKey: @"addressLine"];
    [result setValue: documentData.city forKey: @"city"];
    [result setValue: documentData.subdivision forKey: @"subdivision"];
    [result setValue: documentData.postCode forKey: @"postCode"];
    [result setValue: documentData.optionalData1 forKey: @"optionalData1"];
    [result setValue: documentData.optionalData2 forKey: @"optionalData2"];
    if (documentData.extractionMethod == NetverifyExtractionMethodMRZ) {
        [result setValue: @"MRZ" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodOCR) {
        [result setValue: @"OCR" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodBarcode) {
        [result setValue: @"BARCODE" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodBarcodeOCR) {
        [result setValue: @"BARCODE_OCR" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodNone) {
        [result setValue: @"NONE" forKey: @"extractionMethod"];
    }
    
    // MRZ data if available
    if (documentData.mrzData != nil) {
        NSMutableDictionary *mrzData = [[NSMutableDictionary alloc] init];
        if (documentData.mrzData.format == NetverifyMRZFormatMRP) {
            [mrzData setValue: @"MRP" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatTD1) {
            [mrzData setValue: @"TD1" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatTD2) {
            [mrzData setValue: @"TD2" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatCNIS) {
            [mrzData setValue: @"CNIS" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatMRVA) {
            [mrzData setValue: @"MRVA" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatMRVB) {
            [mrzData setValue: @"MRVB" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatUnknown) {
            [mrzData setValue: @"UNKNOWN" forKey: @"format"];
        }
        
        [mrzData setValue: documentData.mrzData.line1 forKey: @"line1"];
        [mrzData setValue: documentData.mrzData.line2 forKey: @"line2"];
        [mrzData setValue: documentData.mrzData.line3 forKey: @"line3"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.idNumberValid] forKey: @"idNumberValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.dobValid] forKey: @"dobValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.expiryDateValid] forKey: @"expiryDateValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.personalNumberValid] forKey: @"personalNumberValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.compositeValid] forKey: @"compositeValid"];
        [result setValue: mrzData forKey: @"mrzData"];
    }
	
	[result setValue: scanReference forKey: @"scanReference"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentData" body: result];
    }];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didCancelWithError:(NSError *)error scanReference:(NSString *)scanReference {
  [self sendError: error scanReference: scanReference];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishInitializingWithError:(NSError *)error {
  if (error != nil) {
    [self sendError: error scanReference: nil];
  }
}

# pragma mark - Helper methods

- (void) sendError:(NSError *)error scanReference:(NSString *)scanReference {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setValue: [NSNumber numberWithInteger: error.code] forKey: @"errorCode"];
	[result setValue: error.localizedDescription forKey: @"errorMessage"];
	if (scanReference) {
		[result setValue: scanReference forKey: @"scanReference"];
	}

	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
    	[self sendEventWithName: @"EventError" body: result];
	}];
}

- (BOOL) getBoolValue:(NSObject *)value {
    if (value && [value isKindOfClass: [NSNumber class]]) {
        return [((NSNumber *)value) boolValue];
    }
    return value;
}

- (UIColor *)colorWithHexString:(NSString *)str_HEX {
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str_HEX UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

@end
