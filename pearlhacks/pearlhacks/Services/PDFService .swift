//
//  PDFService .swift
//  pearlhacks
//
//  Created by Yahan Yang on 2/16/25.
//

import PDFKit
import SwiftUI

struct PDFService_: View {
    @State private var pdfURL: URL?
    //var listing: Listing
    var body: some View {
        ShareLink("Save Letter", item: render())
        PDFViewer(pdfURL: render())
            .ignoresSafeArea()
            .frame(width: 400, height:700)
    }

    func render() -> URL {
        let renderer = ImageRenderer(content:
            PreApprovalLetterView()
            .frame(width: 612, height: 792)
        )

        // Save url to documents directory
        let url = URL.documentsDirectory.appending(path: "PreApprovalLetter.pdf")

        // US Letter size in points
        let letterSize = CGSize(width: 612, height: 792)
        // start renderer
        renderer.render { size, context in
            var box = CGRect(origin: .zero, size: letterSize)
            //var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            // start a new pdf page
            pdf.beginPDFPage(nil)

            // Render SwiftUI view Data on the page
            context(pdf)

            // end page and close the file
            pdf.endPage()
            pdf.closePDF()
        }

        return url
    }
}

struct PDFViewer: UIViewRepresentable {
    let pdfURL: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()

        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No updates needed here usually
    }
}

#Preview {
    PDFService_()
}
