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
  String get dashboardTagline => 'आपका खेत, आपका साथी';

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
      'आपका डेटा आपके फोन में रहता है। आप इसे कभी भी प्रोफ़ाइल → ऐप डेटा रीसेट करें से मिटा सकते हैं।';

  @override
  String get deleteAccountTitle => 'खाता हटाएं';

  @override
  String get deleteAccountConfirmMessage =>
      'इससे आपकी प्रोफ़ाइल, खेत, फसलें, काम, खर्च और सभी रिकॉर्ड इस फोन से हमेशा के लिए मिट जाएंगे। इसे वापस नहीं किया जा सकता।';

  @override
  String get deleteButton => 'हटाएं';

  @override
  String get resetAppDataTitle => 'ऐप डेटा रीसेट करें';

  @override
  String get resetAppDataMessage =>
      'इससे आपकी प्रोफ़ाइल, खेत, फसलें, काम, खर्च और सभी रिकॉर्ड इस फोन से हमेशा के लिए मिट जाएंगे और ऐप नए सिरे से शुरू होगा। इसे वापस नहीं किया जा सकता।';

  @override
  String get sevenDayForecastTitle => '7 दिन का पूर्वानुमान';

  @override
  String get forecastTodayLabel => 'आज';

  @override
  String get requiredFieldError => 'कृपया यह भरें';

  @override
  String get invalidAreaError => 'क्षेत्र संख्या में लिखें, जैसे 2.5';

  @override
  String get hourlyForecastTitle => 'अगले 24 घंटे';

  @override
  String feelsLikeLabel(String temp) {
    return 'महसूस हो रहा है $temp°';
  }

  @override
  String get weatherDetailsTitle => 'विवरण';

  @override
  String get uvIndexLabel => 'यूवी इंडेक्स';

  @override
  String get sunriseLabel => 'सूर्योदय';

  @override
  String get sunsetLabel => 'सूर्यास्त';

  @override
  String get farmAdviceTitle => 'खेत की सलाह';

  @override
  String get weatherDemoBadge => 'डेमो डेटा';

  @override
  String get weatherNoAdvice => 'आज कोई विशेष सावधानी नहीं — सामान्य दिन।';

  @override
  String highLowLabel(String high, String low) {
    return 'अधिकतम $high°  न्यूनतम $low°';
  }

  @override
  String get quickActionsTitle => 'त्वरित कार्य';

  @override
  String get qaSpray => 'छिड़काव दर्ज करें';

  @override
  String get qaExpense => 'खर्च जोड़ें';

  @override
  String get qaFertilizer => 'खाद';

  @override
  String get qaIrrigation => 'सिंचाई';

  @override
  String get qaCropCheck => 'फसल जांच';

  @override
  String get farmSummaryTitle => 'आपका खेत एक नज़र में';

  @override
  String get summaryArea => 'क्षेत्र';

  @override
  String get summaryExpenses => 'खर्च';

  @override
  String summaryCropDay(int day, int total) {
    return 'लगभग $total में से दिन $day';
  }

  @override
  String get summaryNoCrop => 'प्रगति देखने के लिए फसल जोड़ें';

  @override
  String get summaryNotSet => 'तय नहीं';

  @override
  String get mandiTickerTitle => 'आज के मंडी भाव';

  @override
  String get mandiSampleCaption => 'नमूना भाव';

  @override
  String get mandiPerQuintal => 'प्रति क्विंटल';

  @override
  String get schemesTitle => 'किसानों के लिए योजनाएं';

  @override
  String get schemesSampleCaption => 'नमूना जानकारी';

  @override
  String get schemePmKisanTitle => 'पीएम-किसान';

  @override
  String get schemePmKisanDesc =>
      'साल में ₹6,000, तीन किस्तों में सीधे आपके बैंक खाते में।';

  @override
  String get schemePmfbyTitle => 'फसल बीमा (पीएमएफबीवाई)';

  @override
  String get schemePmfbyDesc =>
      'कम प्रीमियम पर सूखा, बाढ़ और कीटों से फसल का बीमा।';

  @override
  String get schemeKccTitle => 'किसान क्रेडिट कार्ड';

  @override
  String get schemeKccDesc =>
      'बीज, खाद और उपकरण के लिए कम ब्याज पर खेती का कर्ज।';

  @override
  String get dailyTipTitle => 'आज की सलाह';

  @override
  String get dailyTipBody =>
      'सुबह जल्दी सिंचाई करें। धूप से कम पानी उड़ता है और पत्तियां रात से पहले सूख जाती हैं, जिससे रोग कम होते हैं।';

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
