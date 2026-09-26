// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'किसानमित्र 360';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get loginTitle => 'लॉगिन';

  @override
  String get loginHeading => 'अपना मोबाइल नंबर दर्ज करें';

  @override
  String get loginSubtitle => 'हम आपको एक OTP भेजेंगे';

  @override
  String get phoneNumberLabel => 'मोबाइल नंबर';

  @override
  String get sendOtp => 'OTP प्राप्त करें';

  @override
  String get otpTitle => 'OTP सत्यापित करें';

  @override
  String otpSubtitle(String phone) {
    return '$phone पर भेजा गया कोड दर्ज करें';
  }

  @override
  String get verifyOtp => 'सत्यापित करें';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get resendOtp => 'OTP फिर से भेजें';

  @override
  String get profileSetupHeading => 'किसान प्रोफ़ाइल सेटअप';

  @override
  String get profileSetupTitle => 'अपने बारे में बताएं';

  @override
  String get nameLabel => 'आपका नाम';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get districtLabel => 'जिला';

  @override
  String get preferredLanguageLabel => 'पसंदीदा भाषा';

  @override
  String get saveAndContinue => 'सहेजें और जारी रखें';

  @override
  String get nextButton => 'आगे';

  @override
  String get addFarmTitle => 'अपना खेत जोड़ें';

  @override
  String get farmNameLabel => 'खेत का नाम';

  @override
  String get villageLabel => 'गांव';

  @override
  String get areaLabel => 'क्षेत्रफल';

  @override
  String get areaUnitLabel => 'इकाई';

  @override
  String get soilTypeLabel => 'मिट्टी का प्रकार';

  @override
  String get irrigationTypeLabel => 'सिंचाई का प्रकार';

  @override
  String get addCropTitle => 'फसल सीज़न जोड़ें';

  @override
  String get cropLabel => 'फसल';

  @override
  String get varietyLabel => 'किस्म (वैकल्पिक)';

  @override
  String get sowingDateLabel => 'बुवाई की तारीख';

  @override
  String get navHome => 'होम';

  @override
  String get navFarm => 'खेत';

  @override
  String get navMarket => 'बाज़ार';

  @override
  String get navAssistant => 'सहायक';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get goodMorning => 'शुभ प्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String dayNumber(int day) {
    return 'दिन $day';
  }

  @override
  String get todaysTasks => 'आज के काम';

  @override
  String get weather => 'मौसम';

  @override
  String get irrigation => 'सिंचाई';

  @override
  String get cropHealth => 'फसल स्वास्थ्य';

  @override
  String get myFarm => 'मेरा खेत';

  @override
  String get expenses => 'खर्च';

  @override
  String get mandi => 'मंडी';

  @override
  String get askKisanMitra => 'किसानमित्र से पूछें';

  @override
  String get dailyTip => 'आज की सलाह';

  @override
  String get addFarm => 'खेत जोड़ें';

  @override
  String get addExpense => 'खर्च जोड़ें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get languageSettingTitle => 'भाषा';

  @override
  String get aboutTitle => 'के बारे में';

  @override
  String get privacyTitle => 'गोपनीयता';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get offlineBanner =>
      'आप ऑफ़लाइन हैं। सहेजी गई जानकारी दिखाई जा रही है।';

  @override
  String get genericErrorMessage =>
      'अभी अपडेट नहीं हो सका। आपका डेटा सुरक्षित रूप से सहेजा गया है और इंटरनेट उपलब्ध होने पर सिंक हो जाएगा।';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get howIsYourCropToday => 'आज आपकी फसल कैसी है?';

  @override
  String get healthGood => 'अच्छी';

  @override
  String get healthNeedsAttention => 'ध्यान देने की जरूरत';

  @override
  String get healthCritical => 'समस्या';

  @override
  String get done => 'पूर्ण';

  @override
  String get remindMe => 'मुझे याद दिलाएं';

  @override
  String get skip => 'छोड़ें';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String tasksPendingLabel(int count) {
    return '$count बाकी';
  }

  @override
  String get allTasksDoneMessage => 'आज का खेत का काम पूरा हुआ';

  @override
  String get noCropYetMessage => 'आज की योजना देखने के लिए फसल जोड़ें';

  @override
  String get taskStatusDone => 'पूर्ण';

  @override
  String get taskStatusSkipped => 'छोड़ा गया';

  @override
  String get taskStatusSnoozed => 'कल के लिए याद दिलाया गया';

  @override
  String get amountLabel => 'राशि';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get notesLabel => 'नोट्स (वैकल्पिक)';

  @override
  String get seasonExpenseLabel => 'सीज़न खर्च';

  @override
  String get noExpensesMessage => 'अभी तक कोई खर्च दर्ज नहीं किया गया';

  @override
  String get addReceiptPhoto => 'रसीद की फोटो जोड़ें';

  @override
  String get expenseCategorySeeds => 'बीज';

  @override
  String get expenseCategoryFertilizer => 'उर्वरक';

  @override
  String get expenseCategoryPesticide => 'कीटनाशक';

  @override
  String get expenseCategoryLabour => 'मजदूरी';

  @override
  String get expenseCategoryTractor => 'ट्रैक्टर';

  @override
  String get expenseCategoryDiesel => 'डीजल';

  @override
  String get expenseCategoryIrrigation => 'सिंचाई';

  @override
  String get expenseCategoryElectricity => 'बिजली';

  @override
  String get expenseCategoryTransport => 'परिवहन';

  @override
  String get expenseCategoryEquipment => 'उपकरण';

  @override
  String get expenseCategoryOther => 'अन्य';

  @override
  String get irrigationTitle => 'सिंचाई';

  @override
  String get logIrrigation => 'सिंचाई दर्ज करें';

  @override
  String get durationMinutesLabel => 'अवधि (मिनट)';

  @override
  String get methodLabel => 'विधि';

  @override
  String get noIrrigationMessage => 'अभी तक कोई सिंचाई दर्ज नहीं की गई';

  @override
  String lastIrrigationLabel(int daysAgo) {
    String _temp0 = intl.Intl.pluralLogic(
      daysAgo,
      locale: localeName,
      other: '$daysAgo दिन पहले',
      one: '1 दिन पहले',
      zero: 'आज',
    );
    return 'पिछली सिंचाई: $_temp0';
  }

  @override
  String get fertilizerTitle => 'उर्वरक';

  @override
  String get logFertilizer => 'उर्वरक दर्ज करें';

  @override
  String get productLabel => 'उत्पाद';

  @override
  String get quantityLabel => 'मात्रा';

  @override
  String get unitLabel => 'इकाई';

  @override
  String get costLabel => 'लागत (वैकल्पिक)';

  @override
  String get noFertilizerMessage => 'अभी तक कोई उर्वरक दर्ज नहीं किया गया';

  @override
  String get sprayTitle => 'छिड़काव';

  @override
  String get logSpray => 'छिड़काव दर्ज करें';

  @override
  String get doseLabel => 'खुराक';

  @override
  String get reasonLabel => 'कारण';

  @override
  String get noSprayMessage => 'अभी तक कोई छिड़काव दर्ज नहीं किया गया';

  @override
  String get weatherTitle => 'मौसम';

  @override
  String get rainProbabilityLabel => 'बारिश की संभावना';

  @override
  String get humidityLabel => 'नमी';

  @override
  String get windLabel => 'हवा';

  @override
  String lastUpdatedLabel(String time) {
    return 'अंतिम अपडेट: $time';
  }

  @override
  String get weatherUnavailableMessage => 'मौसम की जानकारी अभी उपलब्ध नहीं है।';

  @override
  String get addFarmLocationMessage =>
      'मौसम देखने के लिए अपने खेत का स्थान जोड़ें';

  @override
  String get useCurrentLocation => 'वर्तमान स्थान का उपयोग करें';

  @override
  String get avoidSprayingAdvice => 'बारिश की संभावना — आज छिड़काव न करें।';

  @override
  String get irrigationNotNeededAdvice =>
      'बारिश की संभावना — सिंचाई की आवश्यकता नहीं हो सकती।';

  @override
  String get checkDrainageAdvice =>
      'भारी बारिश की संभावना — खेत की जल निकासी जांचें।';

  @override
  String get goodSprayingConditionsAdvice =>
      'बारिश की संभावना नहीं — आज छिड़काव सुरक्षित है।';

  @override
  String get hotDayAdvice => 'गर्म दिन — जरूरत हो तो ठंडे समय में सिंचाई करें।';

  @override
  String get addMandiPrice => 'भाव जोड़ें';

  @override
  String get commodityLabel => 'जिंस';

  @override
  String get marketLabel => 'मंडी (वैकल्पिक)';

  @override
  String get priceLabel => 'भाव';

  @override
  String get noMandiPricesMessage =>
      'अभी तक कोई भाव दर्ज नहीं किया गया। रुझान देखने के लिए मंडी में देखे गए भाव जोड़ें।';

  @override
  String get mandiManualTrackingNote =>
      'लाइव मंडी फीड अभी जुड़ी नहीं है — भाव खुद दर्ज करें।';

  @override
  String previousPriceLabel(String price) {
    return 'पिछला: ₹$price';
  }

  @override
  String get aiAssistantHint => 'अपने खेत के बारे में सवाल पूछें';

  @override
  String get aiAssistantSend => 'भेजें';

  @override
  String get aiNotConfiguredMessage =>
      'AI सहायक को सुरक्षित रूप से जवाब देने के लिए Firebase Cloud Function चाहिए — यह सेटअप होने के बाद जुड़ जाएगा। अभी के लिए आपका सवाल सहेज लिया गया है।';

  @override
  String get checkInTitle => 'दैनिक जांच';

  @override
  String get checkInPromptGood => 'अच्छी';

  @override
  String get checkInPromptAttention => 'ध्यान देने की जरूरत';

  @override
  String get checkInPromptProblem => 'समस्या';

  @override
  String get checkInWhatDidYouNotice => 'आपने क्या देखा?';

  @override
  String get concernPest => 'कीट';

  @override
  String get concernLeafChange => 'पत्तियों में बदलाव';

  @override
  String get concernWaterStress => 'पानी की कमी';

  @override
  String get concernDisease => 'रोग';

  @override
  String get concernOther => 'अन्य';

  @override
  String get addPhoto => 'फोटो जोड़ें';

  @override
  String get addNote => 'नोट जोड़ें';

  @override
  String get checkInSavedMessage => 'जांच सहेजी गई';

  @override
  String get alreadyCheckedInMessage => 'आप आज पहले ही जांच कर चुके हैं';

  @override
  String get changeCheckIn => 'बदलें';

  @override
  String get syncStatusTitle => 'सिंक स्थिति';

  @override
  String syncPendingLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रिकॉर्ड सिंक होना बाकी है',
      one: '1 रिकॉर्ड सिंक होना बाकी है',
      zero: 'कुछ भी बाकी नहीं',
    );
    return '$_temp0';
  }

  @override
  String get syncNotConnectedMessage =>
      'आपका डेटा इस डिवाइस पर सुरक्षित रूप से सहेजा गया है। ऑनलाइन सिंक अभी जुड़ा नहीं है।';

  @override
  String get orDivider => 'या';

  @override
  String get dashboardTagline => 'खेती करते रहें, आगे बढ़ते रहें!';

  @override
  String get rainAlertTitle => 'बारिश की चेतावनी';

  @override
  String get activeCropLabel => 'सक्रिय फसल';

  @override
  String tasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count काम',
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
  String get invalidPhoneNumberMessage =>
      'एक मान्य 10 अंकों का मोबाइल नंबर दर्ज करें';

  @override
  String get weatherConditionClear => 'साफ़';

  @override
  String get weatherConditionCloudy => 'बादल';

  @override
  String get weatherConditionFog => 'कोहरा';

  @override
  String get weatherConditionRain => 'बारिश';

  @override
  String get weatherConditionStorm => 'आंधी-तूफ़ान';

  @override
  String get weatherConditionSnow => 'बर्फ़';

  @override
  String get liveMandiPricesTitle => 'लाइव मंडी भाव';

  @override
  String get liveMandiSourceLabel => 'स्रोत: एगमार्कनेट (data.gov.in)';

  @override
  String modalPriceLabel(String price) {
    return 'मॉडल भाव: ₹$price';
  }

  @override
  String get yourTrackedPricesLabel => 'आपके नोट किए भाव';

  @override
  String get perQuintalLabel => 'प्रति क्विंटल';

  @override
  String get lastIrrigationTitle => 'पिछला सिंचाई';

  @override
  String get suggestedNextIrrigationTitle => 'अगली सुझाई गई सिंचाई';

  @override
  String get irrigationHistoryNeededMessage =>
      'सुझाया गया शेड्यूल देखने के लिए कुछ और सिंचाई दर्ज करें';

  @override
  String get irrigationHistoryTitle => 'सिंचाई इतिहास';

  @override
  String daysAgoLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन पहले',
      one: '1 दिन पहले',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String inDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन में',
      one: 'कल',
      zero: 'आज',
    );
    return '$_temp0';
  }

  @override
  String get minutesUnitLabel => 'मिनट';

  @override
  String get checkInNoteHint => 'अपनी टिप्पणी लिखें...';

  @override
  String get totalCropExpenseLabel => 'कुल फसल खर्च';

  @override
  String get thisMonthLabel => 'इस महीने';

  @override
  String get thisSeasonLabel => 'इस सीज़न';

  @override
  String get recentExpensesLabel => 'हाल के खर्च';

  @override
  String get seasonLabel => 'मौसम';

  @override
  String get seasonKharif => 'खरीफ';

  @override
  String get seasonRabi => 'रबी';

  @override
  String get seasonZaid => 'जायद (गर्मी)';

  @override
  String get farmLocationLabel => 'खेत का स्थान';

  @override
  String get mapTapToMovePin =>
      'पिन को अपने खेत पर ले जाने के लिए मैप पर टैप करें';

  @override
  String get mandiAllTab => 'सभी';

  @override
  String get mandiFavouritesTab => 'पसंदीदा';

  @override
  String get noFavouritesMessage =>
      'किसी फसल को पसंदीदा में जोड़ने के लिए स्टार पर टैप करें।';

  @override
  String get addToFavourite => 'पसंदीदा में जोड़ें';

  @override
  String get removeFromFavourite => 'पसंदीदा से हटाएं';

  @override
  String get setPriceAlert => 'मूल्य अलर्ट सेट करें';

  @override
  String priceAlertDialogTitle(String commodity) {
    return '$commodity के लिए मूल्य अलर्ट';
  }

  @override
  String get priceAlertTargetLabel => 'जब भाव यहां पहुंचे तब बताएं (₹)';

  @override
  String get priceAlertHelp =>
      'जब आपके दर्ज किए गए या लाइव मंडी भाव इस रकम तक पहुंचेंगे, आपको सूचना मिलेगी।';

  @override
  String get removeAlert => 'अलर्ट हटाएं';

  @override
  String priceAlertActiveLabel(String price) {
    return '₹$price पर अलर्ट';
  }

  @override
  String priceAlertNotificationTitle(String commodity) {
    return '$commodity मूल्य अलर्ट';
  }

  @override
  String priceAlertNotificationBody(String commodity, String price) {
    return '$commodity ₹$price पर पहुंच गया — आपका लक्ष्य भाव।';
  }

  @override
  String get suggestedQuestionsLabel => 'सुझाए गए प्रश्न';

  @override
  String get suggestedQuestionPest => 'मेरी फसल पर कौन सा कीट लगा है?';

  @override
  String get suggestedQuestionFertilizer => 'अभी कौन सी खाद डालनी चाहिए?';

  @override
  String get suggestedQuestionIrrigation => 'अगली सिंचाई कब करनी चाहिए?';

  @override
  String get suggestedQuestionWeather =>
      'क्या आज का मौसम छिड़काव के लिए ठीक है?';

  @override
  String get voiceInputTooltip => 'अपना प्रश्न बोलें';

  @override
  String get voiceListeningLabel => 'सुन रहे हैं…';

  @override
  String get voiceUnavailableMessage =>
      'इस फोन पर आवाज़ से इनपुट उपलब्ध नहीं है। कृपया प्रश्न टाइप करें।';

  @override
  String get darkModeLabel => 'डार्क मोड';

  @override
  String get dailyReminderLabel => 'रोज़ाना खेती योजना रिमाइंडर';

  @override
  String get dailyReminderSubtitle => 'हर सुबह 8 बजे';

  @override
  String get helpSupportTitle => 'सहायता और समर्थन';

  @override
  String get helpIntro => 'आम सवालों के त्वरित जवाब।';

  @override
  String get helpFaqOfflineQ => 'क्या ऐप बिना इंटरनेट के चलता है?';

  @override
  String get helpFaqOfflineA =>
      'हाँ। काम, खर्च, रिकॉर्ड और चेक-इन आपके फोन में सेव होते हैं। मौसम, लाइव मंडी भाव और सहायक के लिए इंटरनेट चाहिए।';

  @override
  String get helpFaqTasksQ => 'आज के काम कहाँ से आते हैं?';

  @override
  String get helpFaqTasksA =>
      'ये आपकी फसल और बुवाई की तारीख से बनते हैं। हर काम को पूरा, छोड़ें या याद दिलाएं चुनें।';

  @override
  String get helpFaqLanguageQ => 'भाषा कैसे बदलें?';

  @override
  String get helpFaqLanguageA =>
      'प्रोफ़ाइल → भाषा में जाकर English, हिंदी या मराठी चुनें।';

  @override
  String get helpFaqDataQ => 'क्या मेरा खेत का डेटा सुरक्षित है?';

  @override
  String get helpFaqDataA =>
      'आपका डेटा आपके फोन में रहता है। आप इसे कभी भी प्रोफ़ाइल → खाता हटाएं से मिटा सकते हैं।';

  @override
  String get deleteAccountTitle => 'खाता हटाएं';

  @override
  String get deleteAccountConfirmMessage =>
      'इससे आपकी प्रोफ़ाइल, खेत, फसलें, काम, खर्च और सभी रिकॉर्ड इस फोन से हमेशा के लिए मिट जाएंगे। इसे वापस नहीं किया जा सकता।';

  @override
  String get deleteButton => 'हटाएं';
}
