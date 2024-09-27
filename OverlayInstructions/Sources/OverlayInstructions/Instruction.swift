//
//  Instruction.swift
//
//
//  Created by Primoz Cuvan on 15. 09. 24.
//

import Foundation

public protocol InstructionOverlayType: Hashable, CaseIterable {}

public class Instruction<InstructionType: InstructionOverlayType> {
    
    public var instructionType: InstructionType
    internal var cutoutFrame: CGRect? = nil
    internal var text: String

    public init(text: String, instructionType: InstructionType) {
        self.text = text
        self.instructionType = instructionType
    }
    
    public func getText() -> String {
        text
    }
    
    internal func getCutoutFrame() -> CGRect {
        guard let cutoutFrame = cutoutFrame else {
            assertionFailure("cutoutFrame not set for \(instructionType)")
            return .zero
        }
        return cutoutFrame
    }
}
