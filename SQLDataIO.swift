//
//  SQLDataIO.swift
//  SQLiteWrapper
//
//  Created by Cindy Oakes on 5/28/16.
//  Copyright © 2016 Cindy Oakes. All rights reserved.
//

//the directory and file url prints, so you can navigate to it and throw the database in the trash between runs while testing
//if you can not find the folders by browing then on the Finder menu at the top click Go=>GoToFolder then type in  Library or
//Developer to help you get to it because apple is hiding them

// be sure and use the readme.txt to get the sql libraries linked up correctly

import UIKit
import Dispatch


class SQLDataIO
{
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first! // automacki se kreira baza ukoliko je nema
    static let DBURL = DocumentsDirectory.appendingPathComponent("database.sqlite3")
    var dbCommand = String()
  
    init()
    {
       // dbCommand = "drop table player"
        //updateDatabase(dbCommand)
        //dbCommand = "CREATE TABLE PLAYER (ID INT PRIMARY KEY NOT NULL , FIRSTNAME TEXT , MIDDLENAME TEXT , LASTNAME TEXT ,POSITOON TEXT , BELTNAME TEXT foreignKey REFERENCES belt(BELTNUMBER) , HEIGHT REAL , WEIGHT REAL , GENDER TEXT ,MAXHEARTRATE INT , AGE INT);"
//        updateDatabase(dbCommand)
        dbCommand = "CREATE TABLE BELT (BELTNUMBER TEXT PRIMARY KEY NOT NULL ,HEARTRATE INT,STRIDERATE INT,NUMBEROFSTEPS INT);"
        updateDatabase(dbCommand)
       
        // func addPlayer( firstname: String, middleName : String,lastName : String,beltName:String,positons:String,height:Float,weight:Float,gender:Float,maxHeartrate:Int, age: Int)

        addPlayer(firstname: "Stefan",middleName: "Jovica",lastName: "Djordjevic",beltName: "111222233a",positons: "BEK",height: 182,weight: 68,gender: 55,maxHeartrate: 150,age: 20)
       // let updateStatementString = "UPDATE player SET FIRSTNAME = 'Chris' WHERE Id = 1;"
        
     //   let deleteStatementStirng = "DELETE FROM player WHERE Id = 1;"
       // updateDatabase(deleteStatementStirng)
       // dbCommand = "select * from player"
      // getPlayerForDatabase(queryStatementString: dbCommand)
        addBeltOnPlayer(beltNumber: "111222233a", heartRate: 150, striderate: 10, numberofsteps: 20)
   //     updateDatabase(addBeltOnPlayer)
        getBeltOfPlayer(beltName: "111222233a")
    }
    
    // moja f-ja stefan
    func getPlayerForDatabase(queryStatementString : String) {
        var players = [Players]()
        let db: OpaquePointer = SQLDataIO.openDatabase()
        var queryStatement: OpaquePointer? = nil
       
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
              var p = Players()
                 p.id = Int(sqlite3_column_int(queryStatement, 0))
                
                p.firstName = String(cString: sqlite3_column_text(queryStatement, 1))
                
                p.middleName = String(cString: sqlite3_column_text(queryStatement, 2))
                p.lastName = String(cString: sqlite3_column_text(queryStatement, 3))
                p.postition = String(cString: sqlite3_column_text(queryStatement, 4))
                p.beltName = String(cString: sqlite3_column_text(queryStatement, 5))
                
                p.height = Float(sqlite3_column_double(queryStatement, 6))
                p.weight = Float(sqlite3_column_double(queryStatement, 7))
                
                p.gender = String(cString: sqlite3_column_text(queryStatement, 8))
                p.maxHeartRate = Int(sqlite3_column_int(queryStatement, 9))
                p.age = Int(sqlite3_column_int(queryStatement, 10))
                
                
                print(p.id)
                print(p.firstName)
                print(p.middleName)
                print(p.age)
                
                print(p.beltName)
                print(p.gender)
                print(p.created)
                  players.append(p)
            }
            if players.count == 0
            {
            print("on selection data ")
            }
     
        }
        else {
            print("SELECT statement could not be prepared")
        }
        
       
        sqlite3_finalize(queryStatement)
    }
    
    func updateDatabase(_ dbCommand: String)
    {
        var updateStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                //do nothing
                print("upisano u bazu")
            } else {
                print("Could not updateDatabase")
            }
        } else {
            print("updateDatabase dbCommand could not be prepared")
        }
        
        sqlite3_finalize(updateStatement)
        
        sqlite3_close(db)
        
    }

    
    func addPlayer( firstname: String, middleName : String,lastName : String,beltName:String,positons:String,height:Float,weight:Float,gender:Float,maxHeartrate:Int, age: Int)
    {
        
      let  id = nextPlayerID("Player")
        
        let dbCommand = "insert into PLAYER(ID, FIRSTNAME, MIDDLENAME,LASTNAME, BELTNAME,POSITOON,HEIGHT,WEIGHT,GENDER,MAXHEARTRATE,AGE) values ( \(id), '\(firstname)', '\(middleName)', '\(lastName)' , '\(beltName)', '\(positons)', '\(height)', '\(weight)', '\(gender)', '\(maxHeartrate)', '\(age)')"
        
            updateDatabase(dbCommand)
    
    }
    // BELTNUMBER  TEXT,HEARTRATE INT,STRIDERATE INT,NUMBEROFSTEPS INT, PLAYERID INT);"
    func addBeltOnPlayer(beltNumber : String,heartRate:Int,striderate:Int,numberofsteps:Int)
    {
      
   
       let dbCommand = "insert into belt(BELTNUMBER, HEARTRATE,STRIDERATE, NUMBEROFSTEPS) values ( '\(beltNumber)', '\(heartRate)', '\(striderate)' , '\(numberofsteps)')"
    
        updateDatabase(dbCommand)
        

    }
    func nextBeltId() ->Int
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        let dbCommand = String(format: "select ID from belt order by ID desc limit 1")
        
        var value: Int32? = 0
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                value = sqlite3_column_int(getStatement, 0)
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        var id: Int = 1
        if (value != nil)
        {
            id = Int(value!) + 1
        }
        
        return id

    }
    
    //MARK:  Open Database
    
    static func openDatabase() -> OpaquePointer {
        var db: OpaquePointer? = nil
        if sqlite3_open(DBURL.absoluteString, &db) == SQLITE_OK {
            //do nothing
            
        } else {
            print("Unable to open database. ")
        }
        return db!
    }
    
    
    func getBeltOfPlayer(beltName:String)
    {
        var queryStatementString = "select * from BELT where BELTNUMBER =111222233a"//+beltName
        let db: OpaquePointer = SQLDataIO.openDatabase()
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                
              print(String(cString: sqlite3_column_text(queryStatement, 0)))
                
              print(sqlite3_column_int(queryStatement, 1))
             print(sqlite3_column_int(queryStatement, 2))
                 print(sqlite3_column_int(queryStatement, 3))
                        }
            else
            {
                print("no data")
            }
        }
        else {
            print("SELECT statement could not be prepared")
        }
        
        
        sqlite3_finalize(queryStatement)

    }
    
    
    //MARK:  Get DBValue
    
    static func dbValue(_ dbCommand: String) -> String
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        var value: String? = nil
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                var getResultCol = sqlite3_column_text(getStatement, 0)
                // value = String(cString: UnsafePointer<CChar>(getResultCol!))
                value = String(cString:getResultCol!)
                
                
                
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        if (value == nil)
        {
            value = ""
        }
        
        return value!
    }
    
    
    
    //MARK: Get Next ID
    
    func nextPlayerID(_ tableName: String!) -> Int
    {
        var getStatement: OpaquePointer? = nil
        
        let db: OpaquePointer = SQLDataIO.openDatabase()
        
        let dbCommand = String(format: "select ID from Player order by ID desc limit 1", tableName)
        
        var value: Int32? = 0
        
        if sqlite3_prepare_v2(db, dbCommand, -1, &getStatement, nil) == SQLITE_OK {
            if sqlite3_step(getStatement) == SQLITE_ROW {
                
                value = sqlite3_column_int(getStatement, 0)
            }
            
        } else {
            print("dbValue statement could not be prepared")
        }
        
        sqlite3_finalize(getStatement)
        
        sqlite3_close(db)
        
        var id: Int = 1
        if (value != nil)
        {
            id = Int(value!) + 1
        }
        
        return id
    }
  
    
    
    
}
