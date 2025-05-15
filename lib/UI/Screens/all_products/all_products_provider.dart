import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class class_all_products_provider with ChangeNotifier {
  // List<Map<String, dynamic>> allItems = [
  //   {
  //     "image": "assets/images/medicine1.png",
  //     "name": "Panadol",
  //     "size": "1 Strip",
  //     "price": "60",
  //     "description": "Relieve pain and reduce fever with Panadol, containing paracetamol.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine2.png",
  //     "name": "Brufen",
  //     "size": "1 Strip",
  //     "price": "120",
  //     "description": "Brufen helps in relieving pain and inflammation, containing ibuprofen.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine3.png",
  //     "name": "Augmentin",
  //     "size": "1 Pack",
  //     "price": "300",
  //     "description": "Augmentin is an antibiotic used to treat bacterial infections.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine4.png",
  //     "name": "Advil",
  //     "size": "1 Strip",
  //     "price": "110",
  //     "description": "Advil provides fast pain relief from headaches, back pain, and muscle aches.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine5.png",
  //     "name": "Zyrtec",
  //     "size": "1 Strip",
  //     "price": "80",
  //     "description": "Zyrtec provides 24-hour relief from allergy symptoms like sneezing and runny nose.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine6.png",
  //     "name": "Claritin",
  //     "size": "1 Strip",
  //     "price": "95",
  //     "description": "Claritin is an antihistamine used to treat allergies and skin rashes.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine7.png",
  //     "name": "Nurofen",
  //     "size": "1 Strip",
  //     "price": "130",
  //     "description": "Nurofen relieves mild to moderate pain and inflammation.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine8.png",
  //     "name": "Voltaren",
  //     "size": "1 Tube",
  //     "price": "200",
  //     "description": "Voltaren gel is effective for relieving joint and muscle pain.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine9.png",
  //     "name": "Maalox",
  //     "size": "1 Bottle",
  //     "price": "150",
  //     "description": "Maalox is an antacid that treats heartburn, acid indigestion, and gas.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine10.png",
  //     "name": "Imodium",
  //     "size": "1 Strip",
  //     "price": "75",
  //     "description": "Imodium is used to relieve diarrhea and restore normal bowel function.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine11.png",
  //     "name": "Buscopan",
  //     "size": "1 Strip",
  //     "price": "90",
  //     "description": "Buscopan helps relieve abdominal cramps and spasms.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine12.png",
  //     "name": "Tylenol",
  //     "size": "1 Strip",
  //     "price": "100",
  //     "description": "Tylenol provides fast relief from headaches and minor body pains.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine13.png",
  //     "name": "Strepsils",
  //     "size": "1 Pack",
  //     "price": "50",
  //     "description": "Strepsils soothes sore throat pain and irritation with a cooling effect.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine14.png",
  //     "name": "Erythrocin",
  //     "size": "1 Pack",
  //     "price": "250",
  //     "description": "Erythrocin is used to treat bacterial infections like respiratory infections.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine15.png",
  //     "name": "Metrogyl",
  //     "size": "1 Strip",
  //     "price": "40",
  //     "description": "Metrogyl is used to treat infections caused by bacteria and parasites.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine16.png",
  //     "name": "Zantac",
  //     "size": "1 Pack",
  //     "price": "180",
  //     "description": "Zantac is an antacid that reduces stomach acid production.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine17.png",
  //     "name": "Cepacol",
  //     "size": "1 Box",
  //     "price": "60",
  //     "description": "a multivitamin used to treat or prevent vitamin deficiency due to poor diet, certain illnesses, or during pregnancy. .",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine18.png",
  //     "name": "Vitrum",
  //     "size": "1 Box",
  //     "price": "140",
  //     "description": "Vitrum multivitamin tablet is intended to address vitamin and mineral deficiencies that can happen as a result of unhealthy dietary practices. ",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine19.png",
  //     "name": "Lipitor",
  //     "size": "1 Strip",
  //     "price": "300",
  //     "description": "Lipitor is used to lower cholesterol and reduce the risk of heart disease.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine20.png",
  //     "name": "Ispaghol Husk",
  //     "size": "1 Pack",
  //     "price": "250",
  //     "description": "Hashmi Ispaghol Husk is a gentle natural fibre and is said to be effective for use in constipation, acute thirst, piles, obesity, cholesterol lowering, ulcer, acidity, and bowel irregularities. ",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine21.png",
  //     "name": "Rennie",
  //     "size": "1 Pack",
  //     "price": "40",
  //     "description": "Rennie provides fast relief from heartburn and indigestion.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine22.png",
  //     "name": "Bepanthen",
  //     "size": "1 Tube",
  //     "price": "90",
  //     "description": "Bepanthen cream soothes and heals irritated or damaged skin.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine23.png",
  //     "name": "Vicks Vaporub",
  //     "size": "1 Bottle",
  //     "price": "50",
  //     "description": "Vicks Vaporub helps relieve cough and nasal congestion.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine24.png",
  //     "name": "Tums",
  //     "size": "1 Pack",
  //     "price": "45",
  //     "description": "Tums are an antacid that provides relief from heartburn and indigestion.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine25.png",
  //     "name": "Anadin",
  //     "size": "1 Strip",
  //     "price": "60",
  //     "description": "Anadin is used for fast relief from headaches and muscle aches.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine26.png",
  //     "name": "Benylin",
  //     "size": "1 Bottle",
  //     "price": "110",
  //     "description": "Benylin cough syrup provides relief from dry and chesty coughs.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine27.png",
  //     "name": "Lemsip",
  //     "size": "1 Pack",
  //     "price": "100",
  //     "description": "Lemsip is a cold and flu remedy that reduces fever and relieves symptoms.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine28.png",
  //     "name": "Neosporin",
  //     "size": "1 Tube",
  //     "price": "120",
  //     "description": "Neosporin helps prevent infections in minor cuts, scrapes, and burns.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine29.png",
  //     "name": "Cetaphil",
  //     "size": "1 Bottle",
  //     "price": "200",
  //     "description": "Cetaphil is a gentle skin cleanser for all skin types.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine30.png",
  //     "name": "Mucinex",
  //     "size": "1 Strip",
  //     "price": "95",
  //     "description": "Mucinex relieves chest congestion and thins mucus.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine31.png",
  //     "name": "Pepto-Bismol",
  //     "size": "1 Bottle",
  //     "price": "80",
  //     "description": "Pepto-Bismol relieves diarrhea, heartburn, and upset stomach.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine32.png",
  //     "name": "Rizatriptan",
  //     "size": "1 Strip",
  //     "price": "250",
  //     "description": "Rizatriptan is used to treat migraine headaches.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine33.png",
  //     "name": "Nasonex",
  //     "size": "1 Bottle",
  //     "price": "230",
  //     "description": "Nasonex is used to relieve allergy symptoms such as nasal congestion.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine34.png",
  //     "name": "Sudafed",
  //     "size": "1 Strip",
  //     "price": "110",
  //     "description": "Sudafed provides relief from nasal congestion caused by colds and allergies.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine35.png",
  //     "name": "Alka-Seltzer",
  //     "size": "1 Pack",
  //     "price": "75",
  //     "description": "Alka-Seltzer provides relief from indigestion and heartburn.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine36.png",
  //     "name": "Benadryl",
  //     "size": "1 Bottle",
  //     "price": "120",
  //     "description": "Benadryl provides relief from allergy symptoms such as sneezing and itching.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine37.png",
  //     "name": "Omeprazole",
  //     "size": "1 Pack",
  //     "price": "300",
  //     "description": "Omeprazole reduces the production of stomach acid to relieve heartburn.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine38.png",
  //     "name": "Gaviscon",
  //     "size": "1 Bottle",
  //     "price": "200",
  //     "description": "Gaviscon relieves heartburn and acid reflux by neutralizing stomach acid.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine39.png",
  //     "name": "Nicorette",
  //     "size": "1 Pack",
  //     "price": "400",
  //     "description": "Nicorette helps to quit smoking by providing a controlled amount of nicotine.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine40.png",
  //     "name": "Loperamide",
  //     "size": "1 Strip",
  //     "price": "55",
  //     "description": "Loperamide is used to treat diarrhea and restore normal bowel movements.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine41.png",
  //     "name": "Zofran",
  //     "size": "1 Strip",
  //     "price": "280",
  //     "description": "Zofran is used to prevent nausea and vomiting caused by surgery or chemotherapy.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine42.png",
  //     "name": "Phenylephrine",
  //     "size": "1 Strip",
  //     "price": "65",
  //     "description": "Phenylephrine provides relief from nasal congestion.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine43.png",
  //     "name": "Voltfast",
  //     "size": "1 Strip",
  //     "price": "180",
  //     "description": "Voltfast is used to relieve pain, swelling, and inflammation.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine44.png",
  //     "name": "Levemir",
  //     "size": "1 Pack",
  //     "price": "400",
  //     "description": "Levemir is a long-acting insulin used to treat diabetes.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine45.png",
  //     "name": "Doxycycline",
  //     "size": "1 Strip",
  //     "price": "190",
  //     "description": "Doxycycline is used to treat bacterial infections.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine46.png",
  //     "name": "Ivermectin",
  //     "size": "1 Strip",
  //     "price": "150",
  //     "description": "Ivermectin is used to treat parasitic infections.",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine47.png",
  //     "name": "Pariet",
  //     "size": "1 Strip",
  //     "price": "220",
  //     "description": "Pariet is used to treat gastroesophageal reflux disease (GERD).",
  //     "isPopular": true,
  //   },
  //   {
  //     "image": "assets/images/medicine48.png",
  //     "name": "Telfast",
  //     "size": "1 Strip",
  //     "price": "160",
  //     "description": "Telfast provides relief from hay fever and skin allergy symptoms.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine49.png",
  //     "name": "Creon",
  //     "size": "1 Pack",
  //     "price": "350",
  //     "description": "Creon is used to treat pancreatic enzyme deficiencies.",
  //     "isPopular": false,
  //   },
  //   {
  //     "image": "assets/images/medicine50.png",
  //     "name": "Eucerin",
  //     "size": "1 Tube",
  //     "price": "180",
  //     "description": "Eucerin lotion soothes and moisturizes dry skin.",
  //     "isPopular": true,
  //   },
  // ];


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//For fetching all Medicines from firestore
  Future<List<Map<String, dynamic>>> fetchAllItemsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('medicines').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw e;
    }
  }

  // Function to fetch popular items from the 'medicines' collection
  Future<List<Map<String, dynamic>>> fetchPopularItemsFromFirebase() async {
    // Query the 'medicines' collection where 'isPopular' is true
    QuerySnapshot snapshot = await _firestore
        .collection('medicines')
        .where('isPopular', isEqualTo: true)
        .get();

    // Mapping the documents to a list of Maps
    return snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
  }

}



