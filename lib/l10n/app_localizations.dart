import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'KisanMitra 360'**
  String get appName;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get languageHindi;

  /// No description provided for @languageMarathi.
  ///
  /// In en, this message translates to:
  /// **'मराठी'**
  String get languageMarathi;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get loginHeading;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you an OTP'**
  String get loginSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneNumberLabel;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get sendOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyOtp;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @profileSetupHeading.
  ///
  /// In en, this message translates to:
  /// **'Farmer Profile Setup'**
  String get profileSetupHeading;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get profileSetupTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @preferredLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguageLabel;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save and Continue'**
  String get saveAndContinue;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @addFarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your farm'**
  String get addFarmTitle;

  /// No description provided for @farmNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm name'**
  String get farmNameLabel;

  /// No description provided for @villageLabel.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get villageLabel;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaLabel;

  /// No description provided for @areaUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get areaUnitLabel;

  /// No description provided for @soilTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Soil type'**
  String get soilTypeLabel;

  /// No description provided for @irrigationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Irrigation type'**
  String get irrigationTypeLabel;

  /// No description provided for @addCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Add crop season'**
  String get addCropTitle;

  /// No description provided for @cropLabel.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get cropLabel;

  /// No description provided for @varietyLabel.
  ///
  /// In en, this message translates to:
  /// **'Variety (optional)'**
  String get varietyLabel;

  /// No description provided for @sowingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Sowing date'**
  String get sowingDateLabel;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFarm.
  ///
  /// In en, this message translates to:
  /// **'Farm'**
  String get navFarm;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;

  /// No description provided for @navAssistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get navAssistant;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayNumber(int day);

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @cropHealth.
  ///
  /// In en, this message translates to:
  /// **'Crop Health'**
  String get cropHealth;

  /// No description provided for @myFarm.
  ///
  /// In en, this message translates to:
  /// **'My Farm'**
  String get myFarm;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @mandi.
  ///
  /// In en, this message translates to:
  /// **'Mandi'**
  String get mandi;

  /// No description provided for @askKisanMitra.
  ///
  /// In en, this message translates to:
  /// **'Ask KisanMitra'**
  String get askKisanMitra;

  /// No description provided for @dailyTip.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tip'**
  String get dailyTip;

  /// No description provided for @addFarm.
  ///
  /// In en, this message translates to:
  /// **'Add Farm'**
  String get addFarm;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved information.'**
  String get offlineBanner;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to update right now. Your data is safely saved and will sync when internet is available.'**
  String get genericErrorMessage;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @howIsYourCropToday.
  ///
  /// In en, this message translates to:
  /// **'How is your crop today?'**
  String get howIsYourCropToday;

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// No description provided for @healthNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get healthNeedsAttention;

  /// No description provided for @healthCritical.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get healthCritical;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind Me'**
  String get remindMe;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tasksPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String tasksPendingLabel(int count);

  /// No description provided for @allTasksDoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Today\'s farm work completed'**
  String get allTasksDoneMessage;

  /// No description provided for @noCropYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a crop to see today\'s farm plan'**
  String get noCropYetMessage;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get taskStatusSkipped;

  /// No description provided for @taskStatusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Reminded for tomorrow'**
  String get taskStatusSnoozed;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesLabel;

  /// No description provided for @seasonExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Season Expense'**
  String get seasonExpenseLabel;

  /// No description provided for @noExpensesMessage.
  ///
  /// In en, this message translates to:
  /// **'No expenses logged yet'**
  String get noExpensesMessage;

  /// No description provided for @addReceiptPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add receipt photo'**
  String get addReceiptPhoto;

  /// No description provided for @expenseCategorySeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get expenseCategorySeeds;

  /// No description provided for @expenseCategoryFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get expenseCategoryFertilizer;

  /// No description provided for @expenseCategoryPesticide.
  ///
  /// In en, this message translates to:
  /// **'Pesticide'**
  String get expenseCategoryPesticide;

  /// No description provided for @expenseCategoryLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get expenseCategoryLabour;

  /// No description provided for @expenseCategoryTractor.
  ///
  /// In en, this message translates to:
  /// **'Tractor'**
  String get expenseCategoryTractor;

  /// No description provided for @expenseCategoryDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get expenseCategoryDiesel;

  /// No description provided for @expenseCategoryIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get expenseCategoryIrrigation;

  /// No description provided for @expenseCategoryElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get expenseCategoryElectricity;

  /// No description provided for @expenseCategoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expenseCategoryTransport;

  /// No description provided for @expenseCategoryEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get expenseCategoryEquipment;

  /// No description provided for @expenseCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseCategoryOther;

  /// No description provided for @irrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigationTitle;

  /// No description provided for @logIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Log Irrigation'**
  String get logIrrigation;

  /// No description provided for @durationMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutesLabel;

  /// No description provided for @methodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get methodLabel;

  /// No description provided for @noIrrigationMessage.
  ///
  /// In en, this message translates to:
  /// **'No irrigation logged yet'**
  String get noIrrigationMessage;

  /// No description provided for @lastIrrigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Last irrigation: {daysAgo, plural, =0{today} =1{1 day ago} other{{daysAgo} days ago}}'**
  String lastIrrigationLabel(int daysAgo);

  /// No description provided for @fertilizerTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizerTitle;

  /// No description provided for @logFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Log Fertilizer'**
  String get logFertilizer;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @costLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost (optional)'**
  String get costLabel;

  /// No description provided for @noFertilizerMessage.
  ///
  /// In en, this message translates to:
  /// **'No fertilizer logged yet'**
  String get noFertilizerMessage;

  /// No description provided for @sprayTitle.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get sprayTitle;

  /// No description provided for @logSpray.
  ///
  /// In en, this message translates to:
  /// **'Log Spray'**
  String get logSpray;

  /// No description provided for @doseLabel.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get doseLabel;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reasonLabel;

  /// No description provided for @noSprayMessage.
  ///
  /// In en, this message translates to:
  /// **'No spray logged yet'**
  String get noSprayMessage;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @rainProbabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get rainProbabilityLabel;

  /// No description provided for @humidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidityLabel;

  /// No description provided for @windLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get windLabel;

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String lastUpdatedLabel(String time);

  /// No description provided for @weatherUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Weather isn\'t available right now.'**
  String get weatherUnavailableMessage;

  /// No description provided for @addFarmLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your farm\'s location to see weather'**
  String get addFarmLocationMessage;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get useCurrentLocation;

  /// No description provided for @avoidSprayingAdvice.
  ///
  /// In en, this message translates to:
  /// **'Rain expected — avoid spraying today.'**
  String get avoidSprayingAdvice;

  /// No description provided for @irrigationNotNeededAdvice.
  ///
  /// In en, this message translates to:
  /// **'Rain expected — irrigation may not be needed.'**
  String get irrigationNotNeededAdvice;

  /// No description provided for @checkDrainageAdvice.
  ///
  /// In en, this message translates to:
  /// **'Heavy rain expected — check field drainage.'**
  String get checkDrainageAdvice;

  /// No description provided for @goodSprayingConditionsAdvice.
  ///
  /// In en, this message translates to:
  /// **'No rain expected — safe to spray today.'**
  String get goodSprayingConditionsAdvice;

  /// No description provided for @hotDayAdvice.
  ///
  /// In en, this message translates to:
  /// **'Hot day — irrigate during cooler hours if needed.'**
  String get hotDayAdvice;

  /// No description provided for @addMandiPrice.
  ///
  /// In en, this message translates to:
  /// **'Add Price'**
  String get addMandiPrice;

  /// No description provided for @commodityLabel.
  ///
  /// In en, this message translates to:
  /// **'Commodity'**
  String get commodityLabel;

  /// No description provided for @marketLabel.
  ///
  /// In en, this message translates to:
  /// **'Market (optional)'**
  String get marketLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @noMandiPricesMessage.
  ///
  /// In en, this message translates to:
  /// **'No prices logged yet. Add prices you see at the mandi to track trends over time.'**
  String get noMandiPricesMessage;

  /// No description provided for @mandiManualTrackingNote.
  ///
  /// In en, this message translates to:
  /// **'Live mandi feeds aren\'t connected yet — track prices you observe manually.'**
  String get mandiManualTrackingNote;

  /// No description provided for @previousPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous: ₹{price}'**
  String previousPriceLabel(String price);

  /// No description provided for @aiAssistantHint.
  ///
  /// In en, this message translates to:
  /// **'Ask a question about your farm'**
  String get aiAssistantHint;

  /// No description provided for @aiAssistantSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get aiAssistantSend;

  /// No description provided for @aiNotConfiguredMessage.
  ///
  /// In en, this message translates to:
  /// **'The AI assistant needs a Firebase Cloud Function to answer safely — this will connect once that\'s set up. For now, your question is saved so you don\'t lose it.'**
  String get aiNotConfiguredMessage;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get checkInTitle;

  /// No description provided for @checkInPromptGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get checkInPromptGood;

  /// No description provided for @checkInPromptAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get checkInPromptAttention;

  /// No description provided for @checkInPromptProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get checkInPromptProblem;

  /// No description provided for @checkInWhatDidYouNotice.
  ///
  /// In en, this message translates to:
  /// **'What did you notice?'**
  String get checkInWhatDidYouNotice;

  /// No description provided for @concernPest.
  ///
  /// In en, this message translates to:
  /// **'Pest'**
  String get concernPest;

  /// No description provided for @concernLeafChange.
  ///
  /// In en, this message translates to:
  /// **'Leaf change'**
  String get concernLeafChange;

  /// No description provided for @concernWaterStress.
  ///
  /// In en, this message translates to:
  /// **'Water stress'**
  String get concernWaterStress;

  /// No description provided for @concernDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get concernDisease;

  /// No description provided for @concernOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get concernOther;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @checkInSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved'**
  String get checkInSavedMessage;

  /// No description provided for @alreadyCheckedInMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already checked in today'**
  String get alreadyCheckedInMessage;

  /// No description provided for @changeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeCheckIn;

  /// No description provided for @syncStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatusTitle;

  /// No description provided for @syncPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing waiting} =1{1 record waiting to sync} other{{count} records waiting to sync}}'**
  String syncPendingLabel(int count);

  /// No description provided for @syncNotConnectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your data is safely saved on this device. Online sync isn\'t connected yet.'**
  String get syncNotConnectedMessage;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orDivider;

  /// No description provided for @dashboardTagline.
  ///
  /// In en, this message translates to:
  /// **'Keep farming, keep growing!'**
  String get dashboardTagline;

  /// No description provided for @rainAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Rain Alert'**
  String get rainAlertTitle;

  /// No description provided for @activeCropLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Crop'**
  String get activeCropLabel;

  /// No description provided for @tasksCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String tasksCountLabel(int count);

  /// No description provided for @irrigationNormalStatus.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get irrigationNormalStatus;

  /// No description provided for @irrigationDueStatus.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get irrigationDueStatus;

  /// No description provided for @noDataDash.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get noDataDash;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @invalidPhoneNumberMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get invalidPhoneNumberMessage;

  /// No description provided for @weatherConditionClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherConditionClear;

  /// No description provided for @weatherConditionCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherConditionCloudy;

  /// No description provided for @weatherConditionFog.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherConditionFog;

  /// No description provided for @weatherConditionRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherConditionRain;

  /// No description provided for @weatherConditionStorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherConditionStorm;

  /// No description provided for @weatherConditionSnow.
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get weatherConditionSnow;

  /// No description provided for @liveMandiPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Mandi Prices'**
  String get liveMandiPricesTitle;

  /// No description provided for @liveMandiSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: Agmarknet (data.gov.in)'**
  String get liveMandiSourceLabel;

  /// No description provided for @modalPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Modal: ₹{price}'**
  String modalPriceLabel(String price);

  /// No description provided for @yourTrackedPricesLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Tracked Prices'**
  String get yourTrackedPricesLabel;

  /// No description provided for @perQuintalLabel.
  ///
  /// In en, this message translates to:
  /// **'per quintal'**
  String get perQuintalLabel;

  /// No description provided for @lastIrrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Last Irrigation'**
  String get lastIrrigationTitle;

  /// No description provided for @suggestedNextIrrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested Next Irrigation'**
  String get suggestedNextIrrigationTitle;

  /// No description provided for @irrigationHistoryNeededMessage.
  ///
  /// In en, this message translates to:
  /// **'Log a couple more irrigations to see a suggested schedule'**
  String get irrigationHistoryNeededMessage;

  /// No description provided for @irrigationHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation History'**
  String get irrigationHistoryTitle;

  /// No description provided for @daysAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} =1{1 day ago} other{{days} days ago}}'**
  String daysAgoLabel(int days);

  /// No description provided for @inDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} =1{Tomorrow} other{In {days} days}}'**
  String inDaysLabel(int days);

  /// No description provided for @minutesUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesUnitLabel;

  /// No description provided for @checkInNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your note...'**
  String get checkInNoteHint;

  /// No description provided for @totalCropExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Crop Expense'**
  String get totalCropExpenseLabel;

  /// No description provided for @thisMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonthLabel;

  /// No description provided for @thisSeasonLabel.
  ///
  /// In en, this message translates to:
  /// **'This Season'**
  String get thisSeasonLabel;

  /// No description provided for @recentExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Expenses'**
  String get recentExpensesLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
