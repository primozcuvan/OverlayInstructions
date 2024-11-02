//
//  OverlayInstructionsManager.swift
//
//
//  Created by Primoz Cuvan on 15. 09. 24.
//

import SwiftUI

// FrameCollector class that collects frames for views with InstructionType
public class OverlayInstructionsManager<InstructionType: InstructionOverlayType>: ObservableObject {
    
    @Published public var currentInstruction: Instruction<InstructionType>? = nil
    
    private var instructionsOrder: [Instruction<InstructionType>]
    public var instructionsCollection: [Instruction<InstructionType>]
    
    public init(instructionsOrder: [Instruction<InstructionType>]) {
        self.instructionsOrder = instructionsOrder
        self.instructionsCollection = instructionsOrder
    }
    
    // MARK: API
    
    public func showNextInstruction() {
        currentInstruction = instructionsCollection.isEmpty ? nil : instructionsCollection.removeFirst()
    }
    
    public func showInstructions() {
        instructionsCollection = instructionsOrder
        showNextInstruction()
    }
    
    // MARK: Internal
    
    internal func addFrame(for type: InstructionType, frame: CGRect) {
        if instructionsCollection.isEmpty {
            // In case of updates, instructionsCollection should be
            // populated in order to assign the new frame values
            instructionsCollection = instructionsOrder
        }
        let index = instructionsCollection.firstIndex(where: { $0.instructionType == type })
        guard let index, index < instructionsCollection.count else { return }
        instructionsCollection[index].cutoutFrame = frame
    }
}
