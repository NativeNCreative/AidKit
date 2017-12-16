//
//  MenuTableViewController.swift
//  AidKit
//
//  Created by Stein, Maxwell on 7/31/17.
//  Copyright © 2017 NativeNCreative. All rights reserved.
//

import UIKit
import AidKit

fileprivate let reuseIdentifier = String(describing: MenuTableViewCell.self)

final class MenuTableViewCell: UITableViewCell {

    let isEnabledSwitch = UISwitch()
    var identifier: ComponentId?

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
        // 2. Configure it
        if let identifier = identifier,
            let component = AKManager.shared.componentFor(identifier),
            var configurable = component.configurable {
            configurable.isOn = sender.isOn
            AKManager.shared.setConfiguration(configurable, identifier)
        }
    }

    func setup(with identifier: ComponentId) {
        textLabel?.text = identifier.rawValue
            self.identifier = identifier
            let configuration = AKManager.shared.configuration(identifier)
            isEnabledSwitch.isOn = configuration?.isOn ?? false
    }
}

protocol MenuCellToggled {
    func updateDisplayedCells()
}

final class MenuTableViewController: UITableViewController {

    let items = [ComponentId.recorder, ComponentId.visualizer, ComponentId.debugger]

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. Register your components
        AKManager.shared.registerNativeComponents()

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

        // 3. Start AidKit Debugging
        AKManager.shared.start()
    }

}
