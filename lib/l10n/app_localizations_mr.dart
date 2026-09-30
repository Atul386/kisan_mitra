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
  String get dashboardTagline => 'तुमची शेती, तुमचा साथी';

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

  @override
  String get seasonLabel => 'हंगाम';

  @override
  String get seasonKharif => 'खरीप';

  @override
  String get seasonRabi => 'रब्बी';

  @override
  String get seasonZaid => 'उन्हाळी';

  @override
  String get farmLocationLabel => 'शेताचे ठिकाण';

  @override
  String get mapTapToMovePin =>
      'पिन तुमच्या शेतावर हलवण्यासाठी नकाशावर टॅप करा';

  @override
  String get mandiAllTab => 'सर्व';

  @override
  String get mandiFavouritesTab => 'आवडते';

  @override
  String get noFavouritesMessage =>
      'पिकाला आवडत्यांमध्ये जोडण्यासाठी तारा चिन्हावर टॅप करा.';

  @override
  String get addToFavourite => 'आवडत्यांमध्ये जोडा';

  @override
  String get removeFromFavourite => 'आवडत्यांमधून काढा';

  @override
  String get setPriceAlert => 'भाव सूचना सेट करा';

  @override
  String priceAlertDialogTitle(String commodity) {
    return '$commodity साठी भाव सूचना';
  }

  @override
  String get priceAlertTargetLabel => 'भाव इथे पोहोचल्यावर कळवा (₹)';

  @override
  String get priceAlertHelp =>
      'तुम्ही नोंदवलेला किंवा लाइव्ह मंडी भाव या रकमेपर्यंत पोहोचल्यावर तुम्हाला सूचना मिळेल.';

  @override
  String get removeAlert => 'सूचना काढा';

  @override
  String priceAlertActiveLabel(String price) {
    return '₹$price वर सूचना';
  }

  @override
  String priceAlertNotificationTitle(String commodity) {
    return '$commodity भाव सूचना';
  }

  @override
  String priceAlertNotificationBody(String commodity, String price) {
    return '$commodity ₹$price वर पोहोचला — तुमचा लक्ष्य भाव.';
  }

  @override
  String get suggestedQuestionsLabel => 'सुचवलेले प्रश्न';

  @override
  String get suggestedQuestionPest => 'माझ्या पिकावर कोणती कीड पडली आहे?';

  @override
  String get suggestedQuestionFertilizer => 'आता कोणते खत वापरावे?';

  @override
  String get suggestedQuestionIrrigation => 'पुढचे पाणी कधी द्यावे?';

  @override
  String get suggestedQuestionWeather => 'आजचे हवामान फवारणीसाठी योग्य आहे का?';

  @override
  String get voiceInputTooltip => 'तुमचा प्रश्न बोला';

  @override
  String get voiceListeningLabel => 'ऐकत आहे…';

  @override
  String get voiceUnavailableMessage =>
      'या फोनवर आवाज इनपुट उपलब्ध नाही. कृपया प्रश्न टाइप करा.';

  @override
  String get darkModeLabel => 'डार्क मोड';

  @override
  String get dailyReminderLabel => 'रोजच्या शेती नियोजनाची आठवण';

  @override
  String get dailyReminderSubtitle => 'दररोज सकाळी 8 वाजता';

  @override
  String get helpSupportTitle => 'मदत आणि सहाय्य';

  @override
  String get helpIntro => 'नेहमीच्या प्रश्नांची झटपट उत्तरे.';

  @override
  String get helpFaqOfflineQ => 'अ‍ॅप इंटरनेटशिवाय चालते का?';

  @override
  String get helpFaqOfflineA =>
      'हो. कामे, खर्च, नोंदी आणि चेक-इन तुमच्या फोनवर जतन होतात. हवामान, लाइव्ह मंडी भाव आणि सहाय्यकासाठी इंटरनेट लागते.';

  @override
  String get helpFaqTasksQ => 'आजची कामे कुठून येतात?';

  @override
  String get helpFaqTasksA =>
      'ती तुमच्या पिकावरून आणि पेरणीच्या तारखेवरून तयार होतात. प्रत्येक काम पूर्ण, वगळा किंवा आठवण करा म्हणून निवडा.';

  @override
  String get helpFaqLanguageQ => 'भाषा कशी बदलायची?';

  @override
  String get helpFaqLanguageA =>
      'प्रोफाइल → भाषा मध्ये जाऊन English, हिंदी किंवा मराठी निवडा.';

  @override
  String get helpFaqDataQ => 'माझा शेतीचा डेटा सुरक्षित आहे का?';

  @override
  String get helpFaqDataA =>
      'तुमचा डेटा तुमच्या फोनवरच राहतो. प्रोफाइल → अ‍ॅप डेटा रीसेट करा मधून तुम्ही तो कधीही काढू शकता.';

  @override
  String get deleteAccountTitle => 'खाते हटवा';

  @override
  String get deleteAccountConfirmMessage =>
      'यामुळे तुमचे प्रोफाइल, शेते, पिके, कामे, खर्च आणि सर्व नोंदी या फोनवरून कायमच्या हटवल्या जातील. हे परत आणता येणार नाही.';

  @override
  String get deleteButton => 'हटवा';

  @override
  String get resetAppDataTitle => 'अ‍ॅप डेटा रीसेट करा';

  @override
  String get resetAppDataMessage =>
      'यामुळे तुमचे प्रोफाइल, शेते, पिके, कामे, खर्च आणि सर्व नोंदी या फोनवरून कायमच्या हटवल्या जातील आणि अ‍ॅप नव्याने सुरू होईल. हे परत आणता येणार नाही.';

  @override
  String get sevenDayForecastTitle => '7 दिवसांचा अंदाज';

  @override
  String get forecastTodayLabel => 'आज';

  @override
  String get requiredFieldError => 'कृपया हे भरा';

  @override
  String get invalidAreaError => 'क्षेत्र आकड्यात लिहा, उदा. 2.5';

  @override
  String get hourlyForecastTitle => 'पुढील २४ तास';

  @override
  String feelsLikeLabel(String temp) {
    return 'जाणवते $temp°';
  }

  @override
  String get weatherDetailsTitle => 'तपशील';

  @override
  String get uvIndexLabel => 'यूव्ही निर्देशांक';

  @override
  String get sunriseLabel => 'सूर्योदय';

  @override
  String get sunsetLabel => 'सूर्यास्त';

  @override
  String get farmAdviceTitle => 'शेतीचा सल्ला';

  @override
  String get weatherDemoBadge => 'डेमो डेटा';

  @override
  String get weatherNoAdvice => 'आज विशेष काळजीची गरज नाही — सामान्य दिवस.';

  @override
  String highLowLabel(String high, String low) {
    return 'कमाल $high°  किमान $low°';
  }

  @override
  String get quickActionsTitle => 'जलद कृती';

  @override
  String get qaSpray => 'फवारणी नोंदवा';

  @override
  String get qaExpense => 'खर्च जोडा';

  @override
  String get qaFertilizer => 'खत';

  @override
  String get qaIrrigation => 'सिंचन';

  @override
  String get qaCropCheck => 'पीक तपासणी';

  @override
  String get farmSummaryTitle => 'तुमची शेती एका नजरेत';

  @override
  String get summaryArea => 'क्षेत्र';

  @override
  String get summaryExpenses => 'खर्च';

  @override
  String summaryCropDay(int day, int total) {
    return 'सुमारे $total पैकी दिवस $day';
  }

  @override
  String get summaryNoCrop => 'प्रगती पाहण्यासाठी पीक जोडा';

  @override
  String get summaryNotSet => 'ठरवलेले नाही';

  @override
  String get mandiTickerTitle => 'आजचे बाजारभाव';

  @override
  String get mandiSampleCaption => 'नमुना भाव';

  @override
  String get mandiPerQuintal => 'प्रति क्विंटल';

  @override
  String get schemesTitle => 'शेतकऱ्यांसाठी योजना';

  @override
  String get schemesSampleCaption => 'नमुना माहिती';

  @override
  String get schemePmKisanTitle => 'पीएम-किसान';

  @override
  String get schemePmKisanDesc =>
      'वर्षाला ₹६,०००, तीन हप्त्यांत थेट तुमच्या बँक खात्यात.';

  @override
  String get schemePmfbyTitle => 'पीक विमा (पीएमएफबीवाय)';

  @override
  String get schemePmfbyDesc =>
      'कमी हप्त्यात दुष्काळ, पूर आणि किडींपासून पिकाचा विमा.';

  @override
  String get schemeKccTitle => 'किसान क्रेडिट कार्ड';

  @override
  String get schemeKccDesc =>
      'बियाणे, खत आणि अवजारांसाठी कमी व्याजाचे शेती कर्ज.';

  @override
  String get dailyTipTitle => 'आजचा सल्ला';

  @override
  String get dailyTipBody =>
      'सकाळी लवकर पाणी द्या. उन्हामुळे कमी पाणी वाया जाते आणि पाने रात्रीपूर्वी कोरडी होतात, त्यामुळे रोग कमी होतात.';

  @override
  String get navAdvisories => 'Advisories';

  @override
  String get navMore => 'More';

  @override
  String get advisoriesTitle => 'Advisories';

  @override
  String get advWeather => 'Weather';

  @override
  String get advWeatherDesc => 'Forecast and farm advice';

  @override
  String get advCropAdvisories => 'Crop advisories';

  @override
  String get advCropAdvisoriesDesc => 'Crop guide and official advisories';

  @override
  String get advSchemes => 'Government schemes';

  @override
  String get advSchemesDesc => 'Schemes that may help your farm';

  @override
  String get advInsurance => 'Crop insurance';

  @override
  String get advInsuranceDesc => 'PMFBY information and official services';

  @override
  String get advPmKisan => 'PM-KISAN';

  @override
  String get advPmKisanDesc => 'Registration, e-KYC and payment status';

  @override
  String get officialDisclaimer =>
      'This information is for guidance only. Final eligibility and decisions are made by the official government portal or department.';

  @override
  String get openOfficialWebsite => 'Open official website';

  @override
  String get couldNotOpenLink => 'Couldn\'t open the link. Please try again.';

  @override
  String get callHelpline => 'Call';

  @override
  String get schemesScreenTitle => 'Government schemes';

  @override
  String get schemeOverview => 'Overview';

  @override
  String get schemeEligibility => 'Who may be eligible';

  @override
  String get schemeBenefits => 'Benefits';

  @override
  String get schemeDocuments => 'Documents usually needed';

  @override
  String get schemeDates => 'Important dates';

  @override
  String get schemeDatesNote =>
      'Dates change every season. Check the official website for current dates.';

  @override
  String get schemeApply => 'Apply on the official portal';

  @override
  String get pmKisanScreenTitle => 'PM-KISAN';

  @override
  String get pmKisanAadhaarNote =>
      'You never need to enter your Aadhaar in this app. Use the official PM-KISAN website for registration, e-KYC and status.';

  @override
  String get officialServicesTitle => 'Official services';

  @override
  String get insuranceScreenTitle => 'Crop insurance (PMFBY)';

  @override
  String get insuranceReportNote =>
      'Report crop loss within the time limit set by the scheme. Use the official helpline or portal.';

  @override
  String get cropLibraryTitle => 'Crop library';

  @override
  String get cropLibrarySearchHint => 'Search crops';

  @override
  String get cropLibraryEmpty =>
      'No crops match your search.\nTry another name.';

  @override
  String get cropLibraryLoadError =>
      'Couldn\'t load crop information.\nPlease try again.';

  @override
  String get cropOverview => 'Overview';

  @override
  String get cropSowing => 'Sowing period';

  @override
  String get cropSoil => 'Soil';

  @override
  String get cropClimate => 'Climate';

  @override
  String get cropIrrigation => 'Irrigation';

  @override
  String get cropNutrients => 'Nutrients';

  @override
  String get cropPests => 'Common pests';

  @override
  String get cropDiseases => 'Common diseases';

  @override
  String get cropHarvest => 'Harvest';

  @override
  String get cropStorage => 'Storage';

  @override
  String get cropGeneralNote =>
      'General guidance only. Check with your local Krishi Vigyan Kendra or agriculture department before acting on pests, diseases or nutrients.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get profitTitle => 'Profit calculator';

  @override
  String get estimateOnly => 'ESTIMATE ONLY';

  @override
  String get estimateDisclaimer =>
      'This is a rough estimate from the numbers you enter. Real income depends on yield, market price and costs, and is not guaranteed.';

  @override
  String get profitCrop => 'Crop (optional)';

  @override
  String get profitArea => 'Area (acres)';

  @override
  String get profitYield => 'Expected yield per acre (quintal)';

  @override
  String get profitPrice => 'Expected price (₹ per quintal)';

  @override
  String get costSeed => 'Seed cost (₹)';

  @override
  String get costFertilizer => 'Fertilizer cost (₹)';

  @override
  String get costLabour => 'Labour cost (₹)';

  @override
  String get costIrrigation => 'Irrigation cost (₹)';

  @override
  String get costTransport => 'Transport cost (₹)';

  @override
  String get costOther => 'Other costs (₹)';

  @override
  String get profitRevenue => 'Estimated revenue';

  @override
  String get profitCost => 'Estimated cost';

  @override
  String get profitMargin => 'Estimated margin';

  @override
  String get profitLossLabel => 'Estimated loss';

  @override
  String get profitCalculate => 'Calculate estimate';

  @override
  String get profitReset => 'Clear';

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String profitUseSavedPrice(String price) {
    return 'Use my latest saved price: ₹$price';
  }

  @override
  String get nearbyTitle => 'Nearby agriculture services';

  @override
  String get nearbyIntro => 'Opens your maps app and searches near your farm.';

  @override
  String get nearbyNearFarm => 'Searching near your farm location';

  @override
  String get nearbyNearArea => 'Searching near your area';

  @override
  String get nearbyApmc => 'APMC / mandi';

  @override
  String get nearbySoilLab => 'Soil testing lab';

  @override
  String get nearbyAgriOffice => 'Agriculture office';

  @override
  String get nearbySeedDealer => 'Seed dealer';

  @override
  String get nearbyFertilizerDealer => 'Fertilizer dealer';

  @override
  String get nearbyEquipmentRental => 'Equipment rental';

  @override
  String get nearbyTractorRental => 'Tractor rental';

  @override
  String get nearbyVet => 'Veterinary hospital';

  @override
  String get nearbyCsc => 'CSC centre';

  @override
  String get nearbyBank => 'Bank';

  @override
  String get nearbyGovOffice => 'Government office';

  @override
  String get moreTitle => 'More';

  @override
  String get moreCropLibrary => 'Crop library';

  @override
  String get moreProfit => 'Profit calculator';

  @override
  String get moreNearby => 'Nearby services';

  @override
  String get moreExpenses => 'Expenses';

  @override
  String get moreSettings => 'Settings';

  @override
  String get moreHelp => 'Help & support';

  @override
  String get moreAbout => 'About';

  @override
  String get mandiLiveTitle => 'Government mandi prices';

  @override
  String mandiReportedOn(String date) {
    return 'Reported $date';
  }

  @override
  String get mandiMin => 'Minimum';

  @override
  String get mandiModal => 'Modal';

  @override
  String get mandiMax => 'Maximum';

  @override
  String get mandiFilterCrop => 'Crop';

  @override
  String get mandiFilterDistrict => 'District';

  @override
  String get mandiFilterMarket => 'Market';

  @override
  String get mandiFilterVariety => 'Variety';

  @override
  String get mandiFilterAll => 'All';

  @override
  String get mandiSearchHint => 'Search market or variety';

  @override
  String get mandiNoPrices =>
      'No mandi prices found.\nTry another market or crop.';

  @override
  String get mandiLoadError =>
      'Unable to load prices.\nCheck your internet connection and try again.';

  @override
  String get mandiOfflineBanner =>
      'You\'re offline.\nShowing your last saved data.';

  @override
  String mandiSavedOn(String time) {
    return 'Saved $time';
  }

  @override
  String get mandiRateLimited =>
      'Too many requests right now. Please try again in a few minutes.';

  @override
  String get mandiUnsupportedState =>
      'Live prices aren\'t available for your state yet. You can still log prices yourself.';

  @override
  String get mandiDataNote =>
      'Prices are reported daily by markets and can be a few days old. They are not real-time auction prices.';

  @override
  String get mandiSeeAll => 'See all prices';

  @override
  String get mandiShowMore => 'Show more';

  @override
  String get mandiHistoryTitle => 'Price history';

  @override
  String get mandiHistoryToday => 'Today';

  @override
  String get mandiHistory7 => '7 days';

  @override
  String get mandiHistory30 => '30 days';

  @override
  String get mandiHistoryUnavailable =>
      'Price history isn\'t available for this crop and market yet.';

  @override
  String get mandiAllMarkets => 'All markets';

  @override
  String mandiHistoryStateAverage(String state) {
    return 'Average across $state';
  }

  @override
  String get mandiLatestReported => 'Latest reported price';

  @override
  String get mandiReportedCaption => 'Reported prices';

  @override
  String get cropsTitle => 'My crops';

  @override
  String get cropStatusActive => 'Active';

  @override
  String get cropStatusHarvested => 'Harvested';

  @override
  String get cropStatusCompleted => 'Completed';

  @override
  String get cropDetailTitle => 'Crop details';

  @override
  String get expectedHarvestLabel => 'Expected harvest date';

  @override
  String get cropStatusLabel => 'Status';

  @override
  String get editDetails => 'Edit details';

  @override
  String get editLabel => 'Edit';

  @override
  String get markHarvested => 'Mark as harvested';

  @override
  String get markCompleted => 'Mark as completed';

  @override
  String get markActive => 'Mark as active';

  @override
  String get deleteCrop => 'Delete crop';

  @override
  String get deleteCropConfirm =>
      'Delete this crop and stop tracking it? Its diary entries will no longer be shown.';

  @override
  String get cropDetailCosts => 'Expenses for this crop';

  @override
  String get cropDetailNoNotes => 'No notes yet';

  @override
  String get cropDiaryTitle => 'Crop diary';

  @override
  String get openCropDiary => 'Crop diary';

  @override
  String get diaryEmpty =>
      'No activities yet.\nTap + to record what you did today.';

  @override
  String get addActivity => 'Add activity';

  @override
  String get editActivity => 'Edit activity';

  @override
  String get activitySowing => 'Sowing';

  @override
  String get activityIrrigation => 'Irrigation';

  @override
  String get activityFertilizer => 'Fertilizer';

  @override
  String get activitySpray => 'Spray';

  @override
  String get activityPestObservation => 'Pest observation';

  @override
  String get activityDiseaseObservation => 'Disease observation';

  @override
  String get activityLabour => 'Labour';

  @override
  String get activityHarvest => 'Harvest';

  @override
  String get activitySale => 'Sale';

  @override
  String get activityOther => 'Other';

  @override
  String get activityTypeLabel => 'What happened?';

  @override
  String get activityDateLabel => 'Date';

  @override
  String get activityNotesHint => 'Notes (optional)';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get deleteActivityConfirm => 'Delete this diary entry?';

  @override
  String get noCropsYet =>
      'No crops yet. Add your first crop to start a diary.';

  @override
  String activitiesCount(int count) {
    return '$count activities';
  }

  @override
  String get galleryLabel => 'Gallery';

  @override
  String get editFarmTitle => 'Edit farm';

  @override
  String get waterSourceLabel => 'Water source (optional)';

  @override
  String get farmDetailsTitle => 'Farm details';

  @override
  String get deleteFarm => 'Delete farm';

  @override
  String get deleteFarmConfirm =>
      'Delete this farm? Its crops and records will no longer be shown.';

  @override
  String get useThisFarm => 'Use this farm';

  @override
  String get activeFarmBadge => 'Active farm';

  @override
  String get farmCropsTitle => 'Crops';

  @override
  String get farmToolsTitle => 'Farm tools';

  @override
  String get toolDiary => 'Crop diary';

  @override
  String get toolExpenses => 'Expenses';

  @override
  String get toolProfit => 'Profit calculator';

  @override
  String get toolDocuments => 'Documents';

  @override
  String get toolSoil => 'Soil health';

  @override
  String get toolReminders => 'Reminders';

  @override
  String get noFarmsYet => 'Add your first farm to get started.';

  @override
  String farmAreaLine(String area, String unit) {
    return '$area $unit';
  }

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get reminderNew => 'New reminder';

  @override
  String get reminderEdit => 'Edit reminder';

  @override
  String get remindersEmpty => 'No reminders yet.\nTap + to add one.';

  @override
  String get remindersUpcoming => 'Upcoming';

  @override
  String get remindersCompleted => 'Completed';

  @override
  String get reminderTitleLabel => 'What do you need to do?';

  @override
  String get reminderCategoryLabel => 'Category';

  @override
  String get reminderDateLabel => 'Date';

  @override
  String get reminderTimeLabel => 'Time';

  @override
  String get reminderRepeatLabel => 'Repeat';

  @override
  String get repeatNone => 'Does not repeat';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekly => 'Every week';

  @override
  String get repeatMonthly => 'Every month';

  @override
  String get reminderCatIrrigation => 'Irrigation';

  @override
  String get reminderCatFertilizer => 'Fertilizer';

  @override
  String get reminderCatSpray => 'Spray';

  @override
  String get reminderCatInspection => 'Crop inspection';

  @override
  String get reminderCatHarvest => 'Harvest';

  @override
  String get reminderCatLabour => 'Labour';

  @override
  String get reminderCatEquipment => 'Equipment maintenance';

  @override
  String get reminderCatGovernmentDeadline => 'Government deadline';

  @override
  String get reminderCatInsuranceDeadline => 'Insurance deadline';

  @override
  String get reminderCatCustom => 'Custom';

  @override
  String get reminderDeleteConfirm => 'Delete this reminder?';

  @override
  String get reminderPastTime => 'Pick a time in the future';

  @override
  String get reminderMarkDone => 'Mark done';

  @override
  String get reminderMarkNotDone => 'Mark not done';

  @override
  String reminderRepeatsEvery(String rule) {
    return 'Repeats: $rule';
  }

  @override
  String get todayRemindersTitle => 'Today\'s reminders';

  @override
  String get documentsTitle => 'My documents';

  @override
  String get docCat712 => '7/12 Extract';

  @override
  String get docCat8a => '8A Extract';

  @override
  String get docCatSoil => 'Soil Health Card';

  @override
  String get docCatInsurance => 'Crop Insurance';

  @override
  String get docCatBank => 'Bank Documents';

  @override
  String get docCatPmKisan => 'PM-KISAN';

  @override
  String get docCatMahadbt => 'MahaDBT';

  @override
  String get docCatOther => 'Other';

  @override
  String get documentsEmpty =>
      'No documents yet.\nKeep your 7/12, 8A and insurance papers here.';

  @override
  String get addDocument => 'Add document';

  @override
  String get documentTitleLabel => 'Title';

  @override
  String get chooseFile => 'Choose PDF or photo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get noFileChosen => 'No file chosen';

  @override
  String get docUnsupported => 'Only PDF, JPG and PNG files are allowed.';

  @override
  String get docTooLarge =>
      'This file is larger than 10 MB. Please choose a smaller one.';

  @override
  String get docEmptyFile => 'This file is empty.';

  @override
  String get docSavedOnPhone => 'Saved on this phone';

  @override
  String get docBackedUp => 'Backed up';

  @override
  String get docDeleteConfirm => 'Delete this document from your phone?';

  @override
  String get docOpenFailed => 'Couldn\'t open this file.';

  @override
  String get docPrivacyNote =>
      'Your documents are kept privately on this phone.';

  @override
  String get soilTitle => 'Soil health';

  @override
  String get soilEmpty =>
      'No soil tests yet.\nAdd values from your lab report or Soil Health Card.';

  @override
  String get soilAdd => 'Add soil test';

  @override
  String get soilPh => 'pH';

  @override
  String get soilNitrogen => 'Nitrogen, N (kg/ha)';

  @override
  String get soilPhosphorus => 'Phosphorus, P (kg/ha)';

  @override
  String get soilPotassium => 'Potassium, K (kg/ha)';

  @override
  String get soilOrganicCarbon => 'Organic carbon (%)';

  @override
  String get soilOther => 'Other nutrients (optional)';

  @override
  String get soilOtherHint => 'e.g. Zinc 0.6 ppm, Sulphur 12 ppm';

  @override
  String get soilDate => 'Test date';

  @override
  String get soilAttachCard => 'Attach Soil Health Card';

  @override
  String get soilCardAttached => 'Card attached';

  @override
  String get soilViewCard => 'View card';

  @override
  String get soilAdviceNote =>
      'These are the values you entered. Ask your local Krishi Vigyan Kendra or agriculture officer what they mean for fertilizer. This app does not prescribe fertilizer amounts.';

  @override
  String soilValueRange(String min, String max) {
    return 'Enter a value between $min and $max';
  }

  @override
  String get soilNeedOneValue => 'Enter at least one value';

  @override
  String get soilDeleteConfirm => 'Delete this soil test?';

  @override
  String get docBackUp => 'Back up to cloud';

  @override
  String get docBackupFailed =>
      'Couldn\'t back up this document. Check your internet connection and try again.';

  @override
  String get pushSectionTitle => 'Push notifications';

  @override
  String get pushWeather => 'Weather alerts';

  @override
  String get pushMandi => 'Mandi price alerts';

  @override
  String get pushGovt => 'Government updates';

  @override
  String get pushNote => 'Only important alerts. Turn off any you don\'t want.';

  @override
  String get nearbyMandisTitle => 'Mandis near you';

  @override
  String nearbyMandisInDistrict(String district) {
    return 'In $district';
  }

  @override
  String get nearbyMandisOtherDistricts => 'Other districts';

  @override
  String get nearbyMandisPickDistrict => 'Choose your district';

  @override
  String get nearbyMandisNote =>
      'Markets are grouped by district. Distances aren\'t shown because the price data has no map locations.';

  @override
  String nearbyMandisNoneInDistrict(String district) {
    return 'No mandis listed in $district. See other districts below.';
  }

  @override
  String get nearbyMandisDirections => 'Directions';

  @override
  String get nearbyMandisPrices => 'Prices';

  @override
  String get nearbyMandisDistrictLabel => 'District';

  @override
  String get talukaLabel => 'Taluka (optional)';

  @override
  String get rainfallLabel => 'Rainfall today';

  @override
  String get showSixteenDays => 'Show 16 days';

  @override
  String get showFewerDays => 'Show fewer days';

  @override
  String get sixteenDayForecastTitle => '16-Day Forecast';

  @override
  String get schemesSearchHint => 'Search schemes';

  @override
  String get schemesNoMatch =>
      'No schemes match your search.\nTry another word.';

  @override
  String get soilFindLabs => 'Find nearby soil testing labs';

  @override
  String get reminderCropLabel => 'Crop (optional)';

  @override
  String get reminderNoCrop => 'No specific crop';

  @override
  String get reminderNotifyLabel => 'Send me a notification';

  @override
  String get reminderNotifyOff => 'Notification off';

  @override
  String get activityCostLabel => 'Cost (₹, optional)';
}
