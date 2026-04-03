import AppKit
import SwiftUI

struct ExportSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var exportFormat: ExportFormat
    let content: String
    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Export Palette")
                    .font(.headline)
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.borderless)
            }

            Picker("Format", selection: $exportFormat) {
                ForEach(ExportFormat.allCases) { format in
                    Text(format.title).tag(format)
                }
            }

            TextEditor(text: .constant(content))
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 220)

            HStack {
                Spacer()
                Button(copied ? "Copied" : "Copy Export") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(content, forType: .string)
                    copied = true
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(450))
                        dismiss()
                    }
                }
                .disabled(copied)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(width: 420)
    }
}
