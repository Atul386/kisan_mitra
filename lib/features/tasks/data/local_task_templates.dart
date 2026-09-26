import '../domain/task_template.dart';

/// Deterministic, rule-based task calendar (blueprint §47: use rules for
/// scheduling, save AI for explanation/Q&A). Generic templates apply to
/// every crop; crop-specific templates override/add to them for the same
/// day range. Replace with a `master_tasks` Firestore repository later
/// without touching [TaskRuleEngine] or the UI.
const List<TaskTemplate> kLocalTaskTemplates = [
  // Generic templates — apply regardless of crop.
  TaskTemplate(
    id: 'generic_germination',
    dayFrom: 1,
    dayTo: 7,
    title: {
      'en': 'Check germination and soil moisture',
      'hi': 'अंकुरण और मिट्टी की नमी की जांच करें',
      'mr': 'उगवण आणि मातीतील ओलावा तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_early_pest',
    dayFrom: 8,
    dayTo: 19,
    title: {
      'en': 'Inspect crop for early pest damage',
      'hi': 'फसल में शुरुआती कीट क्षति की जांच करें',
      'mr': 'पिकावर किडींचे सुरुवातीचे नुकसान तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_leaf_inspection',
    dayFrom: 20,
    dayTo: 35,
    title: {
      'en': 'Inspect leaves for pest damage',
      'hi': 'पत्तियों पर कीट के नुकसान की जांच करें',
      'mr': 'पानांवरील किडींचे नुकसान तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_fertilizer_check',
    dayFrom: 30,
    dayTo: 45,
    title: {
      'en': 'Check if fertilizer application is due',
      'hi': 'जांचें कि उर्वरक देना बाकी है या नहीं',
      'mr': 'खत देण्याची वेळ झाली आहे का ते तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_irrigation_watch',
    dayFrom: 20,
    dayTo: 80,
    title: {
      'en': 'Check soil moisture before irrigating',
      'hi': 'सिंचाई से पहले मिट्टी की नमी जांचें',
      'mr': 'सिंचनापूर्वी मातीतील ओलावा तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_disease_watch',
    dayFrom: 45,
    dayTo: 90,
    title: {
      'en': 'Check for signs of disease or drainage issues',
      'hi': 'रोग या जल निकासी की समस्या के लक्षण देखें',
      'mr': 'रोग किंवा पाणी साचण्याची लक्षणे तपासा',
    },
  ),
  TaskTemplate(
    id: 'generic_harvest_planning',
    dayFrom: 90,
    dayTo: 130,
    title: {
      'en': 'Start harvest planning',
      'hi': 'कटाई की योजना शुरू करें',
      'mr': 'काढणीचे नियोजन सुरू करा',
    },
  ),

  // Crop-specific example from blueprint §46.
  TaskTemplate(
    id: 'soybean_vegetative_leaf_pest',
    cropId: 'soybean',
    dayFrom: 20,
    dayTo: 35,
    title: {
      'en': 'Inspect leaves for pest damage',
      'hi': 'पत्तियों पर कीट के नुकसान की जांच करें',
      'mr': 'पानांवरील किडींचे नुकसान तपासा',
    },
  ),
];
