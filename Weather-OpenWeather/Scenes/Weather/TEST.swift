////
////  TEST.swift
////  Weather-OpenWeather
////
////  Created by Eddy R on 06/10/2020.
////  Copyright © 2020 EddyR. All rights reserved.
////
//
//import Foundation
//
////
////  BatchRequestForCoreDataWW20.swift
////  BatchJson
////
////  Created by Eddy R on 22/09/2020.
////  Copyright © 2020 Eddy R. All rights reserved.
////
//
//import Foundation
//import CoreData
//import UIKit
//
//class BatchRequestForCoreDataWW20 {
//    
//    func help() {
//        print("""
//        https://developer.apple.com/videos/play/wwdc2020/10017
//        *** Batch Operation est pour manipuler des gros volume de donnée dans core data sans les charger les data en memoire **
//        printSQLite()   : imprimer le chemin du fichier sqlite
//        Insert()        : Insert des données dans CoreData Via Batch Class
//        Update()
//        Delete()
//
//        """)
//    }
//    
//    func ContextSituation() {
//        //
//        //  Student+CoreDataClass.swift
//        //        import Foundation
//        //        import CoreData
//        //
//        //        @objc(Student)
//        //        public class Student: NSManagedObject {
//        //
//        //        }
//        
//        
//        //
//        //  Student+CoreDataProperties.swift
//        //  BatchJson
//        //
//        //        import Foundation
//        //        import CoreData
//        //
//        //
//        //        extension Student {
//        //
//        //            @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
//        //                return NSFetchRequest<Student>(entityName: "Student")
//        //            }
//        //
//        //            @NSManaged public var studentName: String?
//        //
//        //        }
//        
//        
//        // .xcdatamodelid
//        //        Entities
//        //            Student
//        //        Attributes
//        //            studentName : String
//    }
//    
//    func printSQLite(){
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        let pathFileSqlite = appdelegate.persistentContainer.persistentStoreDescriptions
//        print("██░░░ L\(#line) 🚧🚧 \(pathFileSqlite) 🚧🚧",String(describing: self) ,#function)
//        print("██░░░ L\(#line) 🚧🚧 aller dans finder coller /User/Name... 🚧🚧")
//        //     /User/Name\ subName/loc/bin
//        print("██░░░ L\(#line) 🚧🚧 aller dans finder coller /User/Name\\ subname/loc/bin... 🚧🚧")
//    }
//    
//    func insert() {
//        //     **insertion de data via batch**
//        
//        //        01 Creer un context et un appDelegate au besoin. (les plats)
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate // AppDelegate
//        
//        //        02 Creation des données à inserer & de la requete  (ingredient) (assiette + ingredient).
//        /// Methode 1
//        var attributeArray = [[String:Any]]() // correspond a un attribute exemple StudentName attribute de type String [Key:Value] (preparation des ingredients)
//        for i in 0...1000 {
//            attributeArray.append(["KeyNameAttribute" : "ValueString-\(i)"]) //(ingredient)
//        }
//        let batchInsertRequest = NSBatchInsertRequest(entityName: "EntityName", objects: attributeArray) // (assiette + ingredient)
//        
//        /// Methode 2
//        for _ in 0...1000 {
//            _ = NSEntityDescription.insertNewObject(forEntityName: "EntityName", into: context)
//            // studentObject.<#attributeKey#> = <#Any Value i want#>
//        }
//        appDelegate.saveContext()
//        
//        
//        //        03 conserver les resultats lors du lancement de la request
//        let resultBatchInsert: NSBatchInsertResult
//        
//        //        04 execution de la requete avec un do try catch car une erreur peut être levé throws
//        do {
//            resultBatchInsert =  try context.execute(batchInsertRequest) as! NSBatchInsertResult // (envoie de la commande au client)
//            print(resultBatchInsert) // (voir le resultat)
//        } catch let error as NSError {
//            print("██░░░ L\(#line) 🚧🚧 err : \(error), \(error.userInfo) 🚧🚧 ",String(describing: self),#function) // (feed back si c'est pas bon)
//        }
//    }
//    
//    func update() {
//        //     **update de data via batch**
//        
//        //        Creer un context et un appDelegate au besoin. (les plats)
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        _ = UIApplication.shared.delegate as! AppDelegate // AppDelegate
//        
//        //        creer requete (assiette)
//        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "EntityName")
//        
//        //        valeur à changer (nourriture)
//        batchUpdateRequest.propertiesToUpdate = ["KeyNameAttribute" : "ValueOfAttribute"]
//        
//        //        filter : condition de changement (demande du client)
//        batchUpdateRequest.predicate = NSPredicate(format: "%K == KeyNameAttribute", "Value") // %K represente le champs de l"attribut
//        
//        //        resultat de la requete (feedback)
//        var resultBatchUpdate: NSBatchUpdateResult
//        do {
//            //            service (livraison assiette)
//            resultBatchUpdate = try context.execute(batchUpdateRequest) as! NSBatchUpdateResult
//            print(resultBatchUpdate)
//        } catch let error as NSError {
//            //            feedback si quelque chose ne vas pas
//            print("██░░░ L\(#line) 🚧🚧 err : \(error), \(error.userInfo) 🚧🚧 ",String(describing: self),#function)
//        }
//    }
//    
//    func delete() {
//        //     **delete de data via batch**
//        
//        //        Creer un context et un appDelegate au besoin. (les plats)
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let _ = UIApplication.shared.delegate as! AppDelegate // AppDelegate
//        
//        //        recuperer requete (retour déja existant)
//        let requestFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
//        
//        
//        //        filter : condition de changement (demande du client)
//        requestFetch.fetchLimit = 1000 // will delete every 1000 rows , best performance
//        let elesValuePredicate = "hello" // if predicate True this line will be the value
//        requestFetch.predicate = NSPredicate(format: "AttributeName == %@", elesValuePredicate)
//        
//        
//        //        creer requete (poubelle)
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: requestFetch)
//        
//        //        resultat de la requete (Poubelle rempli)
//        var resultBatchDelete: NSBatchDeleteResult
//        do {
//            //            nettoyage (livraison assiette à la poubelle)
//            resultBatchDelete =  try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
//            print(resultBatchDelete)
//        } catch let error as NSError {
//            //            feedback si quelque chose ne vas pas
//            print("██░░░ L\(#line) 🚧🚧 err : \(error), \(error.userInfo) 🚧🚧 ",String(describing: self),#function)
//        }
//    }
//    
//    
//    // helper
//    func currentTimeMillis() -> Int64 {
//        //retour en milliseconde
//        return Int64(Date().timeIntervalSince1970 * 1000)
//        // start = currentTimeMillis()
//        // end = currentTimeMillis()
//        // diff = end - start
//    }
//    
////    func traditionnalApprocheUpdate() {
////        // attention cette approche est plus lente
////
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate // AppDelegate
////
////        let request:NSFetchRequest<Student> = Student.fetchRequest()
////        do {
////            let results = try context.fetch(request)
////            for student in results {
////                student.studentName = "toto"
////            }
////            appDelegate.saveContext()
////        } catch let e as NSError{
////            print(e)
////        }
////    }
//    
//}
//
