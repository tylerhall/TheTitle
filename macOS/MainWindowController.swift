//
//  MainWindowController.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    static var shared: MainWindowController!
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    var lastBrowser: NSRunningApplication?
    let browsers = ["com.apple.Safari", "com.google.Chrome", "com.microsoft.edgemac", "org.mozilla.firefox", "com.brave.Browser"]

    lazy var scriptSafari: NSAppleScript = {
        let script = """
            tell application "Safari" to return name of front document
        """
        let appleScript = NSAppleScript(source: script)
        appleScript?.compileAndReturnError(nil)
        return appleScript!
    }()

    lazy var scriptChrome: NSAppleScript = {
        let script = """
            tell application "Google Chrome" to return title of active tab of front window
        """
        let appleScript = NSAppleScript(source: script)
        appleScript?.compileAndReturnError(nil)
        return appleScript!
    }()

    lazy var scriptEdge: NSAppleScript = {
        let script = """
            tell application "Microsoft Edge" to return title of active tab of front window
        """
        let appleScript = NSAppleScript(source: script)
        appleScript?.compileAndReturnError(nil)
        return appleScript!
    }()

    lazy var scriptBrave: NSAppleScript = {
        let script = """
            tell application "Brave Browser" to return title of active tab of front window
        """
        let appleScript = NSAppleScript(source: script)
        appleScript?.compileAndReturnError(nil)
        return appleScript!
    }()

    lazy var scriptFirefox: NSAppleScript = {
        let script = """
            tell application "Firefox" to return name of windows's item 1
        """
        let appleScript = NSAppleScript(source: script)
        appleScript?.compileAndReturnError(nil)
        return appleScript!
    }()

    override func windowDidLoad() {
        super.windowDidLoad()
        MainWindowController.shared = self

        window?.isMovableByWindowBackground = true
        window?.level = .statusBar

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(appDidActivate(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.getBrowserTitle()
        }
    }

    @objc func appDidActivate(_ notification: Notification) {
        if let runningApp = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
            guard let bundleID = runningApp.bundleIdentifier else { return }
            guard browsers.contains(bundleID) else { return }
            lastBrowser = runningApp
        }
    }

    func getBrowserTitle() {
        guard let bundleID = lastBrowser?.bundleIdentifier else { return }

        var title: String?

        if bundleID.contains("Safari") {
            title = scriptSafari.executeAndReturnError(nil).stringValue
        }

        if bundleID.contains("Chrome") {
            title = scriptChrome.executeAndReturnError(nil).stringValue
        }

        if bundleID.contains("edgemac") {
            title = scriptEdge.executeAndReturnError(nil).stringValue
        }

        if bundleID.contains("brave") {
            title = scriptBrave.executeAndReturnError(nil).stringValue
        }

        if bundleID.contains("firefox") {
            title = scriptFirefox.executeAndReturnError(nil).stringValue
        }

        if let title = title {
            window?.title = title
        }
    }
}
