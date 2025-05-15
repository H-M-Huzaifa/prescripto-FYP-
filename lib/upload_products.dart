import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class UploadProducts {
  final List<Map<String, dynamic>> products = [
    {
      "image": "assets/images/medicine1.png",
      "name": "Ansid",
      "size": "1 Strip",
      "price": "120",
      "description": "Ansid is used to treat acid reflux and heartburn by reducing stomach acid production.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine2.png",
      "name": "Amoxil",
      "size": "1 Pack",
      "price": "180",
      "description": "Amoxil is an antibiotic used to treat a wide range of bacterial infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine3.png",
      "name": "Avil",
      "size": "1 Strip",
      "price": "60",
      "description": "Avil is an antihistamine that provides relief from allergic reactions and hay fever symptoms.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine4.png",
      "name": "Brexin",
      "size": "1 Strip",
      "price": "140",
      "description": "Brexin helps reduce inflammation and provides relief from pain and swelling.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine5.png",
      "name": "Calamox",
      "size": "1 Pack",
      "price": "220",
      "description": "Calamox is a combination antibiotic used to treat various bacterial infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine6.png",
      "name": "Caloned",
      "size": "1 Strip",
      "price": "90",
      "description": "Caloned is used to treat pain and inflammation associated with arthritis and muscle injuries.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine7.png",
      "name": "Capoten",
      "size": "1 Strip",
      "price": "160",
      "description": "Capoten is used to treat high blood pressure and certain types of heart failure.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine8.png",
      "name": "Cefiget",
      "size": "1 Pack",
      "price": "250",
      "description": "Cefiget is a cephalosporin antibiotic used to treat bacterial infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine9.png",
      "name": "Cefim",
      "size": "1 Pack",
      "price": "280",
      "description": "Cefim is an antibiotic used to treat respiratory, urinary, and skin infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine10.png",
      "name": "Ciprofloxacin",
      "size": "1 Strip",
      "price": "190",
      "description": "Ciprofloxacin is a broad-spectrum antibiotic used to treat various bacterial infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine11.png",
      "name": "Desora",
      "size": "1 Strip",
      "price": "110",
      "description": "Desora is an antihistamine that helps relieve allergy symptoms such as sneezing and itching.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine12.png",
      "name": "Diclofenac",
      "size": "1 Strip",
      "price": "85",
      "description": "Diclofenac is a non-steroidal anti-inflammatory drug used to treat pain and inflammation.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine13.png",
      "name": "Dubloxetie",
      "size": "1 Strip",
      "price": "240",
      "description": "Dubloxetie is used to treat depression, anxiety, and certain types of chronic pain.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine14.png",
      "name": "Dupbaston",
      "size": "1 Strip",
      "price": "170",
      "description": "Dupbaston is used to treat menstrual disorders and hormone imbalances in women.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine15.png",
      "name": "Estar",
      "size": "1 Strip",
      "price": "130",
      "description": "Estar is used to lower blood pressure and treat heart conditions.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine16.png",
      "name": "Eziday",
      "size": "1 Strip",
      "price": "150",
      "description": "Eziday helps control high blood pressure and improves circulation.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine17.png",
      "name": "Flagyl",
      "size": "1 Strip",
      "price": "95",
      "description": "Flagyl is an antibiotic used to treat various bacterial and parasitic infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine18.png",
      "name": "Flexin",
      "size": "1 Strip",
      "price": "105",
      "description": "Flexin provides relief from muscle pain and stiffness, and reduces inflammation.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine19.png",
      "name": "Folicacid",
      "size": "1 Bottle",
      "price": "70",
      "description": "Folicacid is a B vitamin supplement important for cell growth and metabolism.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine20.png",
      "name": "Gabica",
      "size": "1 Strip",
      "price": "210",
      "description": "Gabica is used to treat neuropathic pain and certain types of seizures.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine21.png",
      "name": "Glucophage",
      "size": "1 Strip",
      "price": "180",
      "description": "Glucophage is used to manage blood sugar levels in people with type 2 diabetes.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine22.png",
      "name": "Hilavta",
      "size": "1 Pack",
      "price": "260",
      "description": "Hilavta is used to treat high cholesterol and reduce the risk of cardiovascular disease.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine23.png",
      "name": "Iberet",
      "size": "1 Bottle",
      "price": "120",
      "description": "Iberet is an iron supplement used to treat or prevent iron-deficiency anemia.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine24.png",
      "name": "Imodium",
      "size": "1 Strip",
      "price": "75",
      "description": "Imodium is used to relieve diarrhea and restore normal bowel function.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine25.png",
      "name": "Lorid",
      "size": "1 Strip",
      "price": "90",
      "description": "Lorid is an antihistamine that provides relief from allergic reactions and symptoms.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine26.png",
      "name": "Methycobal",
      "size": "1 Strip",
      "price": "230",
      "description": "Methycobal is used to treat vitamin B12 deficiency and peripheral neuropathy.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine27.png",
      "name": "Myteka",
      "size": "1 Strip",
      "price": "200",
      "description": "Myteka is used to prevent asthma attacks and manage seasonal allergies.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine28.png",
      "name": "Nezkil",
      "size": "1 Strip",
      "price": "85",
      "description": "Nezkil provides relief from cold and flu symptoms including congestion and fever.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine29.png",
      "name": "Nospa",
      "size": "1 Strip",
      "price": "65",
      "description": "Nospa helps relieve abdominal pain and spasms in the digestive tract.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine30.png",
      "name": "Omega",
      "size": "1 Bottle",
      "price": "300",
      "description": "Omega supplements support heart health, brain function, and reduce inflammation.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine31.png",
      "name": "Omeprazole",
      "size": "1 Pack",
      "price": "140",
      "description": "Omeprazole reduces the production of stomach acid to relieve heartburn and acid reflux.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine32.png",
      "name": "Brufen",
      "size": "1 Strip",
      "price": "120",
      "description": "Brufen helps in relieving pain and inflammation, containing ibuprofen.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine33.png",
      "name": "Piroxicam",
      "size": "1 Strip",
      "price": "95",
      "description": "Piroxicam is a non-steroidal anti-inflammatory drug used to treat arthritis and pain.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine34.png",
      "name": "Risek",
      "size": "1 Pack",
      "price": "160",
      "description": "Risek is used to reduce stomach acid and treat conditions like heartburn and ulcers.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine35.png",
      "name": "Rosulin",
      "size": "1 Strip",
      "price": "280",
      "description": "Rosulin is used to lower cholesterol and reduce the risk of heart disease.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine36.png",
      "name": "Sangobion",
      "size": "1 Bottle",
      "price": "150",
      "description": "Sangobion is an iron supplement that helps prevent and treat iron deficiency anemia.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine37.png",
      "name": "Spasfon",
      "size": "1 Strip",
      "price": "70",
      "description": "Spasfon helps relieve abdominal pain caused by smooth muscle spasms.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine38.png",
      "name": "Subex",
      "size": "1 Strip",
      "price": "320",
      "description": "Subex is used in the treatment of substance dependence and addiction.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine39.png",
      "name": "Tercica",
      "size": "1 Pack",
      "price": "270",
      "description": "Tercica is used to treat growth failure and hormone deficiencies.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine40.png",
      "name": "Tramadol",
      "size": "1 Strip",
      "price": "190",
      "description": "Tramadol is used to treat moderate to severe pain in adults.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine41.png",
      "name": "Tylenol",
      "size": "1 Strip",
      "price": "100",
      "description": "Tylenol provides fast relief from headaches and minor body pains.",
      "isPopular": true
    },
    {
      "image": "assets/images/medicine42.png",
      "name": "Velosef",
      "size": "1 Pack",
      "price": "240",
      "description": "Velosef is a cephalosporin antibiotic used to treat various bacterial infections.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine43.png",
      "name": "Vitrum",
      "size": "1 Box",
      "price": "140",
      "description": "Vitrum multivitamin tablet is intended to address vitamin and mineral deficiencies due to unhealthy dietary practices.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine44.png",
      "name": "Voltral",
      "size": "1 Tube",
      "price": "180",
      "description": "Voltral gel is used to relieve joint and muscle pain, reducing inflammation locally.",
      "isPopular": false
    },
    {
      "image": "assets/images/medicine45.png",
      "name": "Voren",
      "size": "1 Strip",
      "price": "110",
      "description": "Voren is a non-steroidal anti-inflammatory drug that relieves pain and reduces inflammation.",
      "isPopular": false
    }
  ];

  Future<void> uploadProducts() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (var product in products) {
      final String medicineName =
          product['name']; // or product['medicine_name'] based on your key

      if (medicineName == null || medicineName.isEmpty) {
        debugPrint('⚠️ Skipped product with missing name: $product');
        continue;
      }

// Use medicine name as document ID
      DocumentReference docRef =
          firestore.collection('medicines').doc(medicineName);
      batch.set(docRef, product);
    }

    try {
      await batch.commit();
      debugPrint('✅ Products uploaded successfully');
    } catch (e) {
      debugPrint('❌ Failed to upload products: $e');
    }
  }
}
