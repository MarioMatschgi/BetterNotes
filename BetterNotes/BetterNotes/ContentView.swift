//
//  ContentView.swift
//  BetterNotes
//
//  Created by Mario Elsnig on 10.10.20.
//

import SwiftUI

// MARK: CONTENT-VIEW
struct ContentView: View {
    @State var mode: GridMode = .FixedRows
    
    @State var amt = [5, 6, 7]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.mode = ToggleMode(mode: self.mode) }) {
                    Text("Mode: \(GetModeString(mode: self.mode))")
                }
                Button(action: { }) {
                    Text("Edit")
                }
            }
            
            Divider()
            
            Grid(mode: $mode, amt: $amt)
        }
    }
    
    func ToggleMode(mode: GridMode) -> GridMode {
        if mode == .FixedRows {
            return .FixedCols
        }
        else {
            return .FixedRows
        }
    }
    
    func GetModeString(mode: GridMode) -> String {
        if mode == .FixedRows {
            return "Fixed row height"
        }
        else {
            return "Fixed col height"
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: GRID
struct Grid: View {
    @Binding var mode: GridMode
    @Binding var amt: [Int]
    
    var body: some View {
        VStack {
            if mode == .FixedRows {
                VSplitView {
                    ForEach(0..<amt.count, id: \.self) { idx in
                        Row(off: GetCellAmt(idx: idx), cols: $amt[idx])
                    }
                }
            }
            else {
                HSplitView {
                    ForEach(0..<amt.count, id: \.self) { idx in
                        Col(off: GetCellAmt(idx: idx), rows: $amt[idx])
                    }
                }
            }
        }
    }
    
    func GetCellAmt(idx: Int) -> Int {
        var off = 0
        
        for fi in 0..<idx {
            off += amt[fi]
        }
        
        return off
    }
}

// MARK: ROW
struct Row: View {
    @State var off: Int
    @Binding var cols: Int
    
    var body: some View {
        HSplitView {
            ForEach(0..<cols) { cellIdx in
                Cell(idx: off + cellIdx).padding(5)
            }
        }
    }
}

// MARK: COL
struct Col: View {
    @State var off: Int
    @Binding var rows: Int
    
    var body: some View {
        VSplitView {
            ForEach(0..<rows) { cellIdx in
                Cell(idx: off + cellIdx).padding(5)
            }
        }
    }
}

// MARK: CELL
struct Cell: View {
    @State var idx: Int
    
    @State private var fullText: String = ""
    var body: some View {
        VStack {
            MacEditorTextView(text: $fullText, isEditable: true, font: .systemFont(ofSize: 14), onEditingChanged: { }, onCommit: { }, onTextChange: { newText in
                print("N: \(newText)")
            })
        }.frame(minWidth: 20, maxWidth: .infinity, minHeight: 20, maxHeight: .infinity).background(Color.white)
    }
}

// MARK: GRID-MODE
enum GridMode {
    case FixedRows
    case FixedCols
}
