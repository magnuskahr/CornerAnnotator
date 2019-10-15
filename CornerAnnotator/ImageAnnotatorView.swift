//
//  ImageAnnotatorView.swift
//  CornerAnnotator
//
//  Created by Magnus Jensen on 15/10/2019.
//  Copyright © 2019 Magnus Jensen. All rights reserved.
//

import SwiftUI

struct ImageAnnotatorView: View {
    
    @State private var magnification: CGFloat = 1.0
    @State private var points = [CGPoint]() {
        didSet {
            if points.count == 4 {
                let p = Points(nv: points[0], ne: points[1], se: points[2], sv: points[3])
                self.setPoints(p, file)
                print("Trying to save")
            }
        }
    }
    
    let path: URL
    let file: String
    
    let resetPoints: (String) -> ()
    let getPoints: (String) -> (Points?)
    let setPoints: (Points, String) -> ()
    
    var imagePath: String {
        self.path.stripped + file
    }
    
    var body: some View {
        
        let magnificationGesture = MagnificationGesture(minimumScaleDelta: 0)
        .onChanged { value in
            let value = self.magnification + (value - 1)
            self.magnification = min(max(value, 0.5), 2)
        }
        .onEnded { value in
            let value = self.magnification + (value - 1)
            self.magnification = min(max(value, 0.5), 2)
        }
        
        let tapGesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
        .onEnded { value in
            if self.points.count < 4 {
                self.points.append(value.location)
            }
        }
        
        return VStack {
            Button("Reset") {
                self.points.removeAll()
                self.resetPoints(self.file)
            }
            ScrollView(.init(arrayLiteral: [.vertical, .horizontal]), showsIndicators: true) {
                ZStack {
                    
                    Image(nsImage: NSImage(byReferencingFile: imagePath)!)
                        .gesture(TapGesture(count: 2).sequenced(before: tapGesture))
                    
                    if points.count == 1 {
                        Circle()
                        .size(width: 5, height: 5)
                        .offset(points.first!)
                        .offset(x: -2.5, y: -2.5)
                            .fill(Color.red)
                    }
                    
                    Path { path in
                        var cpoints = points
                        if !cpoints.isEmpty {
                            let first = cpoints.removeFirst()
                            path.move(to: first)
                        }
                        cpoints.forEach { path.addLine(to: $0) }
                        path.closeSubpath()
                    }
                    .stroke(Color.red, lineWidth: 2)
                    .contentShape(HitTestingShape())
                }
                .scaleEffect(magnification)
                .gesture(magnificationGesture)
            }
        }.onAppear {
            if let points = self.getPoints(self.file) {
                print("ohno!")
                self.points = [
                    points.nv,
                    points.ne,
                    points.se,
                    points.sv
                ]
            }
        }
    }
    
    struct HitTestingShape : Shape {
        func path(in rect: CGRect) -> Path {
            return Path(CGRect(x: 0, y: 0, width: 0, height: 0))
        }
    }
}

struct ImageAnnotatorView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
