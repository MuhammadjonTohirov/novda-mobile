import 'package:novda_sdk/novda_sdk.dart';

final testUser = User(
  id: 1,
  phone: '+998901234567',
  name: 'Test Parent',
  preferredLocale: PreferredLocale.en,
  themePreference: ThemePreference.auto,
  notificationsEnabled: true,
  lastActiveChild: 10,
);

final testChildListItem = ChildListItem(
  id: 10,
  name: 'Test Child',
  gender: Gender.boy,
  birthDate: DateTime(2024, 1, 15),
  ageInWeeks: 60,
  ageDisplay: '1 year 2 months',
  createdAt: DateTime(2024, 1, 15),
);

final testChild = Child(
  id: 10,
  userId: 1,
  name: 'Test Child',
  gender: Gender.boy,
  birthDate: DateTime(2024, 1, 15),
  ageInWeeks: 60,
  ageDisplay: '1 year 2 months',
  createdAt: DateTime(2024, 1, 15),
  updatedAt: DateTime(2024, 1, 15),
);

const testActivityType = ActivityType(
  id: 1,
  slug: 'sleep',
  iconUrl: '',
  color: '#4A90D9',
  hasDuration: true,
  hasQuality: true,
  isReminderEnabled: true,
  isActive: true,
  order: 1,
  title: 'Sleep',
  description: 'Track sleep',
);

final testReminder = Reminder(
  id: 100,
  child: 10,
  childName: 'Test Child',
  activityType: 1,
  activityTypeDetail: testActivityType,
  dueAt: DateTime.now().add(const Duration(hours: 1)),
  status: ReminderStatus.pending,
  statusDisplay: 'Pending',
  createdBy: 1,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
