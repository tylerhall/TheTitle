//
//  AppDelegate.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    lazy var mainWindowController: MainWindowController = { MainWindowController(windowNibName: String(describing: MainWindowController.self)) }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        showMainWindow(nil)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showMainWindow(nil)
        return true
    }

    @IBAction func showMainWindow(_ sender: AnyObject?) {
        mainWindowController.showWindow(sender)
    }
}
