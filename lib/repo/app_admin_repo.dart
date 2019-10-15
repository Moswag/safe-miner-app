import 'dart:async';

import 'package:android_minor/constants/app_constants.dart';
import 'package:android_minor/constants/db_constants.dart';
import 'package:android_minor/models/company.dart';
import 'package:android_minor/models/conversion.dart';
import 'package:android_minor/models/state.dart';
import 'package:android_minor/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppAdminRepo {
  static StateModel appState;

  static Future<bool> updateController(
      {String name,
      String email,
      String nationalId,
      String phonenumber,
      String role,
      final index}) async {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {
          'email': email,
          'name': name,
          'nationalId': nationalId,
          'phonenumber': phonenumber,
          'role': role,
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<User>> getControllers(String userId) async {
    User user;
    List<User> lusers = [];

    Firestore.instance
        .collection(DBConstants.DB_USERS)
        .where('role', isEqualTo: AppConstants.USER_APP_ADMIN)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) async {
        print(doc["name"]);
        user = new User();
        user.userId = doc["userId"];
        user.name = doc["name"];
        user.phonenumber = doc["phonenumber"];
        user.email = doc["email"];
        user.role = doc["role"];
        user.companyId = doc["companyId"];
        user.isEmployee = doc["isEmployee"];

        if (user.userId == userId) {
          print('This Controller is logged in');
        } else {
          lusers.add(user);
        }
      });
    });

    print('Controllers successfuly pulled');

    return lusers;
  }

//  static Future<bool> addPrice(Price price) async {
//    try {
//      Firestore.instance
//          .document(DBConstants.DB_PRICES+"/${price.priceId}")
//          .setData(price.toJson());
//      print("Price added");
//      return true;
//    }
//    catch(e){
//      return false;
//    }
//
//  }

//  static Future<bool> addStock(Stock stock) async {
//    try {
//      Firestore.instance.runTransaction((Transaction transaction) async {
//        CollectionReference reference = Firestore.instance.collection(DBConstants.DB_STOCK);
//        await reference.add(stock.toJson());
//      });
//      return true;
//    }
//    catch (e) {
//      return false;
//    }
//  }

//  static Future<bool> addShopStock(ShopStock stock) async {
//    bool status=false;
//    var shopStock;
//    await checkShopStock(stock.stockId).then((onValue){
//      if(!onValue){
//        Firestore.instance
//            .document(DBConstants.DB_SHOP_STOCK+"/${stock.stockId}")
//            .setData(stock.toJson());
//        print("Shop Stock added");
//        status=true;
//
//      }
//      else{
//        print('Shop already exists, stock need to be updated');
//        ControllerService.getShopStockObject(stock.shopName).then((QuerySnapshot snapshot){
//          if (snapshot.documents.isNotEmpty) {
//            shopStock = snapshot.documents[0].data;
//            double mass = shopStock["mass"];
//            int decimals = 2;
//            int fac = pow(10, decimals);
//            mass = (mass * fac).round() / fac;
//            double finaMass=mass + stock.mass;
//            ControllerService.updateShopStock(finaMass, snapshot.documents[0].reference).then((onValue){
//
//              print('Shop stock updated');
//            });
//
//          }
//        });
//        status=true;
//
//      }
//    });
//    return status;
//
//  }

  static Future<bool> updateShopStock(double mass, final index) async {
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        DocumentSnapshot snapshot = await transaction.get(index);
        await transaction.update(snapshot.reference, {"mass": mass});
      });
      return true;
    } catch (e) {
      return false;
    }
  }
//  static Future<bool> checkShopStock(String stockId) async {
//    bool exists = false;
//    try {
//      await Firestore.instance.document(DBConstants.DB_SHOP_STOCK+"/$stockId").get().then((doc) {
//        if (doc.exists)
//          exists = true;
//        else
//          exists = false;
//      });
//      return exists;
//    } catch (e) {
//      return false;
//    }
//  }

//  static getShopStockObject(String shopName) {
//    return Firestore.instance
//        .collection(DBConstants.DB_SHOP_STOCK)
//        .where('shopName', isEqualTo: shopName)
//        .limit(1)
//        .getDocuments();
//  }

  static Future<bool> addCompany(Company company) async {
    try {
      print(company.name + company.mission);
      print(company.toJson());
      Firestore.instance
          .document("${DBConstants.DB_COMPANY}/${company.id}")
          .setData(company.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> addConversion(Conversion conversion) async {
    try {
      Firestore.instance
          .document("${DBConstants.DB_CONVERSION}/${conversion.id}")
          .setData(conversion.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

//
//  static Future<bool> addTarget(Target target) async {
//    try {
//      Firestore.instance
//          .document(DBConstants.DB_TARGETS+"/${target.targetId}")
//          .setData(target.toJson());
//      print("Target added");
//      return true;
//    }
//    catch(e){
//      return false;
//    }
//
//  }
//
//
//  static getWholesale() {
//
//    return Firestore.instance
//        .collection(DBConstants.DB_SHOPS)
//        .where('shop_type', isEqualTo: PropaneConstants.SHOP_WHOLESALE)
//        .limit(1)
//        .getDocuments();
//
//  }
//
//
//  static  Future<List<Sale>> getSales() async{
//    Sale sale;
//    List<Sale> lsales=[];
//    Firestore.instance.collection(DBConstants.DB_SALES).snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        //print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//
//        if(lsales.length==0){
//          lsales.add(sale);
//        }
//        else{
//          if (lsales.toString().contains(sale.shopName)) {
//            // print('shop aleady exists');
//            for(int i=0; i<lsales.length;i++) {
//              if (lsales[i].shopName == sale.shopName) {
//                lsales[i].mass += sale.mass;
//                //to 2 decimal place
//                int decimals = 2;
//                int fac = pow(10, decimals);
//                lsales[i].mass = (lsales[i].mass * fac).round() / fac;
//
//                // print('Mass updated');
//              }
//            }
//
//          }
//          else {
//            lsales.add(sale);
//            // print('shop is new');
//          }
//
//
//
//
//        }
//
//
//      });
//
//    });
//
//
//
//    // print('Sales successfully pulled');
//    print(lsales.length);
//    return lsales;
//
//  }
//
//
//
//  static  Future<List<VSales>> getVSales(String shopNme) async{
//    Sale sale;
//    VSales vSales;
//    String date = DateFormat.yMMMd().format(DateTime.now());
//    double zero=0.0;
//
//    List<VSales> vsales=[];
//    print('date of the pick is '+date);
//    Firestore.instance.collection(DBConstants.DB_SALES)
//        .where('shopName',isEqualTo: shopNme).where('date',isEqualTo: date)
//        .snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//
//        if(vsales.length==0){
//          vSales=new VSales();
//          vSales.shopName=sale.shopName;
//          vSales.mass=sale.mass;
//          vSales.date=sale.date;
//          vSales.userId=sale.userId;
//          vSales.sellType=sale.sellType;
//          if(sale.currency==PropaneConstants.USD) {
//            vSales.usd_currency=sale.currency;
//            vSales.usd_amount = sale.price;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.RTGS) {
//            vSales.rtgs_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = sale.price;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.SWIPE) {
//            vSales.swipe_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = sale.price;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.ECOCASH) {
//            vSales.ecocash_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = sale.price;
//          }
//
//          vsales.add(vSales);
//
//
//
//        }
//        else{
//          if (!vsales.toString().contains(sale.currency)) {
//            print('currency does not exists');
//            for(int i=0; i<vsales.length;i++) {
//              if(sale.currency==PropaneConstants.USD) {
//                vsales[i].usd_currency = sale.currency;
//                vsales[i].usd_amount = sale.price;
//                vsales[i].mass += sale.mass;
//              }
//              else if(sale.currency==PropaneConstants.RTGS) {
//                vsales[i].rtgs_currency = sale.currency;
//                vsales[i].rtgs_amount = sale.price;
//                vsales[i].mass += sale.mass;
//              }
//              else if(sale.currency==PropaneConstants.SWIPE) {
//                vsales[i].swipe_currency = sale.currency;
//                vsales[i].swipe_amount = sale.price;
//                vsales[i].mass += sale.mass;
//              }
//              else if(sale.currency==PropaneConstants.ECOCASH) {
//                vsales[i].ecocash_currency = sale.currency;
//                vsales[i].ecocash_amount = sale.price;
//                vsales[i].mass += sale.mass;
//              }
//
//            }
//
//          }
//          else {
//            print('currency aleady exists');
//            for (int i = 0; i < vsales.length; i++) {
//              if (vsales[i].usd_currency == sale.currency) {
//                vsales[i].usd_amount += sale.price;
//                vsales[i].mass += sale.mass;
//
//                print('USD amount updated');
//              }
//              else if (vsales[i].rtgs_currency == sale.currency) {
//                vsales[i].rtgs_amount += sale.price;
//                vsales[i].mass += sale.mass;
//
//                print('RTGS amount updated');
//              }
//              else if (vsales[i].swipe_currency == sale.currency) {
//                vsales[i].swipe_amount += sale.price;
//                vsales[i].mass += sale.mass;
//
//                print('Swipe amount updated');
//              }
//              else if (vsales[i].ecocash_currency == sale.currency) {
//                vsales[i].ecocash_amount += sale.price;
//                vsales[i].mass += sale.mass;
//
//                print('Ecocash amount updated');
//              }
//            }
//          }
//
//
//        }
//
//
//      });
//
//    });
//
//
//
//    print('Sales successfully pulled');
//    return vsales;
//
//  }
//
//  static  Future<List<VSales>> getAllVSales(String shopNme) async{
//    Sale sale;
//    VSales vSales;
//    double zero=0.0;
//
//    List<VSales> vsales=[];
//    Firestore.instance.collection(DBConstants.DB_SALES)
//        .where('shopName',isEqualTo: shopNme)
//        .snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//        vSales=new VSales();
//        vSales.shopName=sale.shopName;
//        vSales.mass=sale.mass;
//        vSales.date=sale.date;
//        vSales.userId=sale.userId;
//        vSales.sellType=sale.sellType;
//
//        if(vsales.length==0){
//          if(sale.currency==PropaneConstants.USD) {
//            vSales.usd_currency=sale.currency;
//            vSales.usd_amount = sale.price;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.RTGS) {
//            vSales.rtgs_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = sale.price;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.SWIPE) {
//            vSales.swipe_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = sale.price;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.ECOCASH) {
//            vSales.ecocash_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = sale.price;
//          }
//
//          vsales.add(vSales);
//
//
//
//        }
//        else {
//          if (vsales.toString().contains(sale.date)) {
//            if (!vsales.toString().contains(sale.currency)) {
//              print('currency does not exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].date==sale.date && sale.currency == PropaneConstants.USD) {
//                  vsales[i].usd_currency = sale.currency;
//                  vsales[i].usd_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.RTGS) {
//                  vsales[i].rtgs_currency = sale.currency;
//                  vsales[i].rtgs_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.SWIPE) {
//                  vsales[i].swipe_currency = sale.currency;
//                  vsales[i].swipe_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.ECOCASH) {
//                  vsales[i].ecocash_currency = sale.currency;
//                  vsales[i].ecocash_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//              }
//            }
//            else {
//              print('currency aleady exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].usd_currency == sale.currency) {
//                  vsales[i].usd_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('USD amount updated');
//                }
//                else if (vsales[i].rtgs_currency == sale.currency) {
//                  vsales[i].rtgs_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('RTGS amount updated');
//                }
//                else if (vsales[i].swipe_currency == sale.currency) {
//                  vsales[i].swipe_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Swipe amount updated');
//                }
//                else if (vsales[i].ecocash_currency == sale.currency) {
//                  vsales[i].ecocash_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Ecocash amount updated');
//                }
//              }
//            }
//          }
//          else {
//            if(sale.currency==PropaneConstants.USD) {
//              vSales.usd_currency=sale.currency;
//              vSales.usd_amount = sale.price;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.RTGS) {
//              vSales.rtgs_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = sale.price;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.SWIPE) {
//              vSales.swipe_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = sale.price;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.ECOCASH) {
//              vSales.ecocash_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = sale.price;
//            }
//
//            vsales.add(vSales);
//          }
//        }
//
//
//      });
//
//    });
//
//
//
//    print(vsales.length);
//    print('All Sales successfully pulled');
//    return vsales;
//
//  }
//
//
//  static  Future<List<VSales>> getShopMonthlySales(String shopNme) async{
//    Sale sale;
//    VSales vSales;
//    double zero=0.0;
//
//    List<VSales> vsales=[];
//    Firestore.instance.collection(DBConstants.DB_SALES)
//        .where('shopName',isEqualTo: shopNme)
//        .snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//        int x=sale.date.length-8;
//        int y=sale.date.length;
//        sale.date=sale.date.replaceRange(3,y,'');
//
//        vSales=new VSales();
//        vSales.shopName=sale.shopName;
//        vSales.mass=sale.mass;
//        vSales.date=sale.date;
//        vSales.userId=sale.userId;
//        vSales.sellType=sale.sellType;
//
//        if(vsales.length==0){
//          if(sale.currency==PropaneConstants.USD) {
//            vSales.usd_currency=sale.currency;
//            vSales.usd_amount = sale.price;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.RTGS) {
//            vSales.rtgs_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = sale.price;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.SWIPE) {
//            vSales.swipe_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = sale.price;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.ECOCASH) {
//            vSales.ecocash_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = sale.price;
//          }
//
//          vsales.add(vSales);
//
//
//
//        }
//        else {
//
//          if (vsales.toString().contains(sale.date)) {
//            if (!vsales.toString().contains(sale.currency)) {
//              print('currency does not exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].date==sale.date && sale.currency == PropaneConstants.USD) {
//                  vsales[i].usd_currency = sale.currency;
//                  vsales[i].usd_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.RTGS) {
//                  vsales[i].rtgs_currency = sale.currency;
//                  vsales[i].rtgs_amount = sale.price;
//                  vsales[i].mass = sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.SWIPE) {
//                  vsales[i].swipe_currency = sale.currency;
//                  vsales[i].swipe_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.ECOCASH) {
//                  vsales[i].ecocash_currency = sale.currency;
//                  vsales[i].ecocash_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//              }
//            }
//            else {
//              print('currency aleady exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].usd_currency == sale.currency) {
//                  vsales[i].usd_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('USD amount updated');
//                }
//                else if (vsales[i].rtgs_currency == sale.currency) {
//                  vsales[i].rtgs_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('RTGS amount updated');
//                }
//                else if (vsales[i].swipe_currency == sale.currency) {
//                  vsales[i].swipe_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Swipe amount updated');
//                }
//                else if (vsales[i].ecocash_currency == sale.currency) {
//                  vsales[i].ecocash_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Ecocash amount updated');
//                }
//              }
//            }
//          }
//          else {
//            if(sale.currency==PropaneConstants.USD) {
//              vSales.usd_currency=sale.currency;
//              vSales.usd_amount = sale.price;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.RTGS) {
//              vSales.rtgs_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = sale.price;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.SWIPE) {
//              vSales.swipe_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = sale.price;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.ECOCASH) {
//              vSales.ecocash_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = sale.price;
//            }
//
//            vsales.add(vSales);
//          }
//        }
//
//
//      });
//
//    });
//
//
//
//    print(vsales.length);
//    print('All Sales successfully pulled');
//    return vsales;
//
//  }
//
//
//  static  Future<List<VSales>> getDaySalesForAllShops() async{
//    Sale sale;
//    VSales vSales;
//    double zero=0.0;
//    String date = DateFormat.yMMMd().format(DateTime.now());
//
//    List<VSales> vsales=[];
//    Firestore.instance.collection(DBConstants.DB_SALES)
//        .where('date',isEqualTo: date)
//        .snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//        vSales=new VSales();
//        vSales.shopName=sale.shopName;
//        vSales.mass=sale.mass;
//        vSales.date=sale.date;
//        vSales.userId=sale.userId;
//        vSales.sellType=sale.sellType;
//
//        if(vsales.length==0){
//          if(sale.currency==PropaneConstants.USD) {
//            vSales.usd_currency=sale.currency;
//            vSales.usd_amount = sale.price;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.RTGS) {
//            vSales.rtgs_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = sale.price;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.SWIPE) {
//            vSales.swipe_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = sale.price;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.ECOCASH) {
//            vSales.ecocash_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = sale.price;
//          }
//
//          vsales.add(vSales);
//
//
//
//        }
//        else {
//
//          if (vsales.toString().contains(sale.date)) {
//            if (!vsales.toString().contains(sale.currency)) {
//              print('currency does not exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].date==sale.date && sale.currency == PropaneConstants.USD) {
//                  vsales[i].usd_currency = sale.currency;
//                  vsales[i].usd_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.RTGS) {
//                  vsales[i].rtgs_currency = sale.currency;
//                  vsales[i].rtgs_amount = sale.price;
//                  vsales[i].mass = sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.SWIPE) {
//                  vsales[i].swipe_currency = sale.currency;
//                  vsales[i].swipe_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.ECOCASH) {
//                  vsales[i].ecocash_currency = sale.currency;
//                  vsales[i].ecocash_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//              }
//            }
//            else {
//              print('currency aleady exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].usd_currency == sale.currency) {
//                  vsales[i].usd_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('USD amount updated');
//                }
//                else if (vsales[i].rtgs_currency == sale.currency) {
//                  vsales[i].rtgs_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('RTGS amount updated');
//                }
//                else if (vsales[i].swipe_currency == sale.currency) {
//                  vsales[i].swipe_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Swipe amount updated');
//                }
//                else if (vsales[i].ecocash_currency == sale.currency) {
//                  vsales[i].ecocash_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Ecocash amount updated');
//                }
//              }
//            }
//          }
//          else {
//            if(sale.currency==PropaneConstants.USD) {
//              vSales.usd_currency=sale.currency;
//              vSales.usd_amount = sale.price;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.RTGS) {
//              vSales.rtgs_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = sale.price;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.SWIPE) {
//              vSales.swipe_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = sale.price;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.ECOCASH) {
//              vSales.ecocash_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = sale.price;
//            }
//
//            vsales.add(vSales);
//          }
//        }
//
//
//      });
//
//    });
//
//
//
//
//
//    print(vsales.length);
//    print('All Sales successfully pulled');
//    return vsales;
//
//  }
//
//
//  static  Future<List<VSales>> getAllMonthlySales() async{
//    Sale sale;
//    VSales vSales;
//    double zero=0.0;
//
//    List<VSales> vsales=[];
//    Firestore.instance.collection(DBConstants.DB_SALES)
//        .snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["shopName"]);
//        sale=new Sale();
//        sale.shopName = doc["shopName"];
//        sale.mass = doc["mass"];
//        sale.date=doc["date"];
//        sale.price=doc["price"];
//        sale.currency=doc["currency"];
//        sale.userId=doc["userId"];
//        sale.sellType=doc["sellType"];
//
//        int x=sale.date.length-8;
//        int y=sale.date.length;
//        sale.date=sale.date.replaceRange(3,y,'');
//
//        vSales=new VSales();
//        vSales.shopName=sale.shopName;
//        vSales.mass=sale.mass;
//        vSales.date=sale.date;
//        vSales.userId=sale.userId;
//        vSales.sellType=sale.sellType;
//
//        if(vsales.length==0){
//          if(sale.currency==PropaneConstants.USD) {
//            vSales.usd_currency=sale.currency;
//            vSales.usd_amount = sale.price;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.RTGS) {
//            vSales.rtgs_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = sale.price;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.SWIPE) {
//            vSales.swipe_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = sale.price;
//            vSales.ecocash_amount = zero;
//          }
//          else if(sale.currency==PropaneConstants.ECOCASH) {
//            vSales.ecocash_currency=sale.currency;
//            vSales.usd_amount = zero;
//            vSales.rtgs_amount = zero;
//            vSales.swipe_amount = zero;
//            vSales.ecocash_amount = sale.price;
//          }
//
//          vsales.add(vSales);
//
//
//
//        }
//        else {
//
//          if (vsales.toString().contains(sale.date)) {
//            if (!vsales.toString().contains(sale.currency)) {
//              print('currency does not exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].date==sale.date && sale.currency == PropaneConstants.USD) {
//                  vsales[i].usd_currency = sale.currency;
//                  vsales[i].usd_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.RTGS) {
//                  vsales[i].rtgs_currency = sale.currency;
//                  vsales[i].rtgs_amount = sale.price;
//                  vsales[i].mass = sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.SWIPE) {
//                  vsales[i].swipe_currency = sale.currency;
//                  vsales[i].swipe_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//                else if (vsales[i].date==sale.date && sale.currency == PropaneConstants.ECOCASH) {
//                  vsales[i].ecocash_currency = sale.currency;
//                  vsales[i].ecocash_amount = sale.price;
//                  vsales[i].mass += sale.mass;
//                }
//              }
//            }
//            else {
//              print('currency aleady exists');
//              for (int i = 0; i < vsales.length; i++) {
//                if (vsales[i].usd_currency == sale.currency) {
//                  vsales[i].usd_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('USD amount updated');
//                }
//                else if (vsales[i].rtgs_currency == sale.currency) {
//                  vsales[i].rtgs_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('RTGS amount updated');
//                }
//                else if (vsales[i].swipe_currency == sale.currency) {
//                  vsales[i].swipe_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Swipe amount updated');
//                }
//                else if (vsales[i].ecocash_currency == sale.currency) {
//                  vsales[i].ecocash_amount += sale.price;
//                  vsales[i].mass += sale.mass;
//
//                  print('Ecocash amount updated');
//                }
//              }
//            }
//          }
//          else {
//            if(sale.currency==PropaneConstants.USD) {
//              vSales.usd_currency=sale.currency;
//              vSales.usd_amount = sale.price;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.RTGS) {
//              vSales.rtgs_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = sale.price;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.SWIPE) {
//              vSales.swipe_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = sale.price;
//              vSales.ecocash_amount = zero;
//            }
//            else if(sale.currency==PropaneConstants.ECOCASH) {
//              vSales.ecocash_currency=sale.currency;
//              vSales.usd_amount = zero;
//              vSales.rtgs_amount = zero;
//              vSales.swipe_amount = zero;
//              vSales.ecocash_amount = sale.price;
//            }
//
//            vsales.add(vSales);
//          }
//        }
//
//
//      });
//
//    });
//
//
//
//
//
//    print(vsales.length);
//    print('All Sales successfully pulled');
//    return vsales;
//
//  }
//
//
//
//
//
//
//
//
//
//  static getShops() {
//    return Firestore.instance
//        .collection(DBConstants.DB_SHOPS)
//        .getDocuments();
//  }

//  static Future<User> getUserFirestore(String userId) async {
//    if (userId != null) {
//      return Firestore.instance
//          .collection('users')
//          .document(userId)
//          .get()
//          .then((documentSnapshot) => User.fromDocument(documentSnapshot));
//    } else {
//      print('firestore userId can not be null');
//      return null;
//    }
//  }
//  List<String> getShops() async{
//    Firestore.instance
//        .collection('shops')
//        .snapshots();
//
//        return null;
//  }

//  static void LoadDataToLocal(){
//    LShop shop;
//    Firestore.instance.collection('shops').snapshots().listen((data) {
//      data.documents.forEach((doc) async {
//        print(doc["plant_name"]);
//        shop=new LShop();
//        shop.plant_name = doc["plant_name"];
//        shop.address = doc["address"];
//        shop.shop_type = doc["shop_type"];
//        shop.shop_id = doc["shop_id"];
//        int res = await helper.insertShop(shop);
//        print(shop.toString());
//        print('Result yedu itz $res');
//        if (res == 1) {
//          print('Succeffully added shop');
//        }
//        else {
//          print('Shop already exists');
//        }
//      });
//    });
//
//  }

}
