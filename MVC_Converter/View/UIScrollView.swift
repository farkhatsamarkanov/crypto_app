import UIKit

class UIScrollView: UIView {
    @IBAction func handlePan (_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        bounds.origin.y = bounds.origin.y - translation.y
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
}
