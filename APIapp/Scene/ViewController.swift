import SwiftUI

struct ViewController: View {

    // MARK: - Constants

    private enum Constant {
        enum Layout {
            static let horizontalPadding: CGFloat = 16
            static let spacing: CGFloat = 12
        }

        enum Artwork {
            static let size: CGFloat = 56
            static let cornerRadius: CGFloat = 8
        }

        enum Text {
            static let titleFontSize: CGFloat = 15
            static let subtitleFontSize: CGFloat = 13
        }
    }

    // MARK: - Properties

    @State private var tracks: [Track] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Electronic")
                .task { await loadTracks() }
                .alert("Ошибка", isPresented: .init(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )) {
                    Button("Ок", role: .cancel) { }
                } message: {
                    Text(errorMessage ?? "")
                }
        }
    }

    // MARK: - Content

    private var contentView: some View {
        Group {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(tracks.enumerated()), id: \.element.id) { index, track in
                        rowView(track, index: index)
                            .listRowInsets(EdgeInsets(
                                top: Constant.Layout.spacing / 2,
                                leading: Constant.Layout.horizontalPadding,
                                bottom: Constant.Layout.spacing / 2,
                                trailing: Constant.Layout.horizontalPadding
                            ))
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    // MARK: - Row

    private func rowView(_ track: Track, index: Int) -> some View {
        HStack(spacing: Constant.Layout.spacing) {
            indexView(index)
            artworkView(track)
            infoView(track)
            Spacer()
            durationView(track)
        }
        .padding(.vertical, 4)
    }

    private func indexView(_ index: Int) -> some View {
        Text("\(index + 1)")
            .font(.system(size: Constant.Text.subtitleFontSize))
            .foregroundStyle(.secondary)
            .frame(width: 28)
    }

    private func artworkView(_ track: Track) -> some View {
        AsyncImage(url: track.artworkURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color(.systemGray5)
                .overlay {
                    Image(systemName: "music.note")
                        .foregroundStyle(.secondary)
                }
        }
        .frame(width: Constant.Artwork.size, height: Constant.Artwork.size)
        .clipShape(RoundedRectangle(cornerRadius: Constant.Artwork.cornerRadius))
    }

    private func infoView(_ track: Track) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(track.trackName)
                .font(.system(size: Constant.Text.titleFontSize, weight: .semibold))
                .lineLimit(1)

            Text(track.artistName)
                .font(.system(size: Constant.Text.subtitleFontSize))
                .foregroundStyle(.secondary)
                .lineLimit(1)

            if let album = track.collectionName {
                Text(album)
                    .font(.system(size: Constant.Text.subtitleFontSize - 1))
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
        }
    }

    private func durationView(_ track: Track) -> some View {
        Text(track.duration)
            .font(.system(size: Constant.Text.subtitleFontSize))
            .foregroundStyle(.secondary)
            .monospacedDigit()
    }

    // MARK: - Loading

    private func loadTracks() async {
        guard !isLoading else { return }

        isLoading = true

        do {
            let result = try await MusicService.shared.fetchPage(offset: 0)
            tracks = result.results
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    ViewController()
}
