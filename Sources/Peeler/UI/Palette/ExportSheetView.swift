import AppKit
import SwiftUI

struct ExportSheetView: View {
    @Binding var exportFormat: ExportFormat
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                Button("Copy Export") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(content, forType: .string)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(width: 420)
    }
}
