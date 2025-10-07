//
//  ContentView.swift
//  GlassMenuTopBeauty
//
//  Created by Roman Kondrashov on 07.10.2025.
//

import SwiftUI


import SwiftUI


#Preview {
    GlassMenuAuuufff()
}


struct GlassMenuAuuufff: View {
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        List {
            Section("Preview") {
                Rectangle()
                    .foregroundStyle(.clear)
                    .background {
                        Image(.BG)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .onTapGesture {
                                withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                                    progress = 0
                                }
                            }
                    }
                    .overlay {
                            ExpandableGlassMenu(
                                alignment: .topLeading,
                                progress: progress
                            ) {
                                VStack(alignment: .leading, spacing: 12) {
                                    RowView(
                                        "swift",
                                        "Swift",
                                        "Modern, safe, powerful"
                                    )
                                    RowView(
                                        "swift",
                                        "Swift",
                                        "Modern, safe, powerful"
                                    )
                                    RowView(
                                        "swift",
                                        "Swift",
                                        "Modern, safe, powerful"
                                    )
                                }
                                .padding(10)
                            } label: {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.title3)
                                    .frame(
                                        width: 55,
                                        height: 55
                                    )
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                                            progress = 1
                                        }
                                    }
                            }
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                            .padding(15)
                    }
                    .frame(height: 330)
                
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            Section("Properties") {
                 Slider(value: $progress)            }
        }
    }
}


@ViewBuilder
func RowView(_ image: String, _ title: String, _ subtitle: String) -> some View {
    
    HStack(spacing: 18) {
        Image(systemName: image)
            .font(.title3)
            .symbolVariant(.fill)
            .frame(width: 45, height: 45)
            .background(.background, in: .circle)
        
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.gray)
                .lineLimit(2)
        }
    }
    .padding(10)
    .contentShape(.rect)
}

struct ExpandableGlassMenu<Content: View, Label: View>: View, Animatable {
    var alignment: Alignment
    var progress: CGFloat
    var labelSize: CGSize = .init(width: 55, height: 55)
    var cornerRadius: CGFloat = 30
    @ViewBuilder var content: Content
    @ViewBuilder var label: Label
    
    
    @State private var contentSize: CGSize = .zero
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        GlassEffectContainer {
            let widthDiff = contentSize.width - labelSize.width
            let heightDiff = contentSize.height - labelSize.height
            
            let rWidth = widthDiff * contentOpacity
            let rHeight = heightDiff * contentOpacity
            
            ZStack(alignment: alignment) {
                content
                    .compositingGroup()
                    .scaleEffect(contentScale)
                    .blur(radius: 14 * blurProgress)
                    .opacity(contentOpacity)
                    .onGeometryChange(for: CGSize.self) {
                        $0.size
                    } action: { newValue in
                        contentSize = newValue
                }
                    .fixedSize()
                    .frame(
                        width: labelSize.width + rWidth,
                        height: labelSize.height + rHeight
                    )
                label
                    .compositingGroup()
                    .blur(radius: 14 * blurProgress)
                    .opacity(1 - labelOpacity)
                    .frame(
                        width: labelSize.width,
                        height: labelSize.height
                    )
            }
            .compositingGroup() // ?>????
            .clipShape(.rect(cornerRadius: cornerRadius))
//THis is optional i can make property to make clear
            .glassEffect(.clear.interactive(), in:  .rect(cornerRadius: cornerRadius))
        }
        .scaleEffect(
            x: 1 - (blurProgress * 0.35),
            y: 1 + (blurProgress * 0.45),
            anchor: scaleAnchor
        )
        .offset(y: offset * blurProgress)
    }
    
    var labelOpacity: CGFloat {
        min(progress / 0.35, 1)
    }
    
    var contentOpacity: CGFloat {
        max(progress - 0.35, 0) / 0.65
    }
    
    var contentScale: CGFloat {
        let minAspectScale = min(labelSize.width / contentSize.width, labelSize.height / contentSize.height)
        
        return minAspectScale + (1 - minAspectScale) * progress
    }
    
    var blurProgress: CGFloat {
        return progress > 0.5 ? (1 - progress) / 0.5 : progress / 0.5
    }
    
    var offset: CGFloat {
        switch alignment {
        case .bottom, .bottomLeading, .bottomTrailing: return -75
        case .top, .topLeading, .topTrailing: return 75
            
            //Center
        default: return 0
        }
    }
    
    var scaleAnchor: UnitPoint {
        switch alignment {
        case .bottomLeading: .bottomLeading
        case .bottom: .bottom
        case .bottomTrailing: .bottomTrailing
        case .topLeading: .topLeading
        case .top: .top
        case .topTrailing: .topTrailing
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }
}
