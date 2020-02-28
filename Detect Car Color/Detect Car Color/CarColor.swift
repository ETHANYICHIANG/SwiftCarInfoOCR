//
//  carColors.swift
//  Detect Car Color
//
//  Created by Elias Heffan on 2/27/20.
//  Copyright © 2020 Plate OCR. All rights reserved.
//

import UIKit

struct CarColor {
    static let CarColorNames: [String:Point] = [
        "black": Point(from: UIColor(hex: 0x000000)),
        "blue": Point(from: UIColor(hex: 0x0000ff)),
        "fuchsia": Point(from: UIColor(hex: 0xff00ff)),
        "green": Point(from: UIColor(hex: 0x008000)),
        "grey": Point(from: UIColor(hex: 0x697371)),
//        "olive": Point(from: UIColor(hex: 0x515e40)),
        "purple": Point(from: UIColor(hex: 0x800080)),
        "light brown": Point(from: UIColor(hex: 0xa3675d)),
        "red": Point(from: UIColor(hex: 0xc22e40)),
        "silver": Point(from: UIColor(hex: 0xc0c0c0)),
        "teal": Point(from: UIColor(hex: 0x5aa5d0)),
        "white": Point(from: UIColor(hex: 0xffffff)),
        "yellow": Point(from: UIColor(hex: 0xffff00)),
        "orange": Point(from: UIColor(hex: 0xe86714)),
        "tan": Point(from: UIColor(hex: 0xdeb887)),
        "brown": Point(from: UIColor(hex: 0x744123)),

    ]
    
    let color: UIColor
    var name: String = ""
    
    init(from color: UIColor) {
        self.color = color
        self.name = determineName(of: color)
    }
    
    func determineName(of color: UIColor) -> String {
        let colorPoint = Point(from: color)
        let closestCarColorPoint = CarColor.CarColorNames.min(by: {$0.value.distanceSquared(to: colorPoint) < $1.value.distanceSquared(to: colorPoint)})
        return closestCarColorPoint?.key ?? ""
    }
}

extension UIColor {
    // init() functions taken from https://stackoverflow.com/questions/31782316/how-to-create-a-hex-color-string-uicolor-initializer-in-swift
    convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex:Int) {
       self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    func print() {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        Swift.print("red: ", red * 255)
        Swift.print("green: ", green * 255)
        Swift.print("blue: ", blue * 255)
        Swift.print("___")
    }
}
