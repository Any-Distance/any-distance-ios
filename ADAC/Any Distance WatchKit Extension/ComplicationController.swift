// Licensed under the Any Distance Source-Available License
//
//  ComplicationController.swift
//  Any Distance WatchKit Extension
//
//  Created by Any Distance on 8/16/22.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Any Distance", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }

    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        getLocalizableSampleTemplate(for: complication) { template in
            guard let template = template else {
                handler(nil)
                return
            }
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        }
    }
    
//    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
//        // Call the handler with the timeline entries after the given date
//        handler(nil)
//    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        let onePieceImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "adac_logo")!)
        let fullColorImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "app_icon")!,
                                                               tintedImageProvider: onePieceImageProvider)
        let smallerOnePieceImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "adac_logo")!.resized(withNewWidth: 39.5))
        let smallerFullColorImageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "app_icon")!.resized(withNewWidth: 39.5),
                                                                      tintedImageProvider: smallerOnePieceImageProvider)
        let textProvider = CLKSimpleTextProvider(text: "Any Distance")

        switch complication.family {
        case .graphicCircular:
            handler(CLKComplicationTemplateGraphicCircularImage(imageProvider: fullColorImageProvider))
        case .modularSmall:
            handler(CLKComplicationTemplateModularSmallSimpleImage(imageProvider: onePieceImageProvider))
        case .modularLarge:
            handler(nil)
        case .utilitarianSmall:
            handler(CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: onePieceImageProvider))
        case .utilitarianSmallFlat:
            handler(CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider, imageProvider: onePieceImageProvider))
        case .utilitarianLarge:
            handler(CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider, imageProvider: onePieceImageProvider))
        case .circularSmall:
            handler(CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: onePieceImageProvider))
        case .extraLarge:
            handler(CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: onePieceImageProvider))
        case .graphicCorner:
            handler(CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: smallerFullColorImageProvider))
        case .graphicBezel:
            handler(nil)
        case .graphicRectangular:
            handler(CLKComplicationTemplateGraphicRectangularFullImage(imageProvider: fullColorImageProvider))
        case .graphicExtraLarge:
            handler(CLKComplicationTemplateGraphicExtraLargeCircularImage(imageProvider: fullColorImageProvider))
        @unknown default:
            handler(nil)
        }
    }
}
