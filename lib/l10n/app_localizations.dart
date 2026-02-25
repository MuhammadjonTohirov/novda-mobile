import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

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
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Novda'**
  String get appName;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track baby\'s daily activities'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Log feedings, sleep, diapers, and more in one simple dashboard to stay organized every day.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Set reminders'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Never forget a feeding or medicine, get helpful notifications right when you need them.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track Baby\'s Progress'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Follow your baby\'s growth, routines, and celebrate every small achievement.'**
  String get onboardingDescription3;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @errorWrongFormat.
  ///
  /// In en, this message translates to:
  /// **'You entered the wrong format'**
  String get errorWrongFormat;

  /// No description provided for @errorWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code is entered'**
  String get errorWrongCode;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberHint;

  /// No description provided for @receiveCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'You will receive a 6-digit code.'**
  String get receiveCodeDescription;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsAcceptance.
  ///
  /// In en, this message translates to:
  /// **'By clicking \'Continue\' button you accept our'**
  String get termsAcceptance;

  /// No description provided for @termsCheckboxAcceptance.
  ///
  /// In en, this message translates to:
  /// **'By checking this box, you agree to our'**
  String get termsCheckboxAcceptance;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get enterVerificationCode;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to'**
  String get codeSentTo;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @sendAgainAfter.
  ///
  /// In en, this message translates to:
  /// **'Send again after'**
  String get sendAgainAfter;

  /// No description provided for @whoIsYourBaby.
  ///
  /// In en, this message translates to:
  /// **'Who\'s your baby?'**
  String get whoIsYourBaby;

  /// No description provided for @selectBabyGender.
  ///
  /// In en, this message translates to:
  /// **'Select your baby\'s gender'**
  String get selectBabyGender;

  /// No description provided for @boy.
  ///
  /// In en, this message translates to:
  /// **'Boy'**
  String get boy;

  /// No description provided for @girl.
  ///
  /// In en, this message translates to:
  /// **'Girl'**
  String get girl;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get appTheme;

  /// No description provided for @autoWarm.
  ///
  /// In en, this message translates to:
  /// **'Auto (warm)'**
  String get autoWarm;

  /// No description provided for @warm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get warm;

  /// No description provided for @cold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get cold;

  /// No description provided for @babyNameQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your baby\'s name?'**
  String get babyNameQuestion;

  /// No description provided for @enterBabyName.
  ///
  /// In en, this message translates to:
  /// **'Enter your little one\'s full name'**
  String get enterBabyName;

  /// No description provided for @babyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s name'**
  String get babyNameHint;

  /// No description provided for @babyBirthdateQuestion.
  ///
  /// In en, this message translates to:
  /// **'When was your baby born?'**
  String get babyBirthdateQuestion;

  /// No description provided for @enterBabyBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Enter your baby\'s birthdate'**
  String get enterBabyBirthdate;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @babyWeightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your baby\'s weight?'**
  String get babyWeightQuestion;

  /// No description provided for @enterWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Enter the weight in kilograms.'**
  String get enterWeightKg;

  /// No description provided for @weightInKg.
  ///
  /// In en, this message translates to:
  /// **'Weight in kg'**
  String get weightInKg;

  /// No description provided for @babyHeightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your baby\'s height?'**
  String get babyHeightQuestion;

  /// No description provided for @enterHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Enter the height in centimeters.'**
  String get enterHeightCm;

  /// No description provided for @heightInCm.
  ///
  /// In en, this message translates to:
  /// **'Height in cm'**
  String get heightInCm;

  /// No description provided for @welcomeHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Home'**
  String get welcomeHome;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Your baby tracking dashboard will appear here'**
  String get homeDescription;

  /// No description provided for @yourChildren.
  ///
  /// In en, this message translates to:
  /// **'Your children'**
  String get yourChildren;

  /// No description provided for @whichChildToSelect.
  ///
  /// In en, this message translates to:
  /// **'Which one do you select'**
  String get whichChildToSelect;

  /// No description provided for @addAChild.
  ///
  /// In en, this message translates to:
  /// **'Add a child'**
  String get addAChild;

  /// No description provided for @homeMyChild.
  ///
  /// In en, this message translates to:
  /// **'My child'**
  String get homeMyChild;

  /// No description provided for @homeEditDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get homeEditDetails;

  /// No description provided for @homeNoActiveChildSelected.
  ///
  /// In en, this message translates to:
  /// **'No active child selected.'**
  String get homeNoActiveChildSelected;

  /// No description provided for @homeGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get homeGender;

  /// No description provided for @homeUndisclosed.
  ///
  /// In en, this message translates to:
  /// **'Undisclosed'**
  String get homeUndisclosed;

  /// No description provided for @homeActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get homeActivities;

  /// No description provided for @homeActivityHistory.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get homeActivityHistory;

  /// No description provided for @homeReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get homeReminders;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeAddReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get homeAddReminder;

  /// No description provided for @addActionSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new item'**
  String get addActionSheetTitle;

  /// No description provided for @addActionSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Log an activity or create a reminder for later.'**
  String get addActionSheetDescription;

  /// No description provided for @addActionTypeActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get addActionTypeActivity;

  /// No description provided for @addActionTypeReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get addActionTypeReminder;

  /// No description provided for @addActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {activity}'**
  String addActivityTitle(Object activity);

  /// No description provided for @addActivityStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get addActivityStartTime;

  /// No description provided for @addActivityEndTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get addActivityEndTime;

  /// No description provided for @addActivityQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get addActivityQuality;

  /// No description provided for @addActivityQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get addActivityQualityGood;

  /// No description provided for @addActivityQualityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get addActivityQualityNormal;

  /// No description provided for @addActivityQualityBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get addActivityQualityBad;

  /// No description provided for @addActivityReminders.
  ///
  /// In en, this message translates to:
  /// **'Activity reminders'**
  String get addActivityReminders;

  /// No description provided for @addActivityComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get addActivityComments;

  /// No description provided for @addActivitySubmit.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get addActivitySubmit;

  /// No description provided for @addActivitySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get addActivitySave;

  /// No description provided for @addActivityAmountMl.
  ///
  /// In en, this message translates to:
  /// **'Amount in ml'**
  String get addActivityAmountMl;

  /// No description provided for @addActivityValidationAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount in ml'**
  String get addActivityValidationAmount;

  /// No description provided for @addActivityFeedingBreast.
  ///
  /// In en, this message translates to:
  /// **'Breast'**
  String get addActivityFeedingBreast;

  /// No description provided for @addActivityFeedingBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get addActivityFeedingBottle;

  /// No description provided for @addActivitySelectReminders.
  ///
  /// In en, this message translates to:
  /// **'Select reminders'**
  String get addActivitySelectReminders;

  /// No description provided for @addActivityNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No pending reminders for this activity.'**
  String get addActivityNoReminders;

  /// No description provided for @addActivityNoChildSelected.
  ///
  /// In en, this message translates to:
  /// **'Please add/select a child to create an activity.'**
  String get addActivityNoChildSelected;

  /// No description provided for @addActivityCreated.
  ///
  /// In en, this message translates to:
  /// **'Activity added successfully.'**
  String get addActivityCreated;

  /// No description provided for @addActivitySelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String addActivitySelectedCount(int count);

  /// No description provided for @addActivityConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get addActivityConditions;

  /// No description provided for @addActivityNoConditions.
  ///
  /// In en, this message translates to:
  /// **'No condition types available.'**
  String get addActivityNoConditions;

  /// No description provided for @addActivityConditionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String addActivityConditionsCount(int count);

  /// No description provided for @homeNoActivityTypes.
  ///
  /// In en, this message translates to:
  /// **'No activity types available yet.'**
  String get homeNoActivityTypes;

  /// No description provided for @activityHistoryNoActivities.
  ///
  /// In en, this message translates to:
  /// **'No activities yet.'**
  String get activityHistoryNoActivities;

  /// No description provided for @homeNoReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get homeNoReminders;

  /// No description provided for @homeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get homeComingSoon;

  /// No description provided for @homeFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load home data.'**
  String get homeFailedLoad;

  /// No description provided for @homeRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get homeRetry;

  /// No description provided for @homeTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get homeTomorrow;

  /// No description provided for @homeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get homeYesterday;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @progressTab.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTab;

  /// No description provided for @progressCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get progressCalendar;

  /// No description provided for @progressNoChildSelected.
  ///
  /// In en, this message translates to:
  /// **'Select a child to view progress.'**
  String get progressNoChildSelected;

  /// No description provided for @progressFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load progress data.'**
  String get progressFailedLoad;

  /// No description provided for @progressDefaultCallout.
  ///
  /// In en, this message translates to:
  /// **'Your baby is growing every day.'**
  String get progressDefaultCallout;

  /// No description provided for @progressWeekNumber.
  ///
  /// In en, this message translates to:
  /// **'Week {number}'**
  String progressWeekNumber(int number);

  /// No description provided for @progressMonthNumber.
  ///
  /// In en, this message translates to:
  /// **'Month {number}'**
  String progressMonthNumber(int number);

  /// No description provided for @progressYearNumber.
  ///
  /// In en, this message translates to:
  /// **'Year {number}'**
  String progressYearNumber(int number);

  /// No description provided for @progressPeriodNumber.
  ///
  /// In en, this message translates to:
  /// **'Period {number}'**
  String progressPeriodNumber(int number);

  /// No description provided for @progressWhatHappensIn.
  ///
  /// In en, this message translates to:
  /// **'What happens in {period}?'**
  String progressWhatHappensIn(Object period);

  /// No description provided for @progressNoDetails.
  ///
  /// In en, this message translates to:
  /// **'No progress details for this period.'**
  String get progressNoDetails;

  /// No description provided for @progressExercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises to do this period'**
  String get progressExercisesTitle;

  /// No description provided for @progressNoExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises available yet.'**
  String get progressNoExercises;

  /// No description provided for @progressSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions for {name}'**
  String progressSuggestionsTitle(Object name);

  /// No description provided for @progressNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available yet.'**
  String get progressNoSuggestions;

  /// No description provided for @progressRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for {name}'**
  String progressRecommendationsTitle(Object name);

  /// No description provided for @progressNoRecommendations.
  ///
  /// In en, this message translates to:
  /// **'No recommendations available yet.'**
  String get progressNoRecommendations;

  /// No description provided for @progressDayRange.
  ///
  /// In en, this message translates to:
  /// **'Day {start} - {end}'**
  String progressDayRange(int start, int end);

  /// No description provided for @progressItemFallback.
  ///
  /// In en, this message translates to:
  /// **'Item {index}'**
  String progressItemFallback(int index);

  /// No description provided for @addTab.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addTab;

  /// No description provided for @learnTab.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTab;

  /// No description provided for @learnSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search articles'**
  String get learnSearchHint;

  /// No description provided for @learnPopularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular topics'**
  String get learnPopularTopics;

  /// No description provided for @learnAllTopics.
  ///
  /// In en, this message translates to:
  /// **'All topics'**
  String get learnAllTopics;

  /// No description provided for @learnAllArticles.
  ///
  /// In en, this message translates to:
  /// **'All articles'**
  String get learnAllArticles;

  /// No description provided for @learnNoArticles.
  ///
  /// In en, this message translates to:
  /// **'No articles found.'**
  String get learnNoArticles;

  /// No description provided for @learnNoTopics.
  ///
  /// In en, this message translates to:
  /// **'No topics found.'**
  String get learnNoTopics;

  /// No description provided for @learnFailedLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load articles.'**
  String get learnFailedLoad;

  /// No description provided for @learnTopicArticlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} articles'**
  String learnTopicArticlesCount(int count);

  /// No description provided for @learnReadMeta.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read • {views} views'**
  String learnReadMeta(int minutes, Object views);

  /// No description provided for @articleHelpfulQuestion.
  ///
  /// In en, this message translates to:
  /// **'Was this article helpful for you?'**
  String get articleHelpfulQuestion;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get profileParent;

  /// No description provided for @profileMyBabies.
  ///
  /// In en, this message translates to:
  /// **'My babies'**
  String get profileMyBabies;

  /// No description provided for @profileAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get profileAdd;

  /// No description provided for @profileSavedArticles.
  ///
  /// In en, this message translates to:
  /// **'Saved articles'**
  String get profileSavedArticles;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileChangePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get profileChangePhoneNumber;

  /// No description provided for @profileFollowUs.
  ///
  /// In en, this message translates to:
  /// **'Follow us'**
  String get profileFollowUs;

  /// No description provided for @profileSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSupport;

  /// No description provided for @profileLegalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Legal documents'**
  String get profileLegalDocuments;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to access your account.'**
  String get profileLogoutConfirmDescription;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppTheme.
  ///
  /// In en, this message translates to:
  /// **'App theme'**
  String get settingsAppTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsThemeWarm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get settingsThemeWarm;

  /// No description provided for @settingsThemeCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get settingsThemeCalm;

  /// No description provided for @settingsThemeAutoWarm.
  ///
  /// In en, this message translates to:
  /// **'Auto (warm)'**
  String get settingsThemeAutoWarm;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settingsDeleteAccountTitle;

  /// No description provided for @settingsDeleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'All your data will be permanently removed.'**
  String get settingsDeleteAccountDescription;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDelete;

  /// No description provided for @homeLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get homeLogOut;

  /// No description provided for @homeReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'{activity} reminder'**
  String homeReminderTitle(Object activity);

  /// No description provided for @homeTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'{tab} tab'**
  String homeTabPlaceholder(Object tab);
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
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
