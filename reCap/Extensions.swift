//
//  Extensions.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/8/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation


extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}