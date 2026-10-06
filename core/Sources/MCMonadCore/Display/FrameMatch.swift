import CoreGraphics

/// How a window's observed frame compares with the frame mcmonad last wrote.
enum FrameObservation: Equatable {
    /// Size matches, so the write landed.
    case settled
    /// Position landed but size did not: the size should be written again.
    case sizeMismatch
    /// Position has not landed yet: wait for the next frame event.
    case positionPending
}

/// Compares an observed frame with the wanted one, within 1.5 points per edge.
func compareFrame(wanted: CGRect, actual: CGRect) -> FrameObservation {
    let positionLanded = abs(actual.origin.x - wanted.origin.x) < 1.5
                      && abs(actual.origin.y - wanted.origin.y) < 1.5
    let sizeMatches = abs(actual.width - wanted.width) < 1.5
                   && abs(actual.height - wanted.height) < 1.5
    if sizeMatches { return .settled }
    return positionLanded ? .sizeMismatch : .positionPending
}
