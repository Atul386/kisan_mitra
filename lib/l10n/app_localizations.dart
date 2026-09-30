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
  /// **'Add photo'**
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
  /// **'Your farm, your companion'**
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
  /// **'Source: Mandi Price API (data.gov.in)'**
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

  /// No description provided for @seasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get seasonLabel;

  /// No description provided for @seasonKharif.
  ///
  /// In en, this message translates to:
  /// **'Kharif'**
  String get seasonKharif;

  /// No description provided for @seasonRabi.
  ///
  /// In en, this message translates to:
  /// **'Rabi'**
  String get seasonRabi;

  /// No description provided for @seasonZaid.
  ///
  /// In en, this message translates to:
  /// **'Zaid (Summer)'**
  String get seasonZaid;

  /// No description provided for @farmLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm location'**
  String get farmLocationLabel;

  /// No description provided for @mapTapToMovePin.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to move the pin to your field'**
  String get mapTapToMovePin;

  /// No description provided for @mandiAllTab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mandiAllTab;

  /// No description provided for @mandiFavouritesTab.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get mandiFavouritesTab;

  /// No description provided for @noFavouritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on a crop to add it to your favourites.'**
  String get noFavouritesMessage;

  /// No description provided for @addToFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get addToFavourite;

  /// No description provided for @removeFromFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get removeFromFavourite;

  /// No description provided for @setPriceAlert.
  ///
  /// In en, this message translates to:
  /// **'Set price alert'**
  String get setPriceAlert;

  /// No description provided for @priceAlertDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Price alert for {commodity}'**
  String priceAlertDialogTitle(String commodity);

  /// No description provided for @priceAlertTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert me when price reaches (₹)'**
  String get priceAlertTargetLabel;

  /// No description provided for @priceAlertHelp.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a notification when a price you log or a live mandi price reaches this amount.'**
  String get priceAlertHelp;

  /// No description provided for @removeAlert.
  ///
  /// In en, this message translates to:
  /// **'Remove alert'**
  String get removeAlert;

  /// No description provided for @priceAlertActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert at ₹{price}'**
  String priceAlertActiveLabel(String price);

  /// No description provided for @priceAlertNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{commodity} price alert'**
  String priceAlertNotificationTitle(String commodity);

  /// No description provided for @priceAlertNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{commodity} has reached ₹{price} — your target price.'**
  String priceAlertNotificationBody(String commodity, String price);

  /// No description provided for @suggestedQuestionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggested questions'**
  String get suggestedQuestionsLabel;

  /// No description provided for @suggestedQuestionPest.
  ///
  /// In en, this message translates to:
  /// **'Which pest is attacking my crop?'**
  String get suggestedQuestionPest;

  /// No description provided for @suggestedQuestionFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Which fertilizer should I use now?'**
  String get suggestedQuestionFertilizer;

  /// No description provided for @suggestedQuestionIrrigation.
  ///
  /// In en, this message translates to:
  /// **'When should I water my crop next?'**
  String get suggestedQuestionIrrigation;

  /// No description provided for @suggestedQuestionWeather.
  ///
  /// In en, this message translates to:
  /// **'Is today\'s weather good for spraying?'**
  String get suggestedQuestionWeather;

  /// No description provided for @voiceInputTooltip.
  ///
  /// In en, this message translates to:
  /// **'Speak your question'**
  String get voiceInputTooltip;

  /// No description provided for @voiceListeningLabel.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get voiceListeningLabel;

  /// No description provided for @voiceUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice input isn\'t available on this phone. Please type your question.'**
  String get voiceUnavailableMessage;

  /// No description provided for @darkModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkModeLabel;

  /// No description provided for @dailyReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily farm plan reminder'**
  String get dailyReminderLabel;

  /// No description provided for @dailyReminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every morning at 8 AM'**
  String get dailyReminderSubtitle;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions.'**
  String get helpIntro;

  /// No description provided for @helpFaqOfflineQ.
  ///
  /// In en, this message translates to:
  /// **'Does the app work without internet?'**
  String get helpFaqOfflineQ;

  /// No description provided for @helpFaqOfflineA.
  ///
  /// In en, this message translates to:
  /// **'Yes. Tasks, expenses, logs and check-ins are saved on your phone. Weather, live mandi prices and the assistant need internet.'**
  String get helpFaqOfflineA;

  /// No description provided for @helpFaqTasksQ.
  ///
  /// In en, this message translates to:
  /// **'Where do today\'s tasks come from?'**
  String get helpFaqTasksQ;

  /// No description provided for @helpFaqTasksA.
  ///
  /// In en, this message translates to:
  /// **'They\'re created from your crop and its sowing date. Mark each one Done, Skip or Remind Me.'**
  String get helpFaqTasksA;

  /// No description provided for @helpFaqLanguageQ.
  ///
  /// In en, this message translates to:
  /// **'How do I change the language?'**
  String get helpFaqLanguageQ;

  /// No description provided for @helpFaqLanguageA.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Language and pick English, हिंदी or मराठी.'**
  String get helpFaqLanguageA;

  /// No description provided for @helpFaqDataQ.
  ///
  /// In en, this message translates to:
  /// **'Is my farm data safe?'**
  String get helpFaqDataQ;

  /// No description provided for @helpFaqDataA.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on your phone. You can delete it any time from Profile → Reset app data.'**
  String get helpFaqDataA;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your profile, farms, crops, tasks, expenses and all logs from this phone. This can\'t be undone.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @resetAppDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset app data'**
  String get resetAppDataTitle;

  /// No description provided for @resetAppDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your profile, farms, crops, tasks, expenses and all logs from this phone, and starts the app fresh. This can\'t be undone.'**
  String get resetAppDataMessage;

  /// No description provided for @sevenDayForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'7-Day Forecast'**
  String get sevenDayForecastTitle;

  /// No description provided for @forecastTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get forecastTodayLabel;

  /// No description provided for @requiredFieldError.
  ///
  /// In en, this message translates to:
  /// **'Please fill this in'**
  String get requiredFieldError;

  /// No description provided for @invalidAreaError.
  ///
  /// In en, this message translates to:
  /// **'Enter the area as a number, e.g. 2.5'**
  String get invalidAreaError;

  /// No description provided for @hourlyForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Next 24 hours'**
  String get hourlyForecastTitle;

  /// No description provided for @feelsLikeLabel.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}°'**
  String feelsLikeLabel(String temp);

  /// No description provided for @weatherDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get weatherDetailsTitle;

  /// No description provided for @uvIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'UV index'**
  String get uvIndexLabel;

  /// No description provided for @sunriseLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseLabel;

  /// No description provided for @sunsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunsetLabel;

  /// No description provided for @farmAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm advice'**
  String get farmAdviceTitle;

  /// No description provided for @weatherDemoBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get weatherDemoBadge;

  /// No description provided for @weatherNoAdvice.
  ///
  /// In en, this message translates to:
  /// **'No special precautions today — a normal farm day.'**
  String get weatherNoAdvice;

  /// No description provided for @highLowLabel.
  ///
  /// In en, this message translates to:
  /// **'H {high}°  L {low}°'**
  String highLowLabel(String high, String low);

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActionsTitle;

  /// No description provided for @qaSpray.
  ///
  /// In en, this message translates to:
  /// **'Log spray'**
  String get qaSpray;

  /// No description provided for @qaExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get qaExpense;

  /// No description provided for @qaFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get qaFertilizer;

  /// No description provided for @qaIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get qaIrrigation;

  /// No description provided for @qaCropCheck.
  ///
  /// In en, this message translates to:
  /// **'Crop check'**
  String get qaCropCheck;

  /// No description provided for @farmSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your farm at a glance'**
  String get farmSummaryTitle;

  /// No description provided for @summaryArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get summaryArea;

  /// No description provided for @summaryExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get summaryExpenses;

  /// No description provided for @summaryCropDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of about {total}'**
  String summaryCropDay(int day, int total);

  /// No description provided for @summaryNoCrop.
  ///
  /// In en, this message translates to:
  /// **'Add a crop to track its progress'**
  String get summaryNoCrop;

  /// No description provided for @summaryNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get summaryNotSet;

  /// No description provided for @mandiTickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Mandi prices today'**
  String get mandiTickerTitle;

  /// No description provided for @mandiSampleCaption.
  ///
  /// In en, this message translates to:
  /// **'Sample prices'**
  String get mandiSampleCaption;

  /// No description provided for @mandiPerQuintal.
  ///
  /// In en, this message translates to:
  /// **'per quintal'**
  String get mandiPerQuintal;

  /// No description provided for @schemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Schemes for farmers'**
  String get schemesTitle;

  /// No description provided for @schemesSampleCaption.
  ///
  /// In en, this message translates to:
  /// **'Sample information'**
  String get schemesSampleCaption;

  /// No description provided for @schemePmKisanTitle.
  ///
  /// In en, this message translates to:
  /// **'PM-Kisan'**
  String get schemePmKisanTitle;

  /// No description provided for @schemePmKisanDesc.
  ///
  /// In en, this message translates to:
  /// **'₹6,000 a year in three instalments, straight to your bank account.'**
  String get schemePmKisanDesc;

  /// No description provided for @schemePmfbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop insurance (PMFBY)'**
  String get schemePmfbyTitle;

  /// No description provided for @schemePmfbyDesc.
  ///
  /// In en, this message translates to:
  /// **'Insure your crop against drought, flood and pests at a low premium.'**
  String get schemePmfbyDesc;

  /// No description provided for @schemeKccTitle.
  ///
  /// In en, this message translates to:
  /// **'Kisan Credit Card'**
  String get schemeKccTitle;

  /// No description provided for @schemeKccDesc.
  ///
  /// In en, this message translates to:
  /// **'Low-interest farm loans for seeds, fertilizer and equipment.'**
  String get schemeKccDesc;

  /// No description provided for @dailyTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Tip of the day'**
  String get dailyTipTitle;

  /// No description provided for @dailyTipBody.
  ///
  /// In en, this message translates to:
  /// **'Water early in the morning. Less water is lost to the sun and leaves dry before night, which lowers disease.'**
  String get dailyTipBody;

  /// No description provided for @navAdvisories.
  ///
  /// In en, this message translates to:
  /// **'Advisories'**
  String get navAdvisories;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @advisoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Advisories'**
  String get advisoriesTitle;

  /// No description provided for @advWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get advWeather;

  /// No description provided for @advWeatherDesc.
  ///
  /// In en, this message translates to:
  /// **'Forecast and farm advice'**
  String get advWeatherDesc;

  /// No description provided for @advCropAdvisories.
  ///
  /// In en, this message translates to:
  /// **'Crop advisories'**
  String get advCropAdvisories;

  /// No description provided for @advCropAdvisoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Crop guide and official advisories'**
  String get advCropAdvisoriesDesc;

  /// No description provided for @advSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government schemes'**
  String get advSchemes;

  /// No description provided for @advSchemesDesc.
  ///
  /// In en, this message translates to:
  /// **'Schemes that may help your farm'**
  String get advSchemesDesc;

  /// No description provided for @advInsurance.
  ///
  /// In en, this message translates to:
  /// **'Crop insurance'**
  String get advInsurance;

  /// No description provided for @advInsuranceDesc.
  ///
  /// In en, this message translates to:
  /// **'PMFBY information and official services'**
  String get advInsuranceDesc;

  /// No description provided for @advPmKisan.
  ///
  /// In en, this message translates to:
  /// **'PM-KISAN'**
  String get advPmKisan;

  /// No description provided for @advPmKisanDesc.
  ///
  /// In en, this message translates to:
  /// **'Registration, e-KYC and payment status'**
  String get advPmKisanDesc;

  /// No description provided for @officialDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This information is for guidance only. Final eligibility and decisions are made by the official government portal or department.'**
  String get officialDisclaimer;

  /// No description provided for @openOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Open official website'**
  String get openOfficialWebsite;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link. Please try again.'**
  String get couldNotOpenLink;

  /// No description provided for @callHelpline.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callHelpline;

  /// No description provided for @schemesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Government schemes'**
  String get schemesScreenTitle;

  /// No description provided for @schemeOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get schemeOverview;

  /// No description provided for @schemeEligibility.
  ///
  /// In en, this message translates to:
  /// **'Who may be eligible'**
  String get schemeEligibility;

  /// No description provided for @schemeBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get schemeBenefits;

  /// No description provided for @schemeDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents usually needed'**
  String get schemeDocuments;

  /// No description provided for @schemeDates.
  ///
  /// In en, this message translates to:
  /// **'Important dates'**
  String get schemeDates;

  /// No description provided for @schemeDatesNote.
  ///
  /// In en, this message translates to:
  /// **'Dates change every season. Check the official website for current dates.'**
  String get schemeDatesNote;

  /// No description provided for @schemeApply.
  ///
  /// In en, this message translates to:
  /// **'Apply on the official portal'**
  String get schemeApply;

  /// No description provided for @pmKisanScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'PM-KISAN'**
  String get pmKisanScreenTitle;

  /// No description provided for @pmKisanAadhaarNote.
  ///
  /// In en, this message translates to:
  /// **'You never need to enter your Aadhaar in this app. Use the official PM-KISAN website for registration, e-KYC and status.'**
  String get pmKisanAadhaarNote;

  /// No description provided for @officialServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Official services'**
  String get officialServicesTitle;

  /// No description provided for @insuranceScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop insurance (PMFBY)'**
  String get insuranceScreenTitle;

  /// No description provided for @insuranceReportNote.
  ///
  /// In en, this message translates to:
  /// **'Report crop loss within the time limit set by the scheme. Use the official helpline or portal.'**
  String get insuranceReportNote;

  /// No description provided for @cropLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop library'**
  String get cropLibraryTitle;

  /// No description provided for @cropLibrarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search crops'**
  String get cropLibrarySearchHint;

  /// No description provided for @cropLibraryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No crops match your search.\nTry another name.'**
  String get cropLibraryEmpty;

  /// No description provided for @cropLibraryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load crop information.\nPlease try again.'**
  String get cropLibraryLoadError;

  /// No description provided for @cropOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get cropOverview;

  /// No description provided for @cropSowing.
  ///
  /// In en, this message translates to:
  /// **'Sowing period'**
  String get cropSowing;

  /// No description provided for @cropSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get cropSoil;

  /// No description provided for @cropClimate.
  ///
  /// In en, this message translates to:
  /// **'Climate'**
  String get cropClimate;

  /// No description provided for @cropIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get cropIrrigation;

  /// No description provided for @cropNutrients.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get cropNutrients;

  /// No description provided for @cropPests.
  ///
  /// In en, this message translates to:
  /// **'Common pests'**
  String get cropPests;

  /// No description provided for @cropDiseases.
  ///
  /// In en, this message translates to:
  /// **'Common diseases'**
  String get cropDiseases;

  /// No description provided for @cropHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get cropHarvest;

  /// No description provided for @cropStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get cropStorage;

  /// No description provided for @cropGeneralNote.
  ///
  /// In en, this message translates to:
  /// **'General guidance only. Check with your local Krishi Vigyan Kendra or agriculture department before acting on pests, diseases or nutrients.'**
  String get cropGeneralNote;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @profitTitle.
  ///
  /// In en, this message translates to:
  /// **'Profit calculator'**
  String get profitTitle;

  /// No description provided for @estimateOnly.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATE ONLY'**
  String get estimateOnly;

  /// No description provided for @estimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a rough estimate from the numbers you enter. Real income depends on yield, market price and costs, and is not guaranteed.'**
  String get estimateDisclaimer;

  /// No description provided for @profitCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop (optional)'**
  String get profitCrop;

  /// No description provided for @profitArea.
  ///
  /// In en, this message translates to:
  /// **'Area (acres)'**
  String get profitArea;

  /// No description provided for @profitYield.
  ///
  /// In en, this message translates to:
  /// **'Expected yield per acre (quintal)'**
  String get profitYield;

  /// No description provided for @profitPrice.
  ///
  /// In en, this message translates to:
  /// **'Expected price (₹ per quintal)'**
  String get profitPrice;

  /// No description provided for @costSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed cost (₹)'**
  String get costSeed;

  /// No description provided for @costFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer cost (₹)'**
  String get costFertilizer;

  /// No description provided for @costLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour cost (₹)'**
  String get costLabour;

  /// No description provided for @costIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation cost (₹)'**
  String get costIrrigation;

  /// No description provided for @costTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport cost (₹)'**
  String get costTransport;

  /// No description provided for @costOther.
  ///
  /// In en, this message translates to:
  /// **'Other costs (₹)'**
  String get costOther;

  /// No description provided for @profitRevenue.
  ///
  /// In en, this message translates to:
  /// **'Estimated revenue'**
  String get profitRevenue;

  /// No description provided for @profitCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated cost'**
  String get profitCost;

  /// No description provided for @profitMargin.
  ///
  /// In en, this message translates to:
  /// **'Estimated margin'**
  String get profitMargin;

  /// No description provided for @profitLossLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated loss'**
  String get profitLossLabel;

  /// No description provided for @profitCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate estimate'**
  String get profitCalculate;

  /// No description provided for @profitReset.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get profitReset;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get invalidNumber;

  /// No description provided for @profitUseSavedPrice.
  ///
  /// In en, this message translates to:
  /// **'Use my latest saved price: ₹{price}'**
  String profitUseSavedPrice(String price);

  /// No description provided for @nearbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby agriculture services'**
  String get nearbyTitle;

  /// No description provided for @nearbyIntro.
  ///
  /// In en, this message translates to:
  /// **'Opens your maps app and searches near your farm.'**
  String get nearbyIntro;

  /// No description provided for @nearbyNearFarm.
  ///
  /// In en, this message translates to:
  /// **'Searching near your farm location'**
  String get nearbyNearFarm;

  /// No description provided for @nearbyNearArea.
  ///
  /// In en, this message translates to:
  /// **'Searching near your area'**
  String get nearbyNearArea;

  /// No description provided for @nearbyApmc.
  ///
  /// In en, this message translates to:
  /// **'APMC / mandi'**
  String get nearbyApmc;

  /// No description provided for @nearbySoilLab.
  ///
  /// In en, this message translates to:
  /// **'Soil testing lab'**
  String get nearbySoilLab;

  /// No description provided for @nearbyAgriOffice.
  ///
  /// In en, this message translates to:
  /// **'Agriculture office'**
  String get nearbyAgriOffice;

  /// No description provided for @nearbySeedDealer.
  ///
  /// In en, this message translates to:
  /// **'Seed dealer'**
  String get nearbySeedDealer;

  /// No description provided for @nearbyFertilizerDealer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer dealer'**
  String get nearbyFertilizerDealer;

  /// No description provided for @nearbyEquipmentRental.
  ///
  /// In en, this message translates to:
  /// **'Equipment rental'**
  String get nearbyEquipmentRental;

  /// No description provided for @nearbyTractorRental.
  ///
  /// In en, this message translates to:
  /// **'Tractor rental'**
  String get nearbyTractorRental;

  /// No description provided for @nearbyVet.
  ///
  /// In en, this message translates to:
  /// **'Veterinary hospital'**
  String get nearbyVet;

  /// No description provided for @nearbyCsc.
  ///
  /// In en, this message translates to:
  /// **'CSC centre'**
  String get nearbyCsc;

  /// No description provided for @nearbyBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get nearbyBank;

  /// No description provided for @nearbyGovOffice.
  ///
  /// In en, this message translates to:
  /// **'Government office'**
  String get nearbyGovOffice;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @moreCropLibrary.
  ///
  /// In en, this message translates to:
  /// **'Crop library'**
  String get moreCropLibrary;

  /// No description provided for @moreProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit calculator'**
  String get moreProfit;

  /// No description provided for @moreNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby services'**
  String get moreNearby;

  /// No description provided for @moreExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get moreExpenses;

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreSettings;

  /// No description provided for @moreHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get moreHelp;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get moreAbout;

  /// No description provided for @mandiLiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Government mandi prices'**
  String get mandiLiveTitle;

  /// No description provided for @mandiReportedOn.
  ///
  /// In en, this message translates to:
  /// **'Reported {date}'**
  String mandiReportedOn(String date);

  /// No description provided for @mandiMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get mandiMin;

  /// No description provided for @mandiModal.
  ///
  /// In en, this message translates to:
  /// **'Modal'**
  String get mandiModal;

  /// No description provided for @mandiMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get mandiMax;

  /// No description provided for @mandiFilterCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get mandiFilterCrop;

  /// No description provided for @mandiFilterDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get mandiFilterDistrict;

  /// No description provided for @mandiFilterMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get mandiFilterMarket;

  /// No description provided for @mandiFilterVariety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get mandiFilterVariety;

  /// No description provided for @mandiFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get mandiFilterAll;

  /// No description provided for @mandiSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search market or variety'**
  String get mandiSearchHint;

  /// No description provided for @mandiNoPrices.
  ///
  /// In en, this message translates to:
  /// **'No mandi prices found.\nTry another market or crop.'**
  String get mandiNoPrices;

  /// No description provided for @mandiLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load prices.\nCheck your internet connection and try again.'**
  String get mandiLoadError;

  /// No description provided for @mandiOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline.\nShowing your last saved data.'**
  String get mandiOfflineBanner;

  /// No description provided for @mandiSavedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved {time}'**
  String mandiSavedOn(String time);

  /// No description provided for @mandiRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests right now. Please try again in a few minutes.'**
  String get mandiRateLimited;

  /// No description provided for @mandiUnsupportedState.
  ///
  /// In en, this message translates to:
  /// **'Live prices aren\'t available for your state yet. You can still log prices yourself.'**
  String get mandiUnsupportedState;

  /// No description provided for @mandiDataNote.
  ///
  /// In en, this message translates to:
  /// **'Prices are reported daily by markets and can be a few days old. They are not real-time auction prices.'**
  String get mandiDataNote;

  /// No description provided for @mandiSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all prices'**
  String get mandiSeeAll;

  /// No description provided for @mandiShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get mandiShowMore;

  /// No description provided for @mandiHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get mandiHistoryTitle;

  /// No description provided for @mandiHistoryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get mandiHistoryToday;

  /// No description provided for @mandiHistory7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get mandiHistory7;

  /// No description provided for @mandiHistory30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get mandiHistory30;

  /// No description provided for @mandiHistoryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Price history isn\'t available for this crop and market yet.'**
  String get mandiHistoryUnavailable;

  /// No description provided for @mandiAllMarkets.
  ///
  /// In en, this message translates to:
  /// **'All markets'**
  String get mandiAllMarkets;

  /// No description provided for @mandiHistoryStateAverage.
  ///
  /// In en, this message translates to:
  /// **'Average across {state}'**
  String mandiHistoryStateAverage(String state);

  /// No description provided for @mandiLatestReported.
  ///
  /// In en, this message translates to:
  /// **'Latest reported price'**
  String get mandiLatestReported;

  /// No description provided for @mandiReportedCaption.
  ///
  /// In en, this message translates to:
  /// **'Reported prices'**
  String get mandiReportedCaption;

  /// No description provided for @cropsTitle.
  ///
  /// In en, this message translates to:
  /// **'My crops'**
  String get cropsTitle;

  /// No description provided for @cropStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cropStatusActive;

  /// No description provided for @cropStatusHarvested.
  ///
  /// In en, this message translates to:
  /// **'Harvested'**
  String get cropStatusHarvested;

  /// No description provided for @cropStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get cropStatusCompleted;

  /// No description provided for @cropDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop details'**
  String get cropDetailTitle;

  /// No description provided for @expectedHarvestLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected harvest date'**
  String get expectedHarvestLabel;

  /// No description provided for @cropStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get cropStatusLabel;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @markHarvested.
  ///
  /// In en, this message translates to:
  /// **'Mark as harvested'**
  String get markHarvested;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markCompleted;

  /// No description provided for @markActive.
  ///
  /// In en, this message translates to:
  /// **'Mark as active'**
  String get markActive;

  /// No description provided for @deleteCrop.
  ///
  /// In en, this message translates to:
  /// **'Delete crop'**
  String get deleteCrop;

  /// No description provided for @deleteCropConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this crop and stop tracking it? Its diary entries will no longer be shown.'**
  String get deleteCropConfirm;

  /// No description provided for @cropDetailCosts.
  ///
  /// In en, this message translates to:
  /// **'Expenses for this crop'**
  String get cropDetailCosts;

  /// No description provided for @cropDetailNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get cropDetailNoNotes;

  /// No description provided for @cropDiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop diary'**
  String get cropDiaryTitle;

  /// No description provided for @openCropDiary.
  ///
  /// In en, this message translates to:
  /// **'Crop diary'**
  String get openCropDiary;

  /// No description provided for @diaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activities yet.\nTap + to record what you did today.'**
  String get diaryEmpty;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get addActivity;

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get editActivity;

  /// No description provided for @activitySowing.
  ///
  /// In en, this message translates to:
  /// **'Sowing'**
  String get activitySowing;

  /// No description provided for @activityIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get activityIrrigation;

  /// No description provided for @activityFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get activityFertilizer;

  /// No description provided for @activitySpray.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get activitySpray;

  /// No description provided for @activityPestObservation.
  ///
  /// In en, this message translates to:
  /// **'Pest observation'**
  String get activityPestObservation;

  /// No description provided for @activityDiseaseObservation.
  ///
  /// In en, this message translates to:
  /// **'Disease observation'**
  String get activityDiseaseObservation;

  /// No description provided for @activityLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get activityLabour;

  /// No description provided for @activityHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get activityHarvest;

  /// No description provided for @activitySale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get activitySale;

  /// No description provided for @activityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get activityOther;

  /// No description provided for @activityTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get activityTypeLabel;

  /// No description provided for @activityDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get activityDateLabel;

  /// No description provided for @activityNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get activityNotesHint;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @deleteActivityConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this diary entry?'**
  String get deleteActivityConfirm;

  /// No description provided for @noCropsYet.
  ///
  /// In en, this message translates to:
  /// **'No crops yet. Add your first crop to start a diary.'**
  String get noCropsYet;

  /// No description provided for @activitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} activities'**
  String activitiesCount(int count);

  /// No description provided for @galleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryLabel;

  /// No description provided for @editFarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit farm'**
  String get editFarmTitle;

  /// No description provided for @waterSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Water source (optional)'**
  String get waterSourceLabel;

  /// No description provided for @farmDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm details'**
  String get farmDetailsTitle;

  /// No description provided for @deleteFarm.
  ///
  /// In en, this message translates to:
  /// **'Delete farm'**
  String get deleteFarm;

  /// No description provided for @deleteFarmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this farm? Its crops and records will no longer be shown.'**
  String get deleteFarmConfirm;

  /// No description provided for @useThisFarm.
  ///
  /// In en, this message translates to:
  /// **'Use this farm'**
  String get useThisFarm;

  /// No description provided for @activeFarmBadge.
  ///
  /// In en, this message translates to:
  /// **'Active farm'**
  String get activeFarmBadge;

  /// No description provided for @farmCropsTitle.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get farmCropsTitle;

  /// No description provided for @farmToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm tools'**
  String get farmToolsTitle;

  /// No description provided for @toolDiary.
  ///
  /// In en, this message translates to:
  /// **'Crop diary'**
  String get toolDiary;

  /// No description provided for @toolExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get toolExpenses;

  /// No description provided for @toolProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit calculator'**
  String get toolProfit;

  /// No description provided for @toolDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get toolDocuments;

  /// No description provided for @toolSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil health'**
  String get toolSoil;

  /// No description provided for @toolReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get toolReminders;

  /// No description provided for @noFarmsYet.
  ///
  /// In en, this message translates to:
  /// **'Add your first farm to get started.'**
  String get noFarmsYet;

  /// No description provided for @farmAreaLine.
  ///
  /// In en, this message translates to:
  /// **'{area} {unit}'**
  String farmAreaLine(String area, String unit);

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @reminderNew.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get reminderNew;

  /// No description provided for @reminderEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get reminderEdit;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.\nTap + to add one.'**
  String get remindersEmpty;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get remindersUpcoming;

  /// No description provided for @remindersCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get remindersCompleted;

  /// No description provided for @reminderTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you need to do?'**
  String get reminderTitleLabel;

  /// No description provided for @reminderCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reminderCategoryLabel;

  /// No description provided for @reminderDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get reminderDateLabel;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTimeLabel;

  /// No description provided for @reminderRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get reminderRepeatLabel;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @reminderCatIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get reminderCatIrrigation;

  /// No description provided for @reminderCatFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get reminderCatFertilizer;

  /// No description provided for @reminderCatSpray.
  ///
  /// In en, this message translates to:
  /// **'Spray'**
  String get reminderCatSpray;

  /// No description provided for @reminderCatInspection.
  ///
  /// In en, this message translates to:
  /// **'Crop inspection'**
  String get reminderCatInspection;

  /// No description provided for @reminderCatHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get reminderCatHarvest;

  /// No description provided for @reminderCatLabour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get reminderCatLabour;

  /// No description provided for @reminderCatEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment maintenance'**
  String get reminderCatEquipment;

  /// No description provided for @reminderCatGovernmentDeadline.
  ///
  /// In en, this message translates to:
  /// **'Government deadline'**
  String get reminderCatGovernmentDeadline;

  /// No description provided for @reminderCatInsuranceDeadline.
  ///
  /// In en, this message translates to:
  /// **'Insurance deadline'**
  String get reminderCatInsuranceDeadline;

  /// No description provided for @reminderCatCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reminderCatCustom;

  /// No description provided for @reminderDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this reminder?'**
  String get reminderDeleteConfirm;

  /// No description provided for @reminderPastTime.
  ///
  /// In en, this message translates to:
  /// **'Pick a time in the future'**
  String get reminderPastTime;

  /// No description provided for @reminderMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get reminderMarkDone;

  /// No description provided for @reminderMarkNotDone.
  ///
  /// In en, this message translates to:
  /// **'Mark not done'**
  String get reminderMarkNotDone;

  /// No description provided for @reminderRepeatsEvery.
  ///
  /// In en, this message translates to:
  /// **'Repeats: {rule}'**
  String reminderRepeatsEvery(String rule);

  /// No description provided for @todayRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reminders'**
  String get todayRemindersTitle;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My documents'**
  String get documentsTitle;

  /// No description provided for @docCat712.
  ///
  /// In en, this message translates to:
  /// **'7/12 Extract'**
  String get docCat712;

  /// No description provided for @docCat8a.
  ///
  /// In en, this message translates to:
  /// **'8A Extract'**
  String get docCat8a;

  /// No description provided for @docCatSoil.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Card'**
  String get docCatSoil;

  /// No description provided for @docCatInsurance.
  ///
  /// In en, this message translates to:
  /// **'Crop Insurance'**
  String get docCatInsurance;

  /// No description provided for @docCatBank.
  ///
  /// In en, this message translates to:
  /// **'Bank Documents'**
  String get docCatBank;

  /// No description provided for @docCatPmKisan.
  ///
  /// In en, this message translates to:
  /// **'PM-KISAN'**
  String get docCatPmKisan;

  /// No description provided for @docCatMahadbt.
  ///
  /// In en, this message translates to:
  /// **'MahaDBT'**
  String get docCatMahadbt;

  /// No description provided for @docCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docCatOther;

  /// No description provided for @documentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No documents yet.\nKeep your 7/12, 8A and insurance papers here.'**
  String get documentsEmpty;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// No description provided for @documentTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get documentTitleLabel;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF or photo'**
  String get chooseFile;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @noFileChosen.
  ///
  /// In en, this message translates to:
  /// **'No file chosen'**
  String get noFileChosen;

  /// No description provided for @docUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Only PDF, JPG and PNG files are allowed.'**
  String get docUnsupported;

  /// No description provided for @docTooLarge.
  ///
  /// In en, this message translates to:
  /// **'This file is larger than 10 MB. Please choose a smaller one.'**
  String get docTooLarge;

  /// No description provided for @docEmptyFile.
  ///
  /// In en, this message translates to:
  /// **'This file is empty.'**
  String get docEmptyFile;

  /// No description provided for @docSavedOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone'**
  String get docSavedOnPhone;

  /// No description provided for @docBackedUp.
  ///
  /// In en, this message translates to:
  /// **'Backed up'**
  String get docBackedUp;

  /// No description provided for @docDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this document from your phone?'**
  String get docDeleteConfirm;

  /// No description provided for @docOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file.'**
  String get docOpenFailed;

  /// No description provided for @docPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your documents are kept privately on this phone.'**
  String get docPrivacyNote;

  /// No description provided for @soilTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil health'**
  String get soilTitle;

  /// No description provided for @soilEmpty.
  ///
  /// In en, this message translates to:
  /// **'No soil tests yet.\nAdd values from your lab report or Soil Health Card.'**
  String get soilEmpty;

  /// No description provided for @soilAdd.
  ///
  /// In en, this message translates to:
  /// **'Add soil test'**
  String get soilAdd;

  /// No description provided for @soilPh.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get soilPh;

  /// No description provided for @soilNitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen, N (kg/ha)'**
  String get soilNitrogen;

  /// No description provided for @soilPhosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus, P (kg/ha)'**
  String get soilPhosphorus;

  /// No description provided for @soilPotassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium, K (kg/ha)'**
  String get soilPotassium;

  /// No description provided for @soilOrganicCarbon.
  ///
  /// In en, this message translates to:
  /// **'Organic carbon (%)'**
  String get soilOrganicCarbon;

  /// No description provided for @soilOther.
  ///
  /// In en, this message translates to:
  /// **'Other nutrients (optional)'**
  String get soilOther;

  /// No description provided for @soilOtherHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Zinc 0.6 ppm, Sulphur 12 ppm'**
  String get soilOtherHint;

  /// No description provided for @soilDate.
  ///
  /// In en, this message translates to:
  /// **'Test date'**
  String get soilDate;

  /// No description provided for @soilAttachCard.
  ///
  /// In en, this message translates to:
  /// **'Attach Soil Health Card'**
  String get soilAttachCard;

  /// No description provided for @soilCardAttached.
  ///
  /// In en, this message translates to:
  /// **'Card attached'**
  String get soilCardAttached;

  /// No description provided for @soilViewCard.
  ///
  /// In en, this message translates to:
  /// **'View card'**
  String get soilViewCard;

  /// No description provided for @soilAdviceNote.
  ///
  /// In en, this message translates to:
  /// **'These are the values you entered. Ask your local Krishi Vigyan Kendra or agriculture officer what they mean for fertilizer. This app does not prescribe fertilizer amounts.'**
  String get soilAdviceNote;

  /// No description provided for @soilValueRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}'**
  String soilValueRange(String min, String max);

  /// No description provided for @soilNeedOneValue.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one value'**
  String get soilNeedOneValue;

  /// No description provided for @soilDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this soil test?'**
  String get soilDeleteConfirm;

  /// No description provided for @docBackUp.
  ///
  /// In en, this message translates to:
  /// **'Back up to cloud'**
  String get docBackUp;

  /// No description provided for @docBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t back up this document. Check your internet connection and try again.'**
  String get docBackupFailed;

  /// No description provided for @pushSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushSectionTitle;

  /// No description provided for @pushWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather alerts'**
  String get pushWeather;

  /// No description provided for @pushMandi.
  ///
  /// In en, this message translates to:
  /// **'Mandi price alerts'**
  String get pushMandi;

  /// No description provided for @pushGovt.
  ///
  /// In en, this message translates to:
  /// **'Government updates'**
  String get pushGovt;

  /// No description provided for @pushNote.
  ///
  /// In en, this message translates to:
  /// **'Only important alerts. Turn off any you don\'t want.'**
  String get pushNote;

  /// No description provided for @nearbyMandisTitle.
  ///
  /// In en, this message translates to:
  /// **'Mandis near you'**
  String get nearbyMandisTitle;

  /// No description provided for @nearbyMandisInDistrict.
  ///
  /// In en, this message translates to:
  /// **'In {district}'**
  String nearbyMandisInDistrict(String district);

  /// No description provided for @nearbyMandisOtherDistricts.
  ///
  /// In en, this message translates to:
  /// **'Other districts'**
  String get nearbyMandisOtherDistricts;

  /// No description provided for @nearbyMandisPickDistrict.
  ///
  /// In en, this message translates to:
  /// **'Choose your district'**
  String get nearbyMandisPickDistrict;

  /// No description provided for @nearbyMandisNote.
  ///
  /// In en, this message translates to:
  /// **'Markets are grouped by district. Distances aren\'t shown because the price data has no map locations.'**
  String get nearbyMandisNote;

  /// No description provided for @nearbyMandisNoneInDistrict.
  ///
  /// In en, this message translates to:
  /// **'No mandis listed in {district}. See other districts below.'**
  String nearbyMandisNoneInDistrict(String district);

  /// No description provided for @nearbyMandisDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get nearbyMandisDirections;

  /// No description provided for @nearbyMandisPrices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get nearbyMandisPrices;

  /// No description provided for @nearbyMandisDistrictLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get nearbyMandisDistrictLabel;

  /// No description provided for @talukaLabel.
  ///
  /// In en, this message translates to:
  /// **'Taluka (optional)'**
  String get talukaLabel;

  /// No description provided for @rainfallLabel.
  ///
  /// In en, this message translates to:
  /// **'Rainfall today'**
  String get rainfallLabel;

  /// No description provided for @showSixteenDays.
  ///
  /// In en, this message translates to:
  /// **'Show 16 days'**
  String get showSixteenDays;

  /// No description provided for @showFewerDays.
  ///
  /// In en, this message translates to:
  /// **'Show fewer days'**
  String get showFewerDays;

  /// No description provided for @sixteenDayForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'16-Day Forecast'**
  String get sixteenDayForecastTitle;

  /// No description provided for @schemesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search schemes'**
  String get schemesSearchHint;

  /// No description provided for @schemesNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No schemes match your search.\nTry another word.'**
  String get schemesNoMatch;

  /// No description provided for @soilFindLabs.
  ///
  /// In en, this message translates to:
  /// **'Find nearby soil testing labs'**
  String get soilFindLabs;

  /// No description provided for @reminderCropLabel.
  ///
  /// In en, this message translates to:
  /// **'Crop (optional)'**
  String get reminderCropLabel;

  /// No description provided for @reminderNoCrop.
  ///
  /// In en, this message translates to:
  /// **'No specific crop'**
  String get reminderNoCrop;

  /// No description provided for @reminderNotifyLabel.
  ///
  /// In en, this message translates to:
  /// **'Send me a notification'**
  String get reminderNotifyLabel;

  /// No description provided for @reminderNotifyOff.
  ///
  /// In en, this message translates to:
  /// **'Notification off'**
  String get reminderNotifyOff;

  /// No description provided for @activityCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost (₹, optional)'**
  String get activityCostLabel;
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
