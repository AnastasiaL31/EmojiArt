//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Anastasia Lulakova on 16.02.2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "🚜🏍🛴🚲🚑🚓🚕🚎🚘🍔🍕🌭🌮🍙🍰🍭🍩🥗🌞🌚⛈️❄️🔥🌈🌪🌜"
    
    private let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
                .overlay(alignment: .bottom) {
                    PaletteChooser()
                        .font(.system(size: paletteEmojiSize))
                        .padding(.horizontal)
                        .scrollIndicators(.hidden)
                        .padding(.vertical)
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .onTapGesture {
                        selectedEmojis.removeAll()
                    }
                documentContent(in: geometry)
                    .scaleEffect(zoom*(selectedEmojis.isEmpty ? gestureZoom : 1))
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture)) // recognize both at the same time
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
           
        }
    }

    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero // == CGSize
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    @State private var selectedEmojis: Set<Int> = []
    @State private var emojiZoom: CGFloat = 1
    
    private func selectEmoji(_ id: Int){
        if ifEmojiIsSelected(id) {
            selectedEmojis.remove(id)
        } else {
            selectedEmojis.insert(id)
        }
    }
    
    
    
    private var zoomGesture: some Gesture{
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                    gestureZoom = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                if selectedEmojis.isEmpty {
                    zoom *= endingPinchScale
                }
                emojiZoom *= endingPinchScale
                resizeEmojis()
                emojiZoom = 1
            }
    }
    
    private func resizeEmojis(){
        for id in selectedEmojis {
            if document.emojis.contains(where: {$0.id == id}) {
                document.zoomEmojiSize(id, to: emojiZoom)
            }
        }
    }
    
    private var panGesture : some Gesture {
        DragGesture()
            .updating($gesturePan) {value , gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded { value in
                pan += value.translation // in extens
            }
    }
    
    @ViewBuilder
    private func documentContent(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background, content: { image in
            image.resizable()},placeholder: {})
        .onTapGesture {
            selectedEmojis.removeAll()
        }
        .position(Emoji.Position.zero.in(geometry))
        
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .onTapGesture {
                    selectEmoji(emoji.id)
                }
                .background(ifEmojiIsSelected(emoji.id) ? Rectangle().border(.selection).opacity(0.3) : nil)
                .scaleEffect(ifEmojiIsSelected(emoji.id) ? emojiZoom*gestureZoom : 1)
                .position(emoji.position.in(geometry))
        }
    }
    
    
    private func ifEmojiIsSelected(_ id: Int) -> Bool {
        selectedEmojis.contains(id)
    }
    
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in  geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    position: emojiPosition(at: location, in: geometry),
                    size: paletteEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom))
    }
}


#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
