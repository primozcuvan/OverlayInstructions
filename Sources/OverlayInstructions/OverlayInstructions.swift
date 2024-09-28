//
//  InstructionOverlayView.swift
//  MindfulMotion
//
//  Created by Primoz Cuvan on 14. 09. 24.
//

import SwiftUI

public enum InstructionPanelView {
    case `default`(description: String, nextButtonText: String, nextButtonAction: () -> Void)
    case custom(() -> AnyView)
    
    @ViewBuilder var view: some View {
        switch self {
        case let .default(description, nextButtonText, nextButtonAction):
            AnyView(
                VStack {
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .contentTransition(.opacity)
                        .padding()
                    
                    Button(nextButtonText) {
                        withAnimation {
                            nextButtonAction()
                        }
                    }
                    .padding()
                    .background(.secondary)
                    .clipShape(Capsule())
                    .padding(.bottom)
                }
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .shadow(radius: 2)
            )
        case .custom(let view):
            view()
        }
    }
}

public struct InstructionOverlayView<InstructionType: InstructionOverlayType>: View {
    
    @State private var cutoutFrameOpacity: CGFloat = 0.0
    
    private let instruction: Instruction<InstructionType>
    private let instructionPanelView: InstructionPanelView
    private var transitionDuration: TimeInterval
    private var cornerRadius: CGFloat
    
    public init(
        instruction: Instruction<InstructionType>,
        transitionDuration: TimeInterval = 1,
        cornerRadius: CGFloat = 10,
        instructionPanelView: InstructionPanelView
    ) {
        self.instruction = instruction
        self.instructionPanelView = instructionPanelView
        self.transitionDuration = transitionDuration
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            backgroundWithCutoutFrame
            
            instructionPanelView.view
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: Subviews

private extension InstructionOverlayView {
    
    var backgroundWithCutoutFrame: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .mask(alignment: .center) {
                CutoutMaskView(
                    cutoutFrame: instruction.getCutoutFrame(),
                    cornerRadius: getRadius(),
                    animationDuration: transitionDuration
                )
            }
            .overlay {
                border
            }
            .onAppear {
                withAnimation(.linear(duration: transitionDuration).repeatForever(autoreverses: true)) {
                    cutoutFrameOpacity = 1
                }
            }
    }
    
    var border: some View {
        let cutoutFrame = instruction.getCutoutFrame()
        return RoundedRectangle(cornerRadius: getRadius())
            .stroke(lineWidth: 2)
            .fill(.white)
            .frame(width: cutoutFrame.width, height: cutoutFrame.height)
            .position(x: cutoutFrame.midX, y: cutoutFrame.midY)
            .opacity(cutoutFrameOpacity)
    }
    
    // MARK: Helper
    
    func getRadius() -> CGFloat {
        let cutoutFrame = instruction.getCutoutFrame()
        if cutoutFrame.height > cutoutFrame.width {
            let suggestedRadius = cutoutFrame.height / cornerRadius
            return suggestedRadius < cornerRadius ? suggestedRadius : cornerRadius
        } else {
            let suggestedRadius = cutoutFrame.width / cornerRadius
            return suggestedRadius < cornerRadius ? suggestedRadius : cornerRadius
        }
    }
}
