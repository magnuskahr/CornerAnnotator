//
//  ContentView.swift
//  CornerAnnotator
//
//  Created by Magnus Jensen on 09/10/2019.
//  Copyright © 2019 Magnus Jensen. All rights reserved.
//

import SwiftUI
import AppKit

struct ChooseFolderView: View {
    
    @State var path = String()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Input folder containing images")
                HStack {
                    TextField("Path", text: $path)
                    Button(action: chooseFolder, label: { Text("Choose folder") })
                }
                Divider()
                NavigationLink(destination: Text("test")) {
                    Text("Start annotate")
                }.disabled(path.isEmpty)
            }
        }
        .padding()
    }
    
    private func chooseFolder() {
        let panel = NSOpenPanel()
        panel.title = "Select folder with images"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        if panel.runModal() == .OK {
            if let url = panel.url {
                self.path = url.absoluteString
            }
        }
    }
    
    private func startAnnotation() {
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseFolderView()
    }
}
