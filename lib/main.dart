import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'dart:math';

void main() {
  runApp(const JosecastTrialApp());
}

class JosecastTrialApp extends StatelessWidget {
  const JosecastTrialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Josecast Trial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF3498DB),
        cardColor: const Color(0xFF1F2933),
        dividerColor: const Color(0xFF334155),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Segoe UI'),
          bodyMedium: TextStyle(color: Color(0xFF94A3B8), fontFamily: 'Segoe UI'),
        ),
      ),
      home: const MainLauncherScreen(),
    );
  }
}

// =========================================================================
// 1. DATA MODELLERİ
// =========================================================================
class MaterialItem {
  final String nameKey;
  String? customName; 
  final Map<String, double> comp; 
  final double fe;
  double price;
  double maxKg;
  bool use;
  double calculatedKg;

  MaterialItem({
    required this.nameKey,
    this.customName,
    required this.comp,
    required this.fe,
    required this.price,
    required this.maxKg,
    this.use = true,
    this.calculatedKg = 0.0,
  });
}

class TargetValues {
  double min;
  double mid;
  double max;
  TargetValues({required this.min, required this.mid, required this.max});
}

// =========================================================================
// 2. YERELLEŞTİRME SİSTEMİ 
// =========================================================================
class Localization {
  static const Map<String, Map<String, String>> strings = {
    'TR': {
      'panel_title': 'DÖKÜM OPTİMİZASYON PANELİ',
      'btn_charge': 'OCAK ŞARJ ANALİZİ\n(ÜCRETSİZ MODÜL)',
      'furnace_info': 'Ocak Bilgileri',
      'target_mass': 'Hedef Kütle (kg):',
      'half_furnace': 'Yarım Ocak (Sıvı Metal)',
      'empty_furnace': 'Boş Ocak',
      'half_mass': 'Yarım Ocak Kütlesi (kg):',
      'half_furnace_analysis': 'Yarım Ocak Analizi (wt%)',
      'target_analysis': 'Hedef Analiz (wt%) - Min / Hedef / Max',
      'materials_list': 'Malzeme Listesi',
      'calculate': '⚙️ HESAPLA (Matris Motoru)',
      'results': '=== JOSECAST MATRİS OPTİMİZASYON RAPORU ===',
      'total_cost': 'Toplam Hammadde Maliyeti:',
      'estimated_fe': 'Tahmini Fe Oranı:',
      'mat_name': 'Malzeme',
      'amount': 'Miktar',
      'status': 'Durum',
      'ok': 'UYGUN',
      'price': 'Fiyat:',
      'limit': 'Sınır:',
      'unlimited': 'Sınırsız',
      'chem_dist': 'Kimyasal Analiz Dağılımı:',
      'element': 'El',
      'result_val': 'Sonuç',
      'error_no_mat': 'Hata: Hiçbir malzeme seçilmedi!',
      'error_math': 'Matematiksel olarak bu hedefe ulaşmak imkansız! Lütfen toleransları gevşetin.',
      'error_mass': 'Yarım ocak kütlesi, hedef kütleden büyük olamaz!',
      'mat_pig': 'Pik Demir',
      'mat_scrap': 'Çelik Hurdası',
      'mat_femn': 'FeMn (FerroMangan)',
      'mat_fesi': 'FeSi (FerroSilis)',
      'mat_carbon': 'Karbon Verici',
      'ad_title': 'JOSE CAST SUITE TAM SÜRÜM',
      'ad_desc': '5 Profesyonel Modül ile Dökümhanenizi Dijitalleştirin! (www.josecastsuite.com)',
      'pro_1': 'Şarj Optimizasyonu (Aktif)',
      'pro_2': 'Yolluk & Besleyici Tasarımı 🔒',
      'pro_3': 'Dolum Süresi Analizi 🔒',
      'pro_4': 'Demir Döküm Parametreleri 🔒',
      'pro_5': 'Çelik Döküm Parametreleri 🔒',
      'edit_mat': 'Malzemeyi Düzenle',
      'name': 'Malzeme Adı',
      'cancel': 'İptal',
      'save': 'Kaydet',
      'chem_analysis': 'Kimyasal Analiz (%)',
    },
    'EN': {
      'panel_title': 'CASTING OPTIMIZATION PANEL',
      'btn_charge': 'CHARGE OPTIMIZATION\n(FREE MODULE)',
      'furnace_info': 'Furnace Information',
      'target_mass': 'Target Mass (kg):',
      'half_furnace': 'Half Furnace (Liquid Metal)',
      'empty_furnace': 'Empty Furnace',
      'half_mass': 'Half Furnace Mass (kg):',
      'half_furnace_analysis': 'Half Furnace Analysis (wt%)',
      'target_analysis': 'Target Analysis (wt%) - Min / Target / Max',
      'materials_list': 'Materials List',
      'calculate': '⚙️ CALCULATE (Matrix Engine)',
      'results': '=== JOSECAST MATRIX OPTIMIZATION REPORT ===',
      'total_cost': 'Total Raw Material Cost:',
      'estimated_fe': 'Estimated Fe Ratio:',
      'mat_name': 'Material',
      'amount': 'Amount',
      'status': 'Status',
      'ok': 'OK',
      'price': 'Price:',
      'limit': 'Limit:',
      'unlimited': 'Unlimited',
      'chem_dist': 'Chemical Analysis Distribution:',
      'element': 'El',
      'result_val': 'Result',
      'error_no_mat': 'Error: No materials selected!',
      'error_math': 'Mathematically impossible to reach targets! Please loosen constraints.',
      'error_mass': 'Half furnace mass cannot be greater than target mass!',
      'mat_pig': 'Pig Iron',
      'mat_scrap': 'Steel Scrap',
      'mat_femn': 'FeMn (FerroManganese)',
      'mat_fesi': 'FeSi (FerroSilicon)',
      'mat_carbon': 'Carbon Raiser',
      'ad_title': 'JOSE CAST SUITE PRO VERSION',
      'ad_desc': 'Digitize your foundry with 5 Professional Modules, just 100 dolar away. (www.josecastsuite.com)',
      'pro_1': 'Charge Optimization (Active)',
      'pro_2': 'Gating & Riser Design 🔒',
      'pro_3': 'Fill Time Analysis 🔒',
      'pro_4': 'Iron Casting Parameters 🔒',
      'pro_5': 'Steel Casting Parameters 🔒',
      'edit_mat': 'Edit Material',
      'name': 'Material Name',
      'cancel': 'Cancel',
      'save': 'Save',
      'chem_analysis': 'Chemical Analysis (%)',
    },
    'DE': {
      'panel_title': 'GUSSOPTIMIERUNGS-PANEL',
      'btn_charge': 'CHARGENOPTIMIERUNG\n(KOSTENLOSES MODUL)',
      'furnace_info': 'Ofeninformationen',
      'target_mass': 'Zielgewicht (kg):',
      'half_furnace': 'Halber Ofen (Flüssigmetall)',
      'empty_furnace': 'Leerer Ofen',
      'half_mass': 'Gewicht halber Ofen (kg):',
      'half_furnace_analysis': 'Halber Ofen Analyse (wt%)',
      'target_analysis': 'Zielanalyse (wt%) - Min / Ziel / Max',
      'materials_list': 'Materialliste',
      'calculate': '⚙️ BERECHNEN (Matrix-Engine)',
      'results': '=== JOSECAST MATRIX OPTIMIERUNGSBERICHT ===',
      'total_cost': 'Rohstoffkosten Gesamt:',
      'estimated_fe': 'Geschätzter Fe-Anteil:',
      'mat_name': 'Material',
      'amount': 'Menge',
      'status': 'Status',
      'ok': 'OK',
      'price': 'Preis:',
      'limit': 'Grenze:',
      'unlimited': 'Unbegrenzt',
      'chem_dist': 'Chemische Analyse Verteilung:',
      'element': 'El',
      'result_val': 'Ergebnis',
      'error_no_mat': 'Fehler: Keine Materialien ausgewählt!',
      'error_math': 'Mathematisch unmöglich, Ziele zu erreichen! Bitte Toleranzen lockern.',
      'error_mass': 'Halbofengewicht darf Zielgewicht nicht überschreiten!',
      'mat_pig': 'Roheisen',
      'mat_scrap': 'Stahlschrott',
      'mat_femn': 'FeMn (Ferromangan)',
      'mat_fesi': 'FeSi (Ferrosilizium)',
      'mat_carbon': 'Aufkohlungsmittel',
      'ad_title': 'JOSE CAST SUITE PRO VERSION',
      'ad_desc': 'Digitalisieren Sie Ihre Gießerei mit 5 professionellen Modulen – für nur 100 Dollar. (www.josecastsuite.com)',
      'pro_1': 'Chargenoptimierung (Aktiv)',
      'pro_2': 'Anschnitt & Speiser Design 🔒',
      'pro_3': 'Gießzeit-Analyse 🔒',
      'pro_4': 'Eisenguss Parameter 🔒',
      'pro_5': 'Stahlguss Parameter 🔒',
      'edit_mat': 'Material bearbeiten',
      'name': 'Materialname',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'chem_analysis': 'Chemische Analyse (%)',
    }
  };
}

// =========================================================================
// 3. ANA EKRAN 
// =========================================================================
class MainLauncherScreen extends StatefulWidget {
  const MainLauncherScreen({super.key});

  @override
  State<MainLauncherScreen> createState() => _MainLauncherScreenState();
}

class _MainLauncherScreenState extends State<MainLauncherScreen> {
  String currentLang = 'TR';

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://www.josecastsuite.com/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Siteye gidilemedi: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = Localization.strings[currentLang]!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: ['TR', 'EN', 'DE'].map((lang) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ChoiceChip(
                      label: Text(lang, style: const TextStyle(fontWeight: FontWeight.bold)),
                      selected: currentLang == lang,
                      selectedColor: const Color(0xFF3498DB),
                      onSelected: (bool selected) {
                        if (selected) setState(() => currentLang = lang);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20), 

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChargeCalculatorScreen(lang: currentLang)),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF3498DB), Color(0xFF2980B9)]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.calculate, size: 70, color: Colors.white),
                            const SizedBox(height: 15),
                            Text(
                              local['btn_charge']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    InkWell(
                      onTap: _launchURL,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F2933),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber.withOpacity(0.8), width: 1.5),
                          boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 28),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    local['ad_title']!,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                                  ),
                                ),
                                const Icon(Icons.open_in_new, color: Colors.amber, size: 20),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(local['ad_desc']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            const Divider(height: 30, color: Colors.white24),
                            
                            _buildProListItem(Icons.check_circle, local['pro_1']!, Colors.green),
                            _buildProListItem(Icons.lock, local['pro_2']!, Colors.white38),
                            _buildProListItem(Icons.lock, local['pro_3']!, Colors.white38),
                            _buildProListItem(Icons.lock, local['pro_4']!, Colors.white38),
                            _buildProListItem(Icons.lock, local['pro_5']!, Colors.white38),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProListItem(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. PRO MATRİS OPTİMİZASYON MOTORU
// =========================================================================
class ChargeOptimizer {
  static Map<String, dynamic> optimize({
    required List<MaterialItem> materials,
    required double targetMass,
    required double halfMass,
    required Map<String, double> halfAnalysis,
    required Map<String, TargetValues> targets,
  }) {
    List<MaterialItem> activeMats = materials.where((m) => m.use).toList();
    if (activeMats.isEmpty) throw Exception("no_mat");

    double chargeMass = max(0.0, targetMass - halfMass);
    int n = activeMats.length;
    List<double> prices = activeMats.map((m) => m.price).toList();
    List<double> maxKgs = activeMats.map((m) => m.maxKg > 0 ? m.maxKg : chargeMass).toList();
    
    List<String> controlElements = ["C", "Si", "Mn", "P", "S"];

    double evaluate(List<double> x) {
      double cost = 0.0;
      for (int i = 0; i < n; i++) cost += x[i] * prices[i];

      double penalty = 0.0;
      if (targetMass > 0) {
        for (String el in controlElements) {
          double halfElemMass = halfMass * ((halfAnalysis[el] ?? 0.0) / 100.0);
          double chargeElemMass = 0.0;
          for (int i = 0; i < n; i++) {
            chargeElemMass += x[i] * ((activeMats[i].comp[el] ?? 0.0) / 100.0);
          }
          double finalPct = ((halfElemMass + chargeElemMass) / targetMass) * 100.0;
          TargetValues t = targets[el]!;
          
          if (t.mid > 0) penalty += pow(finalPct - t.mid, 2) * 5000.0;
          if (t.min > 0 && finalPct < t.min) penalty += pow(t.min - finalPct, 2) * 50000.0;
          if (t.max > 0 && finalPct > t.max) penalty += pow(finalPct - t.max, 2) * 50000.0;
        }
      }
      return cost + penalty;
    }

    List<double> project(List<double> x) {
      List<double> p = List.from(x);
      for (int iter = 0; iter < 15; iter++) {
        double currentSum = 0;
        for (int i = 0; i < n; i++) {
          p[i] = max(0.0, min(p[i], maxKgs[i]));
          currentSum += p[i];
        }
        double diff = chargeMass - currentSum;
        if (diff.abs() < 1e-4) break;

        int freeCount = 0;
        for (int i = 0; i < n; i++) {
          if ((diff > 0 && p[i] < maxKgs[i]) || (diff < 0 && p[i] > 0)) freeCount++;
        }
        if (freeCount == 0) break;
        double adj = diff / freeCount;
        for (int i = 0; i < n; i++) {
          if ((diff > 0 && p[i] < maxKgs[i]) || (diff < 0 && p[i] > 0)) p[i] += adj;
        }
      }
      return p;
    }

    Random rand = Random();
    List<double> bestX = project(List.generate(n, (_) => chargeMass / n));
    double bestScore = evaluate(bestX);

    for (int p = 0; p < 80; p++) {
      List<double> candidate = project(List.generate(n, (_) => rand.nextDouble()));
      double score = evaluate(candidate);
      if (score < bestScore) {
        bestScore = score;
        bestX = List.from(candidate);
      }
    }

    double stepSize = chargeMass * 0.2;
    for (int step = 0; step < 1500; step++) {
      List<double> nextX = List.from(bestX);
      for (int i = 0; i < n; i++) nextX[i] += (rand.nextDouble() * 2 - 1) * stepSize;
      nextX = project(nextX);
      double score = evaluate(nextX);

      if (score < bestScore) {
        bestScore = score;
        bestX = List.from(nextX);
      } else {
        stepSize *= 0.995; 
      }
    }

    if (bestScore > 1e7) throw Exception("math_fail");

    for (int i = 0; i < activeMats.length; i++) {
      activeMats[i].calculatedKg = bestX[i] > 0.01 ? bestX[i] : 0.0;
    }

    Map<String, double> finalAnalysis = {};
    for (String el in controlElements) {
      double totalWeight = halfMass * ((halfAnalysis[el] ?? 0.0) / 100.0);
      for (var m in activeMats) totalWeight += m.calculatedKg * ((m.comp[el] ?? 0.0) / 100.0);
      finalAnalysis[el] = targetMass > 0 ? (totalWeight / targetMass) * 100.0 : 0.0;
    }

    double totalCost = 0.0, totalFe = 0.0;
    for (var m in activeMats) {
      totalCost += m.calculatedKg * m.price;
      totalFe += m.calculatedKg * (m.fe / 100.0);
    }

    return {
      "materials": activeMats,
      "analysis": finalAnalysis,
      "cost": totalCost,
      "fe_percent": targetMass > 0 ? (totalFe / targetMass) * 100.0 : 0.0
    };
  }
}

// =========================================================================
// 5. OCAK ŞARJ HESAPLAMA EKRANI 
// =========================================================================
class ChargeCalculatorScreen extends StatefulWidget {
  final String lang;
  const ChargeCalculatorScreen({super.key, required this.lang});

  @override
  State<ChargeCalculatorScreen> createState() => _ChargeCalculatorScreenState();
}

class _ChargeCalculatorScreenState extends State<ChargeCalculatorScreen> {
  bool isHalfFurnace = false;
  final TextEditingController _targetMassController = TextEditingController(text: "1000");
  final TextEditingController _halfMassController = TextEditingController(text: "0");

  Map<String, TextEditingController> halfMinControllers = {};
  Map<String, TextEditingController> targetMinControllers = {};
  Map<String, TextEditingController> targetMidControllers = {};
  Map<String, TextEditingController> targetMaxControllers = {};

  List<MaterialItem> materialsDb = [];
  Map<String, dynamic>? optResult;
  String errorMsg = "";

  final List<String> demoElements = ["C", "Si", "Mn", "P", "S"];

  @override
  void initState() {
    super.initState();
    materialsDb = [
      MaterialItem(nameKey: "mat_pig", comp: {"C": 4.0, "Si": 1.5, "Mn": 0.4, "P": 0.03, "S": 0.02}, fe: 94.0, price: 18.5, maxKg: 0),
      MaterialItem(nameKey: "mat_scrap", comp: {"C": 0.2, "Si": 0.2, "Mn": 0.6, "P": 0.035, "S": 0.035}, fe: 98.0, price: 14.0, maxKg: 0),
      MaterialItem(nameKey: "mat_femn", comp: {"C": 7.0, "Si": 1.0, "Mn": 75.0, "P": 0.05, "S": 0.02}, fe: 16.0, price: 45.0, maxKg: 50),
      MaterialItem(nameKey: "mat_fesi", comp: {"C": 0.1, "Si": 75.0, "Mn": 0.2, "P": 0.04, "S": 0.01}, fe: 24.0, price: 52.0, maxKg: 30),
      MaterialItem(nameKey: "mat_carbon", comp: {"C": 98.0, "Si": 0.1, "Mn": 0.05, "P": 0.01, "S": 0.01}, fe: 1.0, price: 28.0, maxKg: 0),
    ];

    Map<String, List<double>> defaultTargets = {
      "C": [0.22, 0.26, 0.30], "Si": [0.15, 0.22, 0.35], "Mn": [0.60, 0.80, 1.00],
      "P": [0.0, 0.0, 0.035], "S": [0.0, 0.0, 0.030],
    };

    for (var el in demoElements) {
      halfMinControllers[el] = TextEditingController(text: "0.0");
      targetMinControllers[el] = TextEditingController(text: defaultTargets[el]![0].toString());
      targetMidControllers[el] = TextEditingController(text: defaultTargets[el]![1].toString());
      targetMaxControllers[el] = TextEditingController(text: defaultTargets[el]![2].toString());
    }
  }

  void _editMaterialDialog(MaterialItem m, Map<String, String> local) {
    TextEditingController nameCtrl = TextEditingController(text: m.customName ?? (local[m.nameKey] ?? m.nameKey));
    TextEditingController priceCtrl = TextEditingController(text: m.price.toString());
    TextEditingController maxKgCtrl = TextEditingController(text: m.maxKg.toString());
    
    Map<String, TextEditingController> compControllers = {};
    for (String el in demoElements) {
      compControllers[el] = TextEditingController(text: (m.comp[el] ?? 0.0).toString());
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(local['edit_mat']!),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: local['name']!)),
              const SizedBox(height: 10),
              TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: local['price']!)),
              const SizedBox(height: 10),
              TextField(controller: maxKgCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "${local['limit']!} (0 = ${local['unlimited']!})")),
              const SizedBox(height: 25),
              
              Text(local['chem_analysis']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 15),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: demoElements.map((el) {
                  return SizedBox(
                    width: 65,
                    child: TextField(
                      controller: compControllers[el],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: el, 
                        isDense: true,
                        border: const OutlineInputBorder()
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(local['cancel']!, style: const TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3498DB)),
            onPressed: () {
              setState(() {
                m.customName = nameCtrl.text;
                m.price = double.tryParse(priceCtrl.text) ?? m.price;
                m.maxKg = double.tryParse(maxKgCtrl.text) ?? m.maxKg;
                for (String el in demoElements) {
                  m.comp[el] = double.tryParse(compControllers[el]!.text) ?? 0.0;
                }
              });
              Navigator.pop(ctx);
            },
            child: Text(local['save']!, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void runCalculation(Map<String, String> local) {
    setState(() { errorMsg = ""; optResult = null; });
    try {
      double targetMass = double.tryParse(_targetMassController.text) ?? 0.0;
      double halfMass = isHalfFurnace ? (double.tryParse(_halfMassController.text) ?? 0.0) : 0.0;
      
      if (isHalfFurnace && halfMass > targetMass) {
        setState(() => errorMsg = local['error_mass']!);
        return;
      }

      Map<String, double> halfAnal = {};
      Map<String, TargetValues> targets = {};

      halfMinControllers.forEach((key, controller) => halfAnal[key] = double.tryParse(controller.text) ?? 0.0);
      targetMinControllers.forEach((key, controller) {
        targets[key] = TargetValues(
          min: double.tryParse(controller.text) ?? 0.0,
          mid: double.tryParse(targetMidControllers[key]!.text) ?? 0.0,
          max: double.tryParse(targetMaxControllers[key]!.text) ?? 0.0,
        );
      });

      var res = ChargeOptimizer.optimize(
        materials: materialsDb, targetMass: targetMass, halfMass: halfMass,
        halfAnalysis: halfAnal, targets: targets,
      );
      
      res['isHalfFurnace'] = isHalfFurnace;
      res['halfMass'] = halfMass;
      res['targetMass'] = targetMass;
      
      setState(() => optResult = res);
    } catch (e) {
      setState(() => errorMsg = e.toString().contains("no_mat") ? local['error_no_mat']! : local['error_math']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = Localization.strings[widget.lang]!;

    return Scaffold(
      appBar: AppBar(title: Text(local['btn_charge']!.replaceAll('\n', ' ')), backgroundColor: const Color(0xFF1F2933)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF1F2933),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local['furnace_info']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3498DB))),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: RadioListTile<bool>(title: Text(local['empty_furnace']!, style: const TextStyle(fontSize: 14)), value: false, groupValue: isHalfFurnace, onChanged: (val) => setState(() => isHalfFurnace = val!))),
                        Expanded(child: RadioListTile<bool>(title: Text(local['half_furnace']!, style: const TextStyle(fontSize: 14)), value: true, groupValue: isHalfFurnace, onChanged: (val) => setState(() => isHalfFurnace = val!))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: _targetMassController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: local['target_mass'], border: const OutlineInputBorder()))),
                        if (isHalfFurnace) const SizedBox(width: 15),
                        if (isHalfFurnace) Expanded(child: TextFormField(controller: _halfMassController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: local['half_mass'], border: const OutlineInputBorder()))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // DÜZELTİLEN YARIM OCAK ELEMENT GİRİŞ ALANI (ARTIK SIKIŞMA YAPMAZ, YAZILIR)
            if (isHalfFurnace) ...[
              Card(
                color: const Color(0xFF1F2933),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(local['half_furnace_analysis']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                      const SizedBox(height: 12),
                      Row(
                        children: halfMinControllers.keys.map((el) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: TextFormField(
                                controller: halfMinControllers[el],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  labelText: el,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],

            Card(
              color: const Color(0xFF1F2933),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local['target_analysis']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF3498DB))),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: targetMinControllers.length,
                      itemBuilder: (context, index) {
                        String el = targetMinControllers.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text(el, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                              Expanded(child: TextFormField(controller: targetMinControllers[el], decoration: const InputDecoration(hintText: "Min"), keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: targetMidControllers[el], decoration: const InputDecoration(hintText: "Hedef"), keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: targetMaxControllers[el], decoration: const InputDecoration(hintText: "Max"), keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            Card(
              color: const Color(0xFF1F2933),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(local['materials_list']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF3498DB))),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: materialsDb.length,
                      itemBuilder: (context, index) {
                        var m = materialsDb[index];
                        String displayName = m.customName ?? (local[m.nameKey] ?? m.nameKey);
                        String limitText = m.maxKg > 0 ? '${m.maxKg} kg' : local['unlimited']!;
                        
                        return CheckboxListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20, color: Colors.amber),
                                onPressed: () => _editMaterialDialog(m, local),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                            ],
                          ),
                          subtitle: Text("${local['price']} ${m.price} | ${local['limit']} $limitText"),
                          value: m.use, activeColor: const Color(0xFF3498DB),
                          onChanged: (val) => setState(() => m.use = val!),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3498DB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => runCalculation(local),
                child: Text(local['calculate']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),

            if (errorMsg.isNotEmpty)
              Container(
                width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(errorMsg, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),

            if (optResult != null) ...[
              Card(
                color: const Color(0xFF111827),
                shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(local['results']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      const Divider(color: Colors.white24),
                      Text("🎯 Hedef Kütle: ${optResult!['targetMass']} kg", style: const TextStyle(fontSize: 15, color: Colors.white70)),
                      Text("${local['total_cost']!} ${optResult!['cost'].toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                      Text("${local['estimated_fe']!} %${optResult!['fe_percent'].toStringAsFixed(2)}", style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 15),
                      Text("📥 ${local['materials_list']!}:", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3498DB))),
                      const SizedBox(height: 5),
                      Table(
                        border: TableBorder.all(color: Colors.white12),
                        children: [
                          TableRow(children: [
                            Padding(padding: const EdgeInsets.all(6.0), child: Text(local['mat_name']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: const EdgeInsets.all(6.0), child: Text(local['amount']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                          ]),
                          
                          if (optResult!['isHalfFurnace'] && optResult!['halfMass'] > 0)
                            TableRow(children: [
                              Padding(padding: const EdgeInsets.all(6.0), child: Text(local['half_furnace']!, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                              Padding(padding: const EdgeInsets.all(6.0), child: Text("${optResult!['halfMass'].toStringAsFixed(2)} kg", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                            ]),

                          ...(optResult!['materials'] as List<MaterialItem>).where((m) => m.calculatedKg > 0).map((m) {
                            String displayName = m.customName ?? (local[m.nameKey] ?? m.nameKey);
                            return TableRow(children: [
                              Padding(padding: const EdgeInsets.all(6.0), child: Text(displayName)),
                              Padding(padding: const EdgeInsets.all(6.0), child: Text("${m.calculatedKg.toStringAsFixed(2)} kg", style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold))),
                            ]);
                          }).toList(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text("📊 ${local['chem_dist']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3498DB))),
                      const SizedBox(height: 5),
                      Table(
                        border: TableBorder.all(color: Colors.white12),
                        children: [
                          TableRow(children: [
                            Padding(padding: const EdgeInsets.all(6.0), child: Text(local['element']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: const EdgeInsets.all(6.0), child: Text(local['result_val']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                            Padding(padding: const EdgeInsets.all(6.0), child: Text(local['status']!, style: const TextStyle(fontWeight: FontWeight.bold))),
                          ]),
                          ...(optResult!['analysis'] as Map<String, double>).keys.map((el) {
                            double val = optResult!['analysis'][el]!;
                            return TableRow(children: [
                              Padding(padding: const EdgeInsets.all(6.0), child: Text(el, style: const TextStyle(fontWeight: FontWeight.bold))),
                              Padding(padding: const EdgeInsets.all(6.0), child: Text("%${val.toStringAsFixed(3)}")),
                              Padding(padding: const EdgeInsets.all(6.0), child: Text(local['ok']!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                            ]);
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}