//
//  MenuTableViewController.swift
//  AidKit
//
//  Created by Stein, Maxwell on 7/31/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = String(describing: MenuTableViewCell.self)

final class MenuTableViewCell: UITableViewCell {

    let isEnabledSwitch = UISwitch()
    var data: MenuCellData?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        addSubview(isEnabledSwitch)
        isEnabledSwitch.translatesAutoresizingMaskIntoConstraints = false
        isEnabledSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        isEnabledSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        isEnabledSwitch.addTarget(self, action: #selector(tappedSwitch(_:)), for: .valueChanged)
    }

    @objc func tappedSwitch(_ sender: UISwitch) {
        data?.isOn = sender.isOn
    }

    func setup(with data: MenuCellData) {
        textLabel?.text = data.name
        isEnabledSwitch.isOn = data.isOn
        self.data = data
    }

}

final class MenuCellData {

    let name: String
    var isOn: Bool

    init(name: String, isOn: Bool) {
        self.name = name
        self.isOn = isOn
    }
}

protocol MenuCellToggled {
    func updateDisplayedCells()
}

final class MenuTableViewController: UITableViewController {

    let items = [MenuCellData(name: "Recorder", isOn: true),
                      MenuCellData(name: "Visualizer", isOn: true),
                      MenuCellData(name: "Debugger", isOn: false),
                      MenuCellData(name: "Logger", isOn: false)]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        title = "Configuration"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .done, target: self, action: #selector(startAidKit))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if let menuCell = cell as? MenuTableViewCell {
            menuCell.setup(with: items[indexPath.row])
        }

        return cell ?? UITableViewCell()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }

    @objc func startAidKit() {
        closeView()
        let configuration = Configuration { (configuration) in
            configuration.recorderConfiguration.isOn = items.filter{ $0.name == configuration.recorderConfiguration.name }.first?.isOn ?? false
            configuration.visualizerConfiguration.isOn = items.filter{ $0.name == configuration.visualizerConfiguration.name }.first?.isOn ?? false
            configuration.debuggerConfiguration.isOn = items.filter{ $0.name == configuration.debuggerConfiguration.name }.first?.isOn ?? false
            configuration.loggerConfiguration.isOn = items.filter{ $0.name == configuration.loggerConfiguration.name }.first?.isOn ?? false
        }
        AKManager.sharedInstance.start(configuration)
    }

}
