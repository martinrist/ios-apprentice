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

@IBDesignable
class IceCreamView: UIView {

  // MARK: - Instance Properties
  fileprivate let coneOuterColor = RGB(184, 104, 50)
  fileprivate let coneInnerColor = RGB(209, 160, 102)
  fileprivate let coneLaticeColor = RGB(235, 183, 131)

  // MARK: - Outlets
  @IBInspectable var iceCreamTopColor: UIColor = Flavor.vanilla.topColor {
    didSet {
      setNeedsDisplay()
    }
  }

  @IBInspectable var iceCreamBottomColor: UIColor = Flavor.vanilla.topColor {
    didSet {
      setNeedsDisplay()
    }
  }

  // MARK: - View Lifecycle
  override func draw(_ frame: CGRect) {

    //// General Declarations
    let context = UIGraphicsGetCurrentContext()!

    //// Gradient Declarations
    let iceCreamGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                      colors: [iceCreamTopColor.cgColor, iceCreamBottomColor.cgColor] as CFArray,
                                      locations: [0, 1])!

    //// Shadow Declarations
    let coneInnerShadow = coneOuterColor
    let coneInnerShadowOffset = CGSize(width: 0.1, height: -0.1)
    let coneInnerShadowBlurRadius: CGFloat = 35
    let scoopShadow = UIColor.black.withAlphaComponent(0.25)
    let scoopShadowOffset = CGSize(width: 0.1, height: 3.1)
    let scoopShadowBlurRadius: CGFloat = 2
    let coneOuterShadow = UIColor.black.withAlphaComponent(0.35)
    let coneOuterShadowOffset = CGSize(width: 0.1, height: 3.1)
    let coneOuterShadowBlurRadius: CGFloat = 3

    //// Cone Drawing
    let conePath = UIBezierPath()
    conePath.move(to: CGPoint(x: frame.minX + 0.98284 * frame.width,
                              y: frame.minY + 0.29579 * frame.height))
    conePath.addCurve(to: CGPoint(x: frame.minX + 0.49020 * frame.width,
                                  y: frame.minY + 0.35519 * frame.height),
                      controlPoint1: CGPoint(x: frame.minX + 0.98284 * frame.width,
                                             y: frame.minY + 0.29579 * frame.height),
                      controlPoint2: CGPoint(x: frame.minX + 0.72844 * frame.width,
                                             y: frame.minY + 0.35519 * frame.height))
    conePath.addCurve(to: CGPoint(x: frame.minX + 0.01225 * frame.width,
                                  y: frame.minY + 0.29579 * frame.height),
                      controlPoint1: CGPoint(x: frame.minX + 0.25196 * frame.width,
                                             y: frame.minY + 0.35519 * frame.height),
                      controlPoint2: CGPoint(x: frame.minX + 0.01225 * frame.width,
                                             y: frame.minY + 0.29579 * frame.height))
    conePath.addLine(to: CGPoint(x: frame.minX + 0.49265 * frame.width, y: frame.minY + 0.98886 * frame.height))
    conePath.addLine(to: CGPoint(x: frame.minX + 0.98284 * frame.width, y: frame.minY + 0.29579 * frame.height))
    conePath.close()
    conePath.lineJoinStyle = CGLineJoin.round;

    context.saveGState()
    context.setShadow(offset: coneOuterShadowOffset,
                      blur: coneOuterShadowBlurRadius,
                      color: (coneOuterShadow as UIColor).cgColor)
    coneInnerColor.setFill()
    conePath.fill()

    ////// Cone Inner Shadow
    context.saveGState()
    context.clip(to: conePath.bounds)
    context.setShadow(offset: CGSize(width: 0, height: 0), blur: 0)
    context.setAlpha((coneInnerShadow as UIColor).cgColor.alpha)
    context.beginTransparencyLayer(auxiliaryInfo: nil)
    let coneOpaqueShadow = (coneInnerShadow as UIColor).withAlphaComponent(1)
    context.setShadow(offset: coneInnerShadowOffset,
                      blur: coneInnerShadowBlurRadius,
                      color: (coneOpaqueShadow as UIColor).cgColor)
    context.setBlendMode(CGBlendMode.sourceOut)
    context.beginTransparencyLayer(auxiliaryInfo: nil)

    coneOpaqueShadow.setFill()
    conePath.fill()

    context.endTransparencyLayer()
    context.endTransparencyLayer()
    context.restoreGState()

    context.restoreGState()

    coneOuterColor.setStroke()
    conePath.lineWidth = 0.5
    conePath.stroke()

    //// Lattice 1 Drawing
    let lattice1Path = UIBezierPath()
    lattice1Path.move(to: CGPoint(x: frame.minX + 0.41667 * frame.width, y: frame.minY + 0.86881 * frame.height))
    lattice1Path.addLine(to: CGPoint(x: frame.minX + 0.62255 * frame.width, y: frame.minY + 0.79950 * frame.height))
    coneLaticeColor.setStroke()
    lattice1Path.lineWidth = 1
    lattice1Path.stroke()

    //// Lattice 2 Drawing
    let lattice2Path = UIBezierPath()
    lattice2Path.move(to: CGPoint(x: frame.minX + 0.34804 * frame.width, y: frame.minY + 0.76980 * frame.height))
    lattice2Path.addLine(to: CGPoint(x: frame.minX + 0.73039 * frame.width, y: frame.minY + 0.64604 * frame.height))
    coneLaticeColor.setStroke()
    lattice2Path.lineWidth = 1
    lattice2Path.stroke()

    //// Lattice 3 Drawing
    let lattice3Path = UIBezierPath()
    lattice3Path.move(to: CGPoint(x: frame.minX + 0.27941 * frame.width, y: frame.minY + 0.67079 * frame.height))
    lattice3Path.addLine(to: CGPoint(x: frame.minX + 0.82843 * frame.width, y: frame.minY + 0.50743 * frame.height))
    coneLaticeColor.setStroke()
    lattice3Path.lineWidth = 1
    lattice3Path.stroke()

    //// Lattice 4 Drawing
    let lattice4Path = UIBezierPath()
    lattice4Path.move(to: CGPoint(x: frame.minX + 0.21078 * frame.width, y: frame.minY + 0.57178 * frame.height))
    lattice4Path.addLine(to: CGPoint(x: frame.minX + 0.92647 * frame.width, y: frame.minY + 0.36881 * frame.height))
    coneLaticeColor.setStroke()
    lattice4Path.lineWidth = 1
    lattice4Path.stroke()

    //// Lattice 5 Drawing
    let lattice5Path = UIBezierPath()
    lattice5Path.move(to: CGPoint(x: frame.minX + 0.14216 * frame.width, y: frame.minY + 0.47277 * frame.height))
    lattice5Path.addLine(to: CGPoint(x: frame.minX + 0.53431 * frame.width, y: frame.minY + 0.35891 * frame.height))
    coneLaticeColor.setStroke()
    lattice5Path.lineWidth = 1
    lattice5Path.stroke()

    //// Lattice 6 Drawing
    let lattice6Path = UIBezierPath()
    lattice6Path.move(to: CGPoint(x: frame.minX + 0.07353 * frame.width, y: frame.minY + 0.37376 * frame.height))
    lattice6Path.addLine(to: CGPoint(x: frame.minX + 0.20098 * frame.width, y: frame.minY + 0.33416 * frame.height))
    coneLaticeColor.setStroke()
    lattice6Path.lineWidth = 1
    lattice6Path.stroke()

    //// Lattice 7 Drawing
    let lattice7Path = UIBezierPath()
    coneLaticeColor.setStroke()
    lattice7Path.lineWidth = 1
    lattice7Path.stroke()

    //// Lattice 8 Drawing
    let lattice8Path = UIBezierPath()
    UIColor.black.setStroke()
    lattice8Path.lineWidth = 1
    lattice8Path.stroke()

    //// Lattice 9 Drawing
    let lattice9Path = UIBezierPath()
    lattice9Path.move(to: CGPoint(x: frame.minX + 0.64706 * frame.width, y: frame.minY + 0.76733 * frame.height))
    lattice9Path.addLine(to: CGPoint(x: frame.minX + 0.25490 * frame.width, y: frame.minY + 0.64356 * frame.height))
    coneLaticeColor.setStroke()
    lattice9Path.lineWidth = 1
    lattice9Path.stroke()

    //// Lattice 10 Drawing
    let lattice10Path = UIBezierPath()
    lattice10Path.move(to: CGPoint(x: frame.minX + 0.71569 * frame.width, y: frame.minY + 0.66832 * frame.height))
    lattice10Path.addLine(to: CGPoint(x: frame.minX + 0.16176 * frame.width, y: frame.minY + 0.50248 * frame.height))
    coneLaticeColor.setStroke()
    lattice10Path.lineWidth = 1
    lattice10Path.stroke()

    //// Lattice 11 Drawing
    let lattice11Path = UIBezierPath()
    lattice11Path.move(to: CGPoint(x: frame.minX + 0.78922 * frame.width, y: frame.minY + 0.56683 * frame.height))
    lattice11Path.addLine(to: CGPoint(x: frame.minX + 0.06373 * frame.width, y: frame.minY + 0.35891 * frame.height))
    coneLaticeColor.setStroke()
    lattice11Path.lineWidth = 1
    lattice11Path.stroke()

    //// Lattice 12 Drawing
    let lattice12Path = UIBezierPath()
    lattice12Path.move(to: CGPoint(x: frame.minX + 0.85294 * frame.width, y: frame.minY + 0.46535 * frame.height))
    lattice12Path.addLine(to: CGPoint(x: frame.minX + 0.46078 * frame.width, y: frame.minY + 0.35644 * frame.height))
    coneLaticeColor.setStroke()
    lattice12Path.lineWidth = 1
    lattice12Path.stroke()

    //// Lattice 13 Drawing
    let lattice13Path = UIBezierPath()
    lattice13Path.move(to: CGPoint(x: frame.minX + 0.92157 * frame.width, y: frame.minY + 0.37129 * frame.height))
    lattice13Path.addLine(to: CGPoint(x: frame.minX + 0.79412 * frame.width, y: frame.minY + 0.33168 * frame.height))
    coneLaticeColor.setStroke()
    lattice13Path.lineWidth = 1
    lattice13Path.stroke()

    //// Lattice 14 Drawing
    let lattice14Path = UIBezierPath()
    lattice14Path.move(to: CGPoint(x: frame.minX + 0.58333 * frame.width, y: frame.minY + 0.85891 * frame.height))
    lattice14Path.addCurve(to: CGPoint(x: frame.minX + 0.35784 * frame.width,
                                       y: frame.minY + 0.78465 * frame.height),
                           controlPoint1: CGPoint(x: frame.minX + 0.36765 * frame.width,
                                                  y: frame.minY + 0.78465 * frame.height),
                           controlPoint2: CGPoint(x: frame.minX + 0.35784 * frame.width,
                                                  y: frame.minY + 0.78465 * frame.height))
    coneLaticeColor.setStroke()
    lattice14Path.lineWidth = 1
    lattice14Path.stroke()

    //// Scoop Drawing
    let scoopPath = UIBezierPath()
    scoopPath.move(to: CGPoint(x: frame.minX + 0.39216 * frame.width, y: frame.minY + 0.35149 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width,
                                   y: frame.minY + 0.40099 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.43137 * frame.width,
                                              y: frame.minY + 0.35149 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.43137 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.58824 * frame.width,
                                   y: frame.minY + 0.35149 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.56863 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.54902 * frame.width,
                                              y: frame.minY + 0.35149 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.68627 * frame.width,
                                   y: frame.minY + 0.40099 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.62745 * frame.width,
                                              y: frame.minY + 0.35149 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.62745 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.78431 * frame.width,
                                   y: frame.minY + 0.33663 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.74510 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.74510 * frame.width,
                                              y: frame.minY + 0.33663 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.88235 * frame.width,
                                   y: frame.minY + 0.37129 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.82353 * frame.width,
                                              y: frame.minY + 0.33663 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.82353 * frame.width,
                                              y: frame.minY + 0.37129 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                   y: frame.minY + 0.30198 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.94118 * frame.width,
                                              y: frame.minY + 0.37129 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                              y: frame.minY + 0.31683 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                   y: frame.minY + 0.25248 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                              y: frame.minY + 0.28713 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                              y: frame.minY + 0.26967 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width,
                                   y: frame.minY + 0.00495 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.99020 * frame.width,
                                              y: frame.minY + 0.11577 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.77073 * frame.width,
                                              y: frame.minY + 0.00495 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                   y: frame.minY + 0.25248 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.22927 * frame.width,
                                              y: frame.minY + 0.00495 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                              y: frame.minY + 0.11577 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                   y: frame.minY + 0.30198 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                              y: frame.minY + 0.27047 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                              y: frame.minY + 0.28713 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.10784 * frame.width,
                                   y: frame.minY + 0.37624 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.00980 * frame.width,
                                              y: frame.minY + 0.31683 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.04902 * frame.width,
                                              y: frame.minY + 0.37624 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.19608 * frame.width,
                                   y: frame.minY + 0.33663 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.16667 * frame.width,
                                              y: frame.minY + 0.37624 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.15686 * frame.width,
                                              y: frame.minY + 0.33663 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.29412 * frame.width,
                                   y: frame.minY + 0.40099 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.23529 * frame.width,
                                              y: frame.minY + 0.33663 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.22549 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height))
    scoopPath.addCurve(to: CGPoint(x: frame.minX + 0.39216 * frame.width,
                                   y: frame.minY + 0.35149 * frame.height),
                       controlPoint1: CGPoint(x: frame.minX + 0.36275 * frame.width,
                                              y: frame.minY + 0.40099 * frame.height),
                       controlPoint2: CGPoint(x: frame.minX + 0.35294 * frame.width,
                                              y: frame.minY + 0.35149 * frame.height))
    scoopPath.close()
    context.saveGState()
    context.setShadow(offset: scoopShadowOffset, blur: scoopShadowBlurRadius, color: (scoopShadow as UIColor).cgColor)
    context.beginTransparencyLayer(auxiliaryInfo: nil)
    scoopPath.addClip()
    let scoopBounds = scoopPath.cgPath.boundingBoxOfPath
    context.drawLinearGradient(iceCreamGradient,
                               start: CGPoint(x: scoopBounds.midX, y: scoopBounds.minY),
                               end: CGPoint(x: scoopBounds.midX, y: scoopBounds.maxY),
                               options: CGGradientDrawingOptions())
    context.endTransparencyLayer()
    context.restoreGState()
  }
}

// MARK: - FlavorAdapter
extension IceCreamView: FlavorAdapter {
  public func update(with flavor: Flavor) {
    self.iceCreamTopColor = flavor.topColor
    self.iceCreamBottomColor = flavor.bottomColor
    setNeedsDisplay()
  }
}
