//
//  ImageListView.swift
//  CornerAnnotator
//
//  Created by Magnus Jensen on 15/10/2019.
//  Copyright © 2019 Magnus Jensen. All rights reserved.
//

import SwiftUI

struct ImageListView: View {
    
    let path: URL
    
    @State private var content = [String]()
    @State var provider: DataProvider
    
    var body: some View {
        List(content, id: \.self) { file in
            
            NavigationLink(destination: ImageAnnotatorView(path: self.path, file: file, resetPoints: { file in self.provider.resetPoints(for: file) }, getPoints: { file in self.provider.points(for: file) }, setPoints: {points, file in self.provider.setPoints(points, forFile: file)})) {
                Text(file)
            }
        }
        .listStyle(SidebarListStyle())
        .onAppear {
            if let content = try? FileManager.default.contentsOfDirectory(atPath: self.path.absoluteString.replacingOccurrences(of: "file://", with: "")) {
                self.content = content.filter { $0.hasSuffix(".png") || $0.hasSuffix(".jpg") }
            }
        }
    }
    
    
}

extension URL {
    var stripped: String {
        absoluteString.replacingOccurrences(of: "file://", with: "")
    }
}
