//
//  ViewController.swift
//  Prueba
//
//  Created by Samuel on 7/4/22.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let cellID = "StoreTableViewCell"
    private var dataSource = [StoreInfo]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        //getStores()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [self] in
            self.getStores(page: 1)
        }
    }
    
    func getStores(page: Int){
        
        
        let url = URL(string: Endpoints.domain + "&page=\(page)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(Endpoints.type, forHTTPHeaderField: "Content-Type")
        request.addValue(Endpoints.uuid, forHTTPHeaderField: "X-Company-UUID")
        request.addValue(Endpoints.authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do{
                if let jsonData = data{
                    print("tamaño del json \(jsonData)")
                    let decodeData = try
                    JSONDecoder().decode(Store.self, from: jsonData)
                    print(decodeData.links.next)
                    DispatchQueue.main.async {
                        self.dataSource += decodeData.data
                        self.tableView.reloadData()
                    }
                }
            }catch{
                print("Error: \(error)")
            }
        }.resume()
        
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        if(dataSource.count <= (indexPath.row + 1)){
            print("llegamos al limite, traer mas")
            let next = (dataSource.count/10) + 1
        
            self.getStores(page: next)
        }
    }


}


//MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate{
    
}

//MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let cell = cell as? StoreTableViewCell{
            cell.setupCellWith(store: dataSource[indexPath.row])
        }
        return cell
    }
}


