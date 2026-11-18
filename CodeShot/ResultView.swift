import SwiftUI
import UIKit

/// 顯示輸出的卡片，並提供系統分享。
struct ResultView: View {
    let image: UIImage

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 6)

                Text("這張就是之後要存到相簿的圖片。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                ShareLink(
                    item: Image(uiImage: image),
                    preview: SharePreview("程式碼截圖", image: Image(uiImage: image))
                ) {
                    Label("分享圖片", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .navigationTitle("輸出結果")
        .navigationBarTitleDisplayMode(.inline)
    }
}
