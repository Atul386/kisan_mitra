// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'किसानमित्र 360';

  @override
  String get chooseLanguage => 'तुमची भाषा निवडा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get continueButton => 'पुढे जा';

  @override
  String get loginTitle => 'लॉगिन';

  @override
  String get loginHeading => 'तुमचा मोबाइल नंबर टाका';

  @override
  String get loginSubtitle => 'आम्ही तुम्हाला OTP पाठवू';

  @override
  String get phoneNumberLabel => 'मोबाइल नंबर';

  @override
  String get sendOtp => 'OTP मिळवा';

  @override
  String get otpTitle => 'OTP सत्यापित करा';

  @override
  String otpSubtitle(String phone) {
    return '$phone वर पाठवलेला कोड टाका';
  }

  @override
  String get verifyOtp => 'सत्यापित करा';

  @override
  String get continueAsGuest => 'पाहुणे म्हणून सुरू ठेवा';

  @override
  String get resendOtp => 'OTP पुन्हा पाठवा';

  @override
  String get profileSetupHeading => 'शेतकरी प्रोफाइल सेटअप';

  @override
  String get profileSetupTitle => 'तुमच्याबद्दल सांगा';

  @override
  String get nameLabel => 'तुमचे नाव';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get districtLabel => 'जिल्हा';

  @override
  String get preferredLanguageLabel => 'पसंतीची भाषा';

  @override
  String get saveAndContinue => 'जतन करा आणि पुढे जा';

  @override
  String get nextButton => 'पुढे';

  @override
  String get addFarmTitle => 'तुमचे शेत जोडा';

  @override
  String get farmNameLabel => 'शेताचे नाव';

  @override
  String get villageLabel => 'गाव';

  @override
  String get areaLabel => 'क्षेत्रफळ';

  @override
  String get areaUnitLabel => 'एकक';

  @override
  String get soilTypeLabel => 'मातीचा प्रकार';

  @override
  String get irrigationTypeLabel => 'सिंचन प्रकार';

  @override
  String get addCropTitle => 'पीक हंगाम जोडा';

  @override
  String get cropLabel => 'पीक';

  @override
  String get varietyLabel => 'जात (ऐच्छिक)';

  @override
  String get sowingDateLabel => 'पेरणीची तारीख';

  @override
  String get navHome => 'मुख्यपृष्ठ';

  @override
  String get navFarm => 'शेत';

  @override
  String get navMarket => 'बाजार';

  @override
  String get navAssistant => 'सहाय्यक';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get goodMorning => 'शुभ सकाळ';

  @override
  String get goodAfternoon => 'शुभ दुपार';

  @override
  String get goodEvening => 'शुभ संध्याकाळ';

  @override
  String dayNumber(int day) {
    return 'दिवस $day';
  }

  @override
  String get todaysTasks => 'आजची कामे';

  @override
  String get weather => 'हवामान';

  @override
  String get irrigation => 'सिंचन';

  @override
  String get cropHealth => 'पीक आरोग्य';

  @override
  String get myFarm => 'माझे शेत';

  @override
  String get expenses => 'खर्च';

  @override
  String get mandi => 'बाजारभाव';

  @override
  String get askKisanMitra => 'किसानमित्रला विचारा';

  @override
  String get dailyTip => 'आजचा सल्ला';

  @override
  String get addFarm => 'शेत जोडा';

  @override
  String get addExpense => 'खर्च जोडा';

  @override
  String get settingsTitle => 'सेटिंग्ज';

  @override
  String get languageSettingTitle => 'भाषा';

  @override
  String get aboutTitle => 'आमच्याबद्दल';

  @override
  String get privacyTitle => 'गोपनीयता';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get offlineBanner =>
      'तुम्ही ऑफलाइन आहात. जतन केलेली माहिती दाखवत आहे.';

  @override
  String get genericErrorMessage =>
      'सध्या अपडेट करता आले नाही. तुमचा डेटा सुरक्षितपणे जतन झाला आहे आणि इंटरनेट उपलब्ध झाल्यावर सिंक होईल.';

  @override
  String get comingSoon => 'लवकरच येत आहे';

  @override
  String get howIsYourCropToday => 'आज तुमचे पीक कसे आहे?';

  @override
  String get healthGood => 'चांगले';

  @override
  String get healthNeedsAttention => 'लक्ष देण्याची गरज';

  @override
  String get healthCritical => 'समस्या';

  @override
  String get done => 'पूर्ण';

  @override
  String get remindMe => 'मला आठवण करा';

  @override
  String get skip => 'वगळा';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String tasksPendingLabel(int count) {
    return '$count बाकी';
  }

  @override
  String get allTasksDoneMessage => 'आजचे शेतीचे काम पूर्ण झाले';

  @override
  String get noCropYetMessage => 'आजची योजना पाहण्यासाठी पीक जोडा';

  @override
  String get taskStatusDone => 'पूर्ण';

  @override
  String get taskStatusSkipped => 'वगळले';

  @override
  String get taskStatusSnoozed => 'उद्यासाठी आठवण दिली';

  @override
  String get amountLabel => 'रक्कम';

  @override
  String get categoryLabel => 'प्रकार';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get notesLabel => 'नोंदी (ऐच्छिक)';

  @override
  String get seasonExpenseLabel => 'हंगाम खर्च';

  @override
  String get noExpensesMessage => 'अजून कोणताही खर्च नोंदवलेला नाही';

  @override
  String get addReceiptPhoto => 'पावतीचा फोटो जोडा';

  @override
  String get expenseCategorySeeds => 'बियाणे';

  @override
  String get expenseCategoryFertilizer => 'खत';

  @override
  String get expenseCategoryPesticide => 'कीटकनाशक';

  @override
  String get expenseCategoryLabour => 'मजुरी';

  @override
  String get expenseCategoryTractor => 'ट्रॅक्टर';

  @override
  String get expenseCategoryDiesel => 'डिझेल';

  @override
  String get expenseCategoryIrrigation => 'सिंचन';

  @override
  String get expenseCategoryElectricity => 'वीज';

  @override
  String get expenseCategoryTransport => 'वाहतूक';

  @override
  String get expenseCategoryEquipment => 'उपकरणे';

  @override
  String get expenseCategoryOther => 'इतर';

  @override
  String get irrigationTitle => 'सिंचन';

  @override
  String get logIrrigation => 'सिंचन नोंदवा';

  @override
  String get durationMinutesLabel => 'कालावधी (मिनिटे)';

  @override
  String get methodLabel => 'पद्धत';

  @override
  String get noIrrigationMessage => 'अजून सिंचन नोंदवलेले नाही';

  @override
  String lastIrrigationLabel(int daysAgo) {
    String _temp0 = intl.Intl.pluralLogic(
      daysAgo,
      locale: localeName,
      other: '$daysAgo दिवसांपूर्वी',
      one: '1 दिवसापूर्वी',
      zero: 'आज',
    );
    return 'शेवटचे सिंचन: $_temp0';
  }

  @override
  String get fertilizerTitle => 'खत';

  @override
  String get logFertilizer => 'खत नोंदवा';

  @override
  String get productLabel => 'उत्पादन';

  @override
  String get quantityLabel => 'प्रमाण';

  @override
  String get unitLabel => 'एकक';

  @override
  String get costLabel => 'खर्च (ऐच्छिक)';

  @override
  String get noFertilizerMessage => 'अजून खत नोंदवलेले नाही';

  @override
  String get sprayTitle => 'फवारणी';

  @override
  String get logSpray => 'फवारणी नोंदवा';

  @override
  String get doseLabel => 'मात्रा';

  @override
  String get reasonLabel => 'कारण';

  @override
  String get noSprayMessage => 'अजून फवारणी नोंदवलेली नाही';

  @override
  String get weatherTitle => 'हवामान';

  @override
  String get rainProbabilityLabel => 'पावसाची शक्यता';

  @override
  String get humidityLabel => 'आर्द्रता';

  @override
  String get windLabel => 'वारा';

  @override
  String lastUpdatedLabel(String time) {
    return 'शेवटचे अद्ययावत: $time';
  }

  @override
  String get weatherUnavailableMessage => 'सध्या हवामान माहिती उपलब्ध नाही.';

  @override
  String get addFarmLocationMessage =>
      'हवामान पाहण्यासाठी तुमच्या शेताचे ठिकाण जोडा';

  @override
  String get useCurrentLocation => 'सध्याचे ठिकाण वापरा';

  @override
  String get avoidSprayingAdvice => 'पावसाची शक्यता — आज फवारणी टाळा.';

  @override
  String get irrigationNotNeededAdvice => 'पावसाची शक्यता — सिंचनाची गरज नसेल.';

  @override
  String get checkDrainageAdvice =>
      'मुसळधार पावसाची शक्यता — शेताचा निचरा तपासा.';

  @override
  String get goodSprayingConditionsAdvice =>
      'पावसाची शक्यता नाही — आज फवारणी सुरक्षित आहे.';

  @override
  String get hotDayAdvice => 'उष्ण दिवस — गरज असल्यास थंड वेळेत सिंचन करा.';

  @override
  String get addMandiPrice => 'भाव जोडा';

  @override
  String get commodityLabel => 'शेतमाल';

  @override
  String get marketLabel => 'बाजार (ऐच्छिक)';

  @override
  String get priceLabel => 'भाव';

  @override
  String get noMandiPricesMessage =>
      'अजून कोणताही भाव नोंदवलेला नाही. कल पाहण्यासाठी बाजारात दिसलेले भाव जोडा.';

  @override
  String get mandiManualTrackingNote =>
      'थेट बाजार फीड अजून जोडलेली नाही — भाव स्वतः नोंदवा.';

  @override
  String previousPriceLabel(String price) {
    return 'मागील: ₹$price';
  }

  @override
  String get aiAssistantHint => 'तुमच्या शेताबद्दल प्रश्न विचारा';

  @override
  String get aiAssistantSend => 'पाठवा';

  @override
  String get aiNotConfiguredMessage =>
      'AI सहाय्यकाला सुरक्षितपणे उत्तर देण्यासाठी Firebase Cloud Function लागेल — ते सेटअप झाल्यावर जोडले जाईल. सध्या तुमचा प्रश्न जतन केला आहे.';

  @override
  String get checkInTitle => 'दैनिक तपासणी';

  @override
  String get checkInPromptGood => 'चांगले';

  @override
  String get checkInPromptAttention => 'लक्ष देण्याची गरज';

  @override
  String get checkInPromptProblem => 'समस्या';

  @override
  String get checkInWhatDidYouNotice => 'तुम्ही काय पाहिले?';

  @override
  String get concernPest => 'किडी';

  @override
  String get concernLeafChange => 'पानांमध्ये बदल';

  @override
  String get concernWaterStress => 'पाण्याचा ताण';

  @override
  String get concernDisease => 'रोग';

  @override
  String get concernOther => 'इतर';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get addNote => 'नोंद जोडा';

  @override
  String get checkInSavedMessage => 'तपासणी जतन झाली';

  @override
  String get alreadyCheckedInMessage => 'तुम्ही आज आधीच तपासणी केली आहे';

  @override
  String get changeCheckIn => 'बदला';

  @override
  String get syncStatusTitle => 'सिंक स्थिती';

  @override
  String syncPendingLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count नोंदी सिंक होणे बाकी आहे',
      one: '1 नोंद सिंक होणे बाकी आहे',
      zero: 'काहीही प्रलंबित नाही',
    );
    return '$_temp0';
  }

  @override
  String get syncNotConnectedMessage =>
      'तुमचा डेटा या डिव्हाइसवर सुरक्षितपणे जतन केला आहे. ऑनलाइन सिंक अजून जोडलेले नाही.';

  @override
  String get orDivider => 'किंवा';

  @override
  String get dashboardTagline => 'शेती करत रहा, वाढत रहा!';

  @override
  String get rainAlertTitle => 'पावसाचा इशारा';

  @override
  String get activeCropLabel => 'सध्याचे पीक';

  @override
  String tasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कामे',
      one: '1 काम',
    );
    return '$_temp0';
  }

  @override
  String get irrigationNormalStatus => 'सामान्य';

  @override
  String get irrigationDueStatus => 'बाकी';

  @override
  String get noDataDash => '—';

  @override
  String get countryLabel => 'देश';

  @override
  String get invalidPhoneNumberMessage => 'योग्य 10 अंकी मोबाइल नंबर टाका';

  @override
  String get weatherConditionClear => 'निरभ्र';

  @override
  String get weatherConditionCloudy => 'ढगाळ';

  @override
  String get weatherConditionFog => 'धुके';

  @override
  String get weatherConditionRain => 'पाऊस';

  @override
  String get weatherConditionStorm => 'वादळ';

  @override
  String get weatherConditionSnow => 'बर्फ';

  @override
  String get liveMandiPricesTitle => 'लाइव्ह मंडी भाव';

  @override
  String get liveMandiSourceLabel => 'स्रोत: अ‍ॅगमार्कनेट (data.gov.in)';

  @override
  String modalPriceLabel(String price) {
    return 'मॉडल भाव: ₹$price';
  }

  @override
  String get yourTrackedPricesLabel => 'तुम्ही नोंदवलेले भाव';

  @override
  String get perQuintalLabel => 'प्रति क्विंटल';

  @override
  String get lastIrrigationTitle => 'शेवटचे सिंचन';

  @override
  String get suggestedNextIrrigationTitle => 'पुढील सुचवलेले सिंचन';

  @override
  String get irrigationHistoryNeededMessage =>
      'सुचवलेले वेळापत्रक पाहण्यासाठी आणखी काही सिंचन नोंदवा';

  @override
  String get irrigationHistoryTitle => 'सिंचन इतिहास';

  @override
  String daysAgoLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिवसांपूर्वी',
      one: '1 दिवसापूर्वी',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String inDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिवसांत',
      one: 'उद्या',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String get minutesUnitLabel => 'मिनिटे';

  @override
  String get checkInNoteHint => 'तुमची नोंद टाका...';

  @override
  String get totalCropExpenseLabel => 'एकूण पीक खर्च';

  @override
  String get thisMonthLabel => 'या महिन्यात';

  @override
  String get thisSeasonLabel => 'या हंगामात';

  @override
  String get recentExpensesLabel => 'अलीकडील खर्च';
}
