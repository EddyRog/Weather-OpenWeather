//
//  SettingEntity+CoreDataProperties.swift
//  Weather-OpenWeather
//
//  Created by Eddy R on 05/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//
//

import Foundation
import CoreData


extension SettingEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingEntity> {
        return NSFetchRequest<SettingEntity>(entityName: "SettingEntity")
    }

    @NSManaged public var isDownloaded: Bool

}
