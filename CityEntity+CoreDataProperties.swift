//
//  CityEntity+CoreDataProperties.swift
//  Weather-OpenWeather
//
//  Created by Eddy R on 20/10/2020.
//  Copyright © 2020 EddyR. All rights reserved.
//
//

import Foundation
import CoreData


extension CityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var state: String?

}
