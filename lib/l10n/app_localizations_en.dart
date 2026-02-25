// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Novda';

  @override
  String get continueButton => 'Continue';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get onboardingTitle1 => 'Track baby\'s daily activities';

  @override
  String get onboardingDescription1 =>
      'Log feedings, sleep, diapers, and more in one simple dashboard to stay organized every day.';

  @override
  String get onboardingTitle2 => 'Set reminders';

  @override
  String get onboardingDescription2 =>
      'Never forget a feeding or medicine, get helpful notifications right when you need them.';

  @override
  String get onboardingTitle3 => 'Track Baby\'s Progress';

  @override
  String get onboardingDescription3 =>
      'Follow your baby\'s growth, routines, and celebrate every small achievement.';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get today => 'Today';

  @override
  String get medication => 'Medication';

  @override
  String get other => 'Other';

  @override
  String get errorWrongFormat => 'You entered the wrong format';

  @override
  String get errorWrongCode => 'Wrong code is entered';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get phoneNumberHint => 'Phone number';

  @override
  String get receiveCodeDescription => 'You will receive a 6-digit code.';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsAcceptance =>
      'By clicking \'Continue\' button you accept our';

  @override
  String get termsCheckboxAcceptance =>
      'By checking this box, you agree to our';

  @override
  String get and => 'and';

  @override
  String get enterVerificationCode => 'Enter the verification code';

  @override
  String get codeSentTo => 'We sent a 6-digit code to';

  @override
  String get resendCode => 'Resend code';

  @override
  String get sendAgainAfter => 'Send again after';

  @override
  String get whoIsYourBaby => 'Who\'s your baby?';

  @override
  String get selectBabyGender => 'Select your baby\'s gender';

  @override
  String get boy => 'Boy';

  @override
  String get girl => 'Girl';

  @override
  String get appTheme => 'App theme';

  @override
  String get autoWarm => 'Auto (warm)';

  @override
  String get warm => 'Warm';

  @override
  String get cold => 'Cold';

  @override
  String get babyNameQuestion => 'What\'s your baby\'s name?';

  @override
  String get enterBabyName => 'Enter your little one\'s full name';

  @override
  String get babyNameHint => 'Baby\'s name';

  @override
  String get babyBirthdateQuestion => 'When was your baby born?';

  @override
  String get enterBabyBirthdate => 'Enter your baby\'s birthdate';

  @override
  String get day => 'Day';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get babyWeightQuestion => 'What\'s your baby\'s weight?';

  @override
  String get enterWeightKg => 'Enter the weight in kilograms.';

  @override
  String get weightInKg => 'Weight in kg';

  @override
  String get babyHeightQuestion => 'What\'s your baby\'s height?';

  @override
  String get enterHeightCm => 'Enter the height in centimeters.';

  @override
  String get heightInCm => 'Height in cm';

  @override
  String get welcomeHome => 'Welcome Home';

  @override
  String get homeDescription => 'Your baby tracking dashboard will appear here';

  @override
  String get yourChildren => 'Your children';

  @override
  String get whichChildToSelect => 'Which one do you select';

  @override
  String get addAChild => 'Add a child';

  @override
  String get homeMyChild => 'My child';

  @override
  String get homeEditDetails => 'Edit details';

  @override
  String get homeNoActiveChildSelected => 'No active child selected.';

  @override
  String get homeGender => 'Gender';

  @override
  String get homeUndisclosed => 'Undisclosed';

  @override
  String get homeActivities => 'Activities';

  @override
  String get homeActivityHistory => 'Activity history';

  @override
  String get homeReminders => 'Reminders';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeAddReminder => 'Add reminder';

  @override
  String get addActionSheetTitle => 'Add new item';

  @override
  String get addActionSheetDescription =>
      'Log an activity or create a reminder for later.';

  @override
  String get addActionTypeActivity => 'Activity';

  @override
  String get addActionTypeReminder => 'Reminder';

  @override
  String addActivityTitle(Object activity) {
    return 'Add $activity';
  }

  @override
  String get addActivityStartTime => 'Start time';

  @override
  String get addActivityEndTime => 'End time';

  @override
  String get addActivityQuality => 'Quality';

  @override
  String get addActivityQualityGood => 'Good';

  @override
  String get addActivityQualityNormal => 'Normal';

  @override
  String get addActivityQualityBad => 'Bad';

  @override
  String get addActivityReminders => 'Activity reminders';

  @override
  String get addActivityComments => 'Comments';

  @override
  String get addActivitySubmit => 'Add activity';

  @override
  String get addActivitySave => 'Save';

  @override
  String get addActivityAmountMl => 'Amount in ml';

  @override
  String get addActivityValidationAmount => 'Enter a valid amount in ml';

  @override
  String get addActivityFeedingBreast => 'Breast';

  @override
  String get addActivityFeedingBottle => 'Bottle';

  @override
  String get addActivitySelectReminders => 'Select reminders';

  @override
  String get addActivityNoReminders =>
      'No pending reminders for this activity.';

  @override
  String get addActivityNoChildSelected =>
      'Please add/select a child to create an activity.';

  @override
  String get addActivityCreated => 'Activity added successfully.';

  @override
  String addActivitySelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get addActivityConditions => 'Conditions';

  @override
  String get addActivityNoConditions => 'No condition types available.';

  @override
  String addActivityConditionsCount(int count) {
    return '$count selected';
  }

  @override
  String get homeNoActivityTypes => 'No activity types available yet.';

  @override
  String get activityHistoryNoActivities => 'No activities yet.';

  @override
  String get homeNoReminders => 'No reminders yet.';

  @override
  String get homeComingSoon => 'Coming soon';

  @override
  String get homeFailedLoad => 'Failed to load home data.';

  @override
  String get homeRetry => 'Retry';

  @override
  String get homeTomorrow => 'Tomorrow';

  @override
  String get homeYesterday => 'Yesterday';

  @override
  String get homeTab => 'Home';

  @override
  String get progressTab => 'Progress';

  @override
  String get progressCalendar => 'Calendar';

  @override
  String get progressNoChildSelected => 'Select a child to view progress.';

  @override
  String get progressFailedLoad => 'Failed to load progress data.';

  @override
  String get progressDefaultCallout => 'Your baby is growing every day.';

  @override
  String progressWeekNumber(int number) {
    return 'Week $number';
  }

  @override
  String progressMonthNumber(int number) {
    return 'Month $number';
  }

  @override
  String progressYearNumber(int number) {
    return 'Year $number';
  }

  @override
  String progressPeriodNumber(int number) {
    return 'Period $number';
  }

  @override
  String progressWhatHappensIn(Object period) {
    return 'What happens in $period?';
  }

  @override
  String get progressNoDetails => 'No progress details for this period.';

  @override
  String get progressExercisesTitle => 'Exercises to do this period';

  @override
  String get progressNoExercises => 'No exercises available yet.';

  @override
  String progressSuggestionsTitle(Object name) {
    return 'Suggestions for $name';
  }

  @override
  String get progressNoSuggestions => 'No suggestions available yet.';

  @override
  String progressRecommendationsTitle(Object name) {
    return 'Recommended for $name';
  }

  @override
  String get progressNoRecommendations => 'No recommendations available yet.';

  @override
  String progressDayRange(int start, int end) {
    return 'Day $start - $end';
  }

  @override
  String progressItemFallback(int index) {
    return 'Item $index';
  }

  @override
  String get addTab => 'Add';

  @override
  String get learnTab => 'Learn';

  @override
  String get learnSearchHint => 'Search articles';

  @override
  String get learnPopularTopics => 'Popular topics';

  @override
  String get learnAllArticles => 'All articles';

  @override
  String get learnNoArticles => 'No articles found.';

  @override
  String get learnFailedLoad => 'Failed to load articles.';

  @override
  String learnTopicArticlesCount(int count) {
    return '$count articles';
  }

  @override
  String learnReadMeta(int minutes, Object views) {
    return '$minutes min read • $views views';
  }

  @override
  String get articleHelpfulQuestion => 'Was this article helpful for you?';

  @override
  String get profileTab => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileParent => 'Parent';

  @override
  String get profileMyBabies => 'My babies';

  @override
  String get profileAdd => 'Add';

  @override
  String get profileSavedArticles => 'Saved articles';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileChangePhoneNumber => 'Change phone number';

  @override
  String get profileFollowUs => 'Follow us';

  @override
  String get profileSupport => 'Support';

  @override
  String get profileLegalDocuments => 'Legal documents';

  @override
  String get profileLogoutConfirmTitle => 'Log out?';

  @override
  String get profileLogoutConfirmDescription =>
      'You\'ll need to log in again to access your account.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppTheme => 'App theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsSelectLanguage => 'Select language';

  @override
  String get settingsThemeWarm => 'Warm';

  @override
  String get settingsThemeCalm => 'Calm';

  @override
  String get settingsThemeAutoWarm => 'Auto (warm)';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountTitle => 'Delete account?';

  @override
  String get settingsDeleteAccountDescription =>
      'All your data will be permanently removed.';

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsDelete => 'Delete';

  @override
  String get homeLogOut => 'Log out';

  @override
  String homeReminderTitle(Object activity) {
    return '$activity reminder';
  }

  @override
  String homeTabPlaceholder(Object tab) {
    return '$tab tab';
  }
}
