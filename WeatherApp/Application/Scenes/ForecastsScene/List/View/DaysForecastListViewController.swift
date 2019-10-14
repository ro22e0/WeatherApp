//
//  DaysForecastListViewController.swift
//  WeatherApp
//
//  Created by Ronaël Bajazet on 14/10/2019.
//  Copyright © 2019 Ro42e0 Company. All rights reserved.
//

import UIKit

class DaysForecastListViewController: BaseViewController {
  private(set) var viewModel: ForecastsListViewModelProtocol!

  private lazy var tableView: UITableView = {
    let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    return UITableView(frame: frame, style: .grouped)
  }()

  private var sections = [ForecastsListSectionViewModelProtocol]() {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configure()
    bindToViewModel()
    viewModel.viewDidLoad()
  }

  private func bindToViewModel() {
    viewModel.sections.subscribe(on: self, with: updateSections)
    viewModel.error.subscribe(on: self, with: showError)
  }

  private func configure() {
    let nib = UINib(nibName: ForecastTableViewCell.reuseID, bundle: .main)
    tableView.register(nib, forCellReuseIdentifier: ForecastTableViewCell.reuseID)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 45
    tableView.rowHeight = UITableView.automaticDimension
    tableView.sectionFooterHeight = 0
    view.addSubview(tableView)
    layout()
  }

  private func layout() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  // MARK: - Observable handlers
  func updateSections(new: [ForecastsListSectionViewModelProtocol], old: [ForecastsListSectionViewModelProtocol]) {
    // TODO: detect changes
    sections = new
  }

  func showError(new: String, old: String) {

  }
}

extension DaysForecastListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = sections[section]
    return section.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell =
      tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as? ForecastTableViewCell else {
        return UITableViewCell()
    }

    let section = sections[indexPath.section]
    let item = section.items[indexPath.row]

    cell.tempLabel.text = item.temperature
    cell.timeLabel.text = item.hour
    cell.humidityLabel.text = item.humidity
    cell.windLabel.text = item.wind

    return cell
  }
}

extension DaysForecastListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let section = sections[indexPath.section]
    let item = section.items[indexPath.row]
    viewModel.didSelect(item: item)
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let section = sections[section]

    let headerView = UIView()
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.textColor = .darkGray
    label.text = section.title

    headerView.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      label.heightAnchor.constraint(equalTo: headerView.heightAnchor)
    ])

    return headerView
  }
}

extension DaysForecastListViewController: ViewModelable {

  static func instance(with viewModel: ForecastsListViewModelProtocol) -> UIViewController {
    let vc = DaysForecastListViewController()
    vc.viewModel = viewModel
    return vc
  }
}
