//
//  UIApplication+Extension.swift
//  ForecastWeather
//
//  Created by soroush amini araste on 7/1/22.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
