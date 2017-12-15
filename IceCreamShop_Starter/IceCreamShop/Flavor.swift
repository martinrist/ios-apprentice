/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// MARK: - FlavorAdapter
protocol FlavorAdapter {
  func update(with flavor: Flavor)
}

// MARK: - Flavor
public struct Flavor {

  // MARK: - Static Properties
  public static var chocolate: Flavor {
    return Flavor(name: "Chocolate", topColor: RGB(203, 140, 58), bottomColor: RGB(107, 46, 11))
  }

  public static var vanilla: Flavor {
    return Flavor(name: "Vanilla", topColor: RGB(251, 248, 236), bottomColor: RGB(230, 215, 171))
  }

  // MARK: - Instance Properties
  public let name: String
  public let topColor: UIColor
  public let bottomColor: UIColor

  // MARK: - Object Lifecycle
  public init?(dictionary: [String: String]) {
    guard let topColorString = dictionary["topColor"],
      let bottomColorString = dictionary["bottomColor"],
      let name = dictionary["name"],
      let topColor = UIColor(rgbaString: topColorString),
      let bottomColor = UIColor(rgbaString: bottomColorString) else {
        return nil
    }

    self.init(name: name, topColor: topColor, bottomColor: bottomColor)
  }

  public init(name: String, topColor: UIColor, bottomColor: UIColor) {
    self.name = name
    self.topColor = topColor
    self.bottomColor = bottomColor
  }
}
