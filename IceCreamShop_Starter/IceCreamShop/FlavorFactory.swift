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

import Foundation

public class FlavorFactory {

  public func flavorsFromPlist(named plistName: String, in bundle: Bundle = Bundle.main) -> [Flavor] {
    let path = bundle.path(forResource: plistName, ofType: "plist")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let options = PropertyListSerialization.MutabilityOptions()
    let array = try! PropertyListSerialization.propertyList(from: data, options: options, format: nil) as! [[String: String]]
    return flavors(from: array)
  }

  public func flavors(from dictionaryArray: [[String: String]]) -> [Flavor] {
    var flavors: [Flavor] = []
    for dictionary in dictionaryArray {
      if let flavor = Flavor(dictionary: dictionary) {
        flavors.append(flavor)
      }
    }
    return flavors
  }
}
