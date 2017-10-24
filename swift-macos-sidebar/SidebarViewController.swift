//
//  SidebarViewController.swift
//  swift-simple-sidebar
//
//  Created by Luka Kerr on 24/10/17.
//  Copyright © 2017 Luka Kerr. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController {
  
  @IBOutlet weak var sidebar: NSOutlineView!
  
  // Dummy data used for row titles
  let items = ["First item", "Second item", "Third item"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup notification for window losing and gaining focus
    NotificationCenter.default.addObserver(self, selector: #selector(windowLostFocus), name: NSApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(windowGainedFocus), name: NSApplication.willBecomeActiveNotification, object: nil)
  }

}

extension SidebarViewController: NSOutlineViewDataSource {
  
  // Number of items in the sidebar
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return items.count
  }
  
  // Items to be added to sidebar
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return items[index]
  }
  
  // Whether rows are expandable by an arrow
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }
  
  // Height of each row
  func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    return 40.0
  }
  
  @objc func windowLostFocus(_ notification: Notification) {
    setRowColour(sidebar, false)
  }
  
  @objc func windowGainedFocus(_ notification: Notification) {
    setRowColour(sidebar, true)
  }
  
  // When a row is selected
  func outlineViewSelectionDidChange(_ notification: Notification) {
    if let outlineView = notification.object as? NSOutlineView {
      setRowColour(outlineView, true)
    }
  }
  
  func setRowColour(_ outlineView: NSOutlineView, _ windowFocused: Bool) {
    let rows = IndexSet(integersIn: 0..<outlineView.numberOfRows)
    let rowViews = rows.flatMap { outlineView.rowView(atRow: $0, makeIfNecessary: false) }
    var initialLoad = true
    
    // Iterate over each row in the outlineView
    for rowView in rowViews {
      if rowView.isSelected {
        initialLoad = false
      }
      
      if windowFocused && rowView.isSelected {
        rowView.backgroundColor = NSColor(red: 0.99, green: 0.88, blue: 0.55, alpha: 1)
      } else if rowView.isSelected {
        rowView.backgroundColor = NSColor(red: 0.89, green: 0.89, blue: 0.88, alpha: 1)
      } else {
        rowView.backgroundColor = .clear
      }
    }
    
    if initialLoad {
      self.setInitialRowColour()
    }
  }
  
  func setInitialRowColour() {
    sidebar.rowView(atRow: 0, makeIfNecessary: true)?.backgroundColor = NSColor(red: 0.99, green: 0.88, blue: 0.55, alpha: 1)
  }
  
  // Remove default selection colour
  func outlineView(_ outlineView: NSOutlineView, didAdd rowView: NSTableRowView, forRow row: Int) {
    rowView.selectionHighlightStyle = .none
  }
  
}

extension SidebarViewController: NSOutlineViewDelegate {
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    
    if let title = item as? String {
      view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"), owner: self) as? NSTableCellView
      if let textField = view?.textField {
        textField.stringValue = title
        textField.sizeToFit()
      }
    }
    
    return view
  }
  
}
