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
    }

    func setup(with data: MenuCellData) {
        textLabel?.text = data.name
        isEnabledSwitch.isOn = data.isOn
        self.data = data
    }

}

final class MenuCellData: SubMenuCellData {

    let subItems: [SubMenuCellData]?

    init(name: String, isOn: Bool, subItems: [SubMenuCellData]? = nil) {
        self.subItems = subItems
        super.init(name: name, isOn: isOn)
    }
}

class SubMenuCellData {

    let name: String
    let isOn: Bool

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
                      MenuCellData(name: "Debugger", isOn: false, subItems: [
                        SubMenuCellData(name: "FPS", isOn: true),
                        SubMenuCellData(name: "iOS Version", isOn: true),
                        SubMenuCellData(name: "Device Type", isOn: true),
                        ]),
                      MenuCellData(name: "Logger", isOn: false)]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        title = "Configuration"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeView))
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
        var count = items.count
        for item in items {
            if let subItems = item.subItems, item.isOn {
                count += subItems.count
            }
        }
        return count
    }

    func updateDisplayedCells() {
    }

    func closeView() {
        dismiss(animated: true, completion: nil)
    }

}
