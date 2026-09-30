// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KisanMitra 360';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get continueButton => 'Continue';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginHeading => 'Enter your mobile number';

  @override
  String get loginSubtitle => 'We\'ll send you an OTP';

  @override
  String get phoneNumberLabel => 'Mobile number';

  @override
  String get sendOtp => 'Get OTP';

  @override
  String get otpTitle => 'Verify OTP';

  @override
  String otpSubtitle(String phone) {
    return 'Enter the code sent to $phone';
  }

  @override
  String get verifyOtp => 'Verify';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get profileSetupHeading => 'Farmer Profile Setup';

  @override
  String get profileSetupTitle => 'Tell us about yourself';

  @override
  String get nameLabel => 'Your name';

  @override
  String get stateLabel => 'State';

  @override
  String get districtLabel => 'District';

  @override
  String get preferredLanguageLabel => 'Preferred Language';

  @override
  String get saveAndContinue => 'Save and Continue';

  @override
  String get nextButton => 'Next';

  @override
  String get addFarmTitle => 'Add your farm';

  @override
  String get farmNameLabel => 'Farm name';

  @override
  String get villageLabel => 'Village';

  @override
  String get areaLabel => 'Area';

  @override
  String get areaUnitLabel => 'Unit';

  @override
  String get soilTypeLabel => 'Soil type';

  @override
  String get irrigationTypeLabel => 'Irrigation type';

  @override
  String get addCropTitle => 'Add crop season';

  @override
  String get cropLabel => 'Crop';

  @override
  String get varietyLabel => 'Variety (optional)';

  @override
  String get sowingDateLabel => 'Sowing date';

  @override
  String get navHome => 'Home';

  @override
  String get navFarm => 'Farm';

  @override
  String get navMarket => 'Market';

  @override
  String get navAssistant => 'Assistant';

  @override
  String get navProfile => 'Profile';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String dayNumber(int day) {
    return 'Day $day';
  }

  @override
  String get todaysTasks => 'Today\'s Tasks';

  @override
  String get weather => 'Weather';

  @override
  String get irrigation => 'Irrigation';

  @override
  String get cropHealth => 'Crop Health';

  @override
  String get myFarm => 'My Farm';

  @override
  String get expenses => 'Expenses';

  @override
  String get mandi => 'Mandi';

  @override
  String get askKisanMitra => 'Ask KisanMitra';

  @override
  String get dailyTip => 'Today\'s Tip';

  @override
  String get addFarm => 'Add Farm';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get aboutTitle => 'About';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get logout => 'Log out';

  @override
  String get offlineBanner => 'You\'re offline. Showing saved information.';

  @override
  String get genericErrorMessage =>
      'Unable to update right now. Your data is safely saved and will sync when internet is available.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get howIsYourCropToday => 'How is your crop today?';

  @override
  String get healthGood => 'Good';

  @override
  String get healthNeedsAttention => 'Needs Attention';

  @override
  String get healthCritical => 'Problem';

  @override
  String get done => 'Done';

  @override
  String get remindMe => 'Remind Me';

  @override
  String get skip => 'Skip';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String tasksPendingLabel(int count) {
    return '$count pending';
  }

  @override
  String get allTasksDoneMessage => 'Today\'s farm work completed';

  @override
  String get noCropYetMessage => 'Add a crop to see today\'s farm plan';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get taskStatusSkipped => 'Skipped';

  @override
  String get taskStatusSnoozed => 'Reminded for tomorrow';

  @override
  String get amountLabel => 'Amount';

  @override
  String get categoryLabel => 'Category';

  @override
  String get dateLabel => 'Date';

  @override
  String get notesLabel => 'Notes (optional)';

  @override
  String get seasonExpenseLabel => 'Season Expense';

  @override
  String get noExpensesMessage => 'No expenses logged yet';

  @override
  String get addReceiptPhoto => 'Add receipt photo';

  @override
  String get expenseCategorySeeds => 'Seeds';

  @override
  String get expenseCategoryFertilizer => 'Fertilizer';

  @override
  String get expenseCategoryPesticide => 'Pesticide';

  @override
  String get expenseCategoryLabour => 'Labour';

  @override
  String get expenseCategoryTractor => 'Tractor';

  @override
  String get expenseCategoryDiesel => 'Diesel';

  @override
  String get expenseCategoryIrrigation => 'Irrigation';

  @override
  String get expenseCategoryElectricity => 'Electricity';

  @override
  String get expenseCategoryTransport => 'Transport';

  @override
  String get expenseCategoryEquipment => 'Equipment';

  @override
  String get expenseCategoryOther => 'Other';

  @override
  String get irrigationTitle => 'Irrigation';

  @override
  String get logIrrigation => 'Log Irrigation';

  @override
  String get durationMinutesLabel => 'Duration (minutes)';

  @override
  String get methodLabel => 'Method';

  @override
  String get noIrrigationMessage => 'No irrigation logged yet';

  @override
  String lastIrrigationLabel(int daysAgo) {
    String _temp0 = intl.Intl.pluralLogic(
      daysAgo,
      locale: localeName,
      other: '$daysAgo days ago',
      one: '1 day ago',
      zero: 'today',
    );
    return 'Last irrigation: $_temp0';
  }

  @override
  String get fertilizerTitle => 'Fertilizer';

  @override
  String get logFertilizer => 'Log Fertilizer';

  @override
  String get productLabel => 'Product';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get unitLabel => 'Unit';

  @override
  String get costLabel => 'Cost (optional)';

  @override
  String get noFertilizerMessage => 'No fertilizer logged yet';

  @override
  String get sprayTitle => 'Spray';

  @override
  String get logSpray => 'Log Spray';

  @override
  String get doseLabel => 'Dose';

  @override
  String get reasonLabel => 'Reason';

  @override
  String get noSprayMessage => 'No spray logged yet';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get rainProbabilityLabel => 'Rain chance';

  @override
  String get humidityLabel => 'Humidity';

  @override
  String get windLabel => 'Wind';

  @override
  String lastUpdatedLabel(String time) {
    return 'Last updated: $time';
  }

  @override
  String get weatherUnavailableMessage => 'Weather isn\'t available right now.';

  @override
  String get addFarmLocationMessage =>
      'Add your farm\'s location to see weather';

  @override
  String get useCurrentLocation => 'Use current location';

  @override
  String get avoidSprayingAdvice => 'Rain expected — avoid spraying today.';

  @override
  String get irrigationNotNeededAdvice =>
      'Rain expected — irrigation may not be needed.';

  @override
  String get checkDrainageAdvice =>
      'Heavy rain expected — check field drainage.';

  @override
  String get goodSprayingConditionsAdvice =>
      'No rain expected — safe to spray today.';

  @override
  String get hotDayAdvice =>
      'Hot day — irrigate during cooler hours if needed.';

  @override
  String get addMandiPrice => 'Add Price';

  @override
  String get commodityLabel => 'Commodity';

  @override
  String get marketLabel => 'Market (optional)';

  @override
  String get priceLabel => 'Price';

  @override
  String get noMandiPricesMessage =>
      'No prices logged yet. Add prices you see at the mandi to track trends over time.';

  @override
  String get mandiManualTrackingNote =>
      'Live mandi feeds aren\'t connected yet — track prices you observe manually.';

  @override
  String previousPriceLabel(String price) {
    return 'Previous: ₹$price';
  }

  @override
  String get aiAssistantHint => 'Ask a question about your farm';

  @override
  String get aiAssistantSend => 'Send';

  @override
  String get aiNotConfiguredMessage =>
      'The AI assistant needs a Firebase Cloud Function to answer safely — this will connect once that\'s set up. For now, your question is saved so you don\'t lose it.';

  @override
  String get checkInTitle => 'Daily Check-in';

  @override
  String get checkInPromptGood => 'Good';

  @override
  String get checkInPromptAttention => 'Needs Attention';

  @override
  String get checkInPromptProblem => 'Problem';

  @override
  String get checkInWhatDidYouNotice => 'What did you notice?';

  @override
  String get concernPest => 'Pest';

  @override
  String get concernLeafChange => 'Leaf change';

  @override
  String get concernWaterStress => 'Water stress';

  @override
  String get concernDisease => 'Disease';

  @override
  String get concernOther => 'Other';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get addNote => 'Add Note';

  @override
  String get checkInSavedMessage => 'Check-in saved';

  @override
  String get alreadyCheckedInMessage => 'You\'ve already checked in today';

  @override
  String get changeCheckIn => 'Change';

  @override
  String get syncStatusTitle => 'Sync status';

  @override
  String syncPendingLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records waiting to sync',
      one: '1 record waiting to sync',
      zero: 'Nothing waiting',
    );
    return '$_temp0';
  }

  @override
  String get syncNotConnectedMessage =>
      'Your data is safely saved on this device. Online sync isn\'t connected yet.';

  @override
  String get orDivider => 'or';

  @override
  String get dashboardTagline => 'Your farm, your companion';

  @override
  String get rainAlertTitle => 'Rain Alert';

  @override
  String get activeCropLabel => 'Active Crop';

  @override
  String tasksCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String get irrigationNormalStatus => 'Normal';

  @override
  String get irrigationDueStatus => 'Due';

  @override
  String get noDataDash => '—';

  @override
  String get countryLabel => 'Country';

  @override
  String get invalidPhoneNumberMessage =>
      'Enter a valid 10-digit mobile number';

  @override
  String get weatherConditionClear => 'Clear';

  @override
  String get weatherConditionCloudy => 'Cloudy';

  @override
  String get weatherConditionFog => 'Foggy';

  @override
  String get weatherConditionRain => 'Rainy';

  @override
  String get weatherConditionStorm => 'Thunderstorm';

  @override
  String get weatherConditionSnow => 'Snowy';

  @override
  String get liveMandiPricesTitle => 'Live Mandi Prices';

  @override
  String get liveMandiSourceLabel => 'Source: Mandi Price API (data.gov.in)';

  @override
  String modalPriceLabel(String price) {
    return 'Modal: ₹$price';
  }

  @override
  String get yourTrackedPricesLabel => 'Your Tracked Prices';

  @override
  String get perQuintalLabel => 'per quintal';

  @override
  String get lastIrrigationTitle => 'Last Irrigation';

  @override
  String get suggestedNextIrrigationTitle => 'Suggested Next Irrigation';

  @override
  String get irrigationHistoryNeededMessage =>
      'Log a couple more irrigations to see a suggested schedule';

  @override
  String get irrigationHistoryTitle => 'Irrigation History';

  @override
  String daysAgoLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String inDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get minutesUnitLabel => 'min';

  @override
  String get checkInNoteHint => 'Enter your note...';

  @override
  String get totalCropExpenseLabel => 'Total Crop Expense';

  @override
  String get thisMonthLabel => 'This Month';

  @override
  String get thisSeasonLabel => 'This Season';

  @override
  String get recentExpensesLabel => 'Recent Expenses';

  @override
  String get seasonLabel => 'Season';

  @override
  String get seasonKharif => 'Kharif';

  @override
  String get seasonRabi => 'Rabi';

  @override
  String get seasonZaid => 'Zaid (Summer)';

  @override
  String get farmLocationLabel => 'Farm location';

  @override
  String get mapTapToMovePin => 'Tap the map to move the pin to your field';

  @override
  String get mandiAllTab => 'All';

  @override
  String get mandiFavouritesTab => 'Favourites';

  @override
  String get noFavouritesMessage =>
      'Tap the star on a crop to add it to your favourites.';

  @override
  String get addToFavourite => 'Add to favourites';

  @override
  String get removeFromFavourite => 'Remove from favourites';

  @override
  String get setPriceAlert => 'Set price alert';

  @override
  String priceAlertDialogTitle(String commodity) {
    return 'Price alert for $commodity';
  }

  @override
  String get priceAlertTargetLabel => 'Alert me when price reaches (₹)';

  @override
  String get priceAlertHelp =>
      'You\'ll get a notification when a price you log or a live mandi price reaches this amount.';

  @override
  String get removeAlert => 'Remove alert';

  @override
  String priceAlertActiveLabel(String price) {
    return 'Alert at ₹$price';
  }

  @override
  String priceAlertNotificationTitle(String commodity) {
    return '$commodity price alert';
  }

  @override
  String priceAlertNotificationBody(String commodity, String price) {
    return '$commodity has reached ₹$price — your target price.';
  }

  @override
  String get suggestedQuestionsLabel => 'Suggested questions';

  @override
  String get suggestedQuestionPest => 'Which pest is attacking my crop?';

  @override
  String get suggestedQuestionFertilizer =>
      'Which fertilizer should I use now?';

  @override
  String get suggestedQuestionIrrigation => 'When should I water my crop next?';

  @override
  String get suggestedQuestionWeather =>
      'Is today\'s weather good for spraying?';

  @override
  String get voiceInputTooltip => 'Speak your question';

  @override
  String get voiceListeningLabel => 'Listening…';

  @override
  String get voiceUnavailableMessage =>
      'Voice input isn\'t available on this phone. Please type your question.';

  @override
  String get darkModeLabel => 'Dark mode';

  @override
  String get dailyReminderLabel => 'Daily farm plan reminder';

  @override
  String get dailyReminderSubtitle => 'Every morning at 8 AM';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get helpIntro => 'Quick answers to common questions.';

  @override
  String get helpFaqOfflineQ => 'Does the app work without internet?';

  @override
  String get helpFaqOfflineA =>
      'Yes. Tasks, expenses, logs and check-ins are saved on your phone. Weather, live mandi prices and the assistant need internet.';

  @override
  String get helpFaqTasksQ => 'Where do today\'s tasks come from?';

  @override
  String get helpFaqTasksA =>
      'They\'re created from your crop and its sowing date. Mark each one Done, Skip or Remind Me.';

  @override
  String get helpFaqLanguageQ => 'How do I change the language?';

  @override
  String get helpFaqLanguageA =>
      'Go to Profile → Language and pick English, हिंदी or मराठी.';

  @override
  String get helpFaqDataQ => 'Is my farm data safe?';

  @override
  String get helpFaqDataA =>
      'Your data stays on your phone. You can delete it any time from Profile → Reset app data.';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountConfirmMessage =>
      'This permanently deletes your profile, farms, crops, tasks, expenses and all logs from this phone. This can\'t be undone.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get resetAppDataTitle => 'Reset app data';

  @override
  String get resetAppDataMessage =>
      'This permanently deletes your profile, farms, crops, tasks, expenses and all logs from this phone, and starts the app fresh. This can\'t be undone.';

  @override
  String get sevenDayForecastTitle => '7-Day Forecast';

  @override
  String get forecastTodayLabel => 'Today';

  @override
  String get requiredFieldError => 'Please fill this in';

  @override
  String get invalidAreaError => 'Enter the area as a number, e.g. 2.5';

  @override
  String get hourlyForecastTitle => 'Next 24 hours';

  @override
  String feelsLikeLabel(String temp) {
    return 'Feels like $temp°';
  }

  @override
  String get weatherDetailsTitle => 'Details';

  @override
  String get uvIndexLabel => 'UV index';

  @override
  String get sunriseLabel => 'Sunrise';

  @override
  String get sunsetLabel => 'Sunset';

  @override
  String get farmAdviceTitle => 'Farm advice';

  @override
  String get weatherDemoBadge => 'Demo data';

  @override
  String get weatherNoAdvice =>
      'No special precautions today — a normal farm day.';

  @override
  String highLowLabel(String high, String low) {
    return 'H $high°  L $low°';
  }

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get qaSpray => 'Log spray';

  @override
  String get qaExpense => 'Add expense';

  @override
  String get qaFertilizer => 'Fertilizer';

  @override
  String get qaIrrigation => 'Irrigation';

  @override
  String get qaCropCheck => 'Crop check';

  @override
  String get farmSummaryTitle => 'Your farm at a glance';

  @override
  String get summaryArea => 'Area';

  @override
  String get summaryExpenses => 'Expenses';

  @override
  String summaryCropDay(int day, int total) {
    return 'Day $day of about $total';
  }

  @override
  String get summaryNoCrop => 'Add a crop to track its progress';

  @override
  String get summaryNotSet => 'Not set';

  @override
  String get mandiTickerTitle => 'Mandi prices today';

  @override
  String get mandiSampleCaption => 'Sample prices';

  @override
  String get mandiPerQuintal => 'per quintal';

  @override
  String get schemesTitle => 'Schemes for farmers';

  @override
  String get schemesSampleCaption => 'Sample information';

  @override
  String get schemePmKisanTitle => 'PM-Kisan';

  @override
  String get schemePmKisanDesc =>
      '₹6,000 a year in three instalments, straight to your bank account.';

  @override
  String get schemePmfbyTitle => 'Crop insurance (PMFBY)';

  @override
  String get schemePmfbyDesc =>
      'Insure your crop against drought, flood and pests at a low premium.';

  @override
  String get schemeKccTitle => 'Kisan Credit Card';

  @override
  String get schemeKccDesc =>
      'Low-interest farm loans for seeds, fertilizer and equipment.';

  @override
  String get dailyTipTitle => 'Tip of the day';

  @override
  String get dailyTipBody =>
      'Water early in the morning. Less water is lost to the sun and leaves dry before night, which lowers disease.';

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
