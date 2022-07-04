//
//  Color+Extension.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/1/22.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let searchBarColor = Color("searchBarColor")
    let cardBgColor    = Color("cardbgColor")
    let bgColor        = Color("bgColor")
    let labelColor     = Color("labelColor")
    let darkShadow     = Color("darkShadow")
}
