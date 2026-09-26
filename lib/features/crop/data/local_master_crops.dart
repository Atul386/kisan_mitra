import '../domain/master_crop.dart';

/// Initial crop list from blueprint §15. Replace this data source with a
/// `master_crops` Firestore repository once the Firebase project exists;
/// nothing else in the app needs to change (§35, §49).
const List<MasterCrop> kLocalMasterCrops = [
  MasterCrop(id: 'rice', names: {'en': 'Rice', 'hi': 'चावल', 'mr': 'भात'}),
  MasterCrop(id: 'wheat', names: {'en': 'Wheat', 'hi': 'गेहूं', 'mr': 'गहू'}),
  MasterCrop(id: 'soybean', names: {'en': 'Soybean', 'hi': 'सोयाबीन', 'mr': 'सोयाबीन'}),
  MasterCrop(id: 'cotton', names: {'en': 'Cotton', 'hi': 'कपास', 'mr': 'कापूस'}),
  MasterCrop(id: 'sugarcane', names: {'en': 'Sugarcane', 'hi': 'गन्ना', 'mr': 'ऊस'}),
  MasterCrop(id: 'maize', names: {'en': 'Maize', 'hi': 'मक्का', 'mr': 'मका'}),
  MasterCrop(id: 'groundnut', names: {'en': 'Groundnut', 'hi': 'मूंगफली', 'mr': 'भुईमूग'}),
  MasterCrop(id: 'onion', names: {'en': 'Onion', 'hi': 'प्याज', 'mr': 'कांदा'}),
  MasterCrop(id: 'potato', names: {'en': 'Potato', 'hi': 'आलू', 'mr': 'बटाटा'}),
  MasterCrop(id: 'tomato', names: {'en': 'Tomato', 'hi': 'टमाटर', 'mr': 'टोमॅटो'}),
  MasterCrop(id: 'tur', names: {'en': 'Tur / Pigeon Pea', 'hi': 'अरहर', 'mr': 'तूर'}),
  MasterCrop(id: 'gram', names: {'en': 'Gram / Chickpea', 'hi': 'चना', 'mr': 'हरभरा'}),
];
