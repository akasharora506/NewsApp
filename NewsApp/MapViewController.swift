import UIKit

class MapViewController: UIViewController, UITableViewDelegate {
    
    let header :UILabel = {
       let header = UILabel()
        header.text = "News by Location"
        header.textColor = .white
        header.backgroundColor = .purple
        header.textAlignment = .center
        header.font = .systemFont(ofSize: 24, weight: .bold)
        return header
    }()
    
    let modal = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modal.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        modal.delegate = self
        modal.dataSource = self
        view.backgroundColor = .lightGray
        view.addSubview(header)
        view.addSubview(modal)
    }
    override func viewDidLayoutSubviews() {
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        modal.frame = CGRect(x: 10, y: view.frame.height - 310, width: view.frame.width - 20, height: 250)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = modal.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as? MapTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: modal.frame.width, height: 50))

        let label = UILabel()
        label.text = "Results for New York"
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21)
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
