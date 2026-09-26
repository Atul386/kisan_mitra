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
  String get addPhoto => 'Add Photo';

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
  String get dashboardTagline => 'Keep farming, keep growing!';

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
  String get liveMandiSourceLabel => 'Source: Agmarknet (data.gov.in)';

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
}
