//
//  UITextview+Extensions.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 06/07/2023.
//

import UIKit


extension UITextView {
    
    func getFramesForCharacters() -> [CGRect] {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        // Convert the starting and ending positions to UITextPosition objects
        let startOffset = self.offset(from: self.beginningOfDocument, to: self.beginningOfDocument)
        let nsRange = NSRange(location: startOffset, length: text.count)
        layoutManager.ensureLayout(for: textContainer)
        
        var characterFrames = [CGRect]()
        
        // Iterate over the range of characters and retrieve the corresponding CGRect for each character
        for i in nsRange.location..<nsRange.location + nsRange.length {
            
            // Get the bounding rect for the glyph range
            let glyphRange = layoutManager.glyphRange(forCharacterRange: NSRange(location: i, length: 1), actualCharacterRange: nil)
            let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            
            // Convert the bounding rect to the coordinate system of the text view
            let glyphRectInTextView = CGRect(origin: boundingRect.origin, size: boundingRect.size)
            
            // Adjust the glyph rect for the text view's content offset and insets
            let glyphRectInTextViewAdjusted = glyphRectInTextView.offsetBy(dx: textContainerInset.left, dy: -textContainerInset.top)
            
            // Get the final frame of the glyph
            let glyphFrame = glyphRectInTextViewAdjusted.integral
            characterFrames.append(glyphFrame)
        }
        
        return characterFrames
    }
    
    func wrappedSnap(at rect: CGRect) -> UIView? {
        backgroundColor = .clear
        let test = self.resizableSnapshotView(from: rect,
                                              afterScreenUpdates: true,
                                              withCapInsets: .zero)!
//        test.frame = rect
        return test
    }
    
}








extension UITextView {
    /**
     Convert TextView to UIImage
     */
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}










extension UIColor {
    
    static func random(hue: CGFloat = CGFloat.random(in: 0...1),
                       saturation: CGFloat = CGFloat.random(in: 0.5...1), // from 0.5 to 1.0 to stay away from white
                       brightness: CGFloat = CGFloat.random(in: 0.5...1), // from 0.5 to 1.0 to stay away from black
                       alpha: CGFloat = 1) -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
