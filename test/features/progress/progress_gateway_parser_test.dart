import 'package:flutter_test/flutter_test.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:novda_sdk/src/core/network/api_client.dart';
import 'package:novda_sdk/src/gateways/progress_gateway.dart';

class FakeApiClient implements ApiClient {
  FakeApiClient(this.response);

  final Object? response;
  String? lastPath;
  Map<String, dynamic>? lastQueryParameters;

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) async {
    lastPath = path;
    lastQueryParameters = queryParameters;

    if (fromJson != null) {
      return fromJson(response);
    }

    return response as T;
  }

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<T> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? fromJson,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void setLocale(String locale) {}
}

void main() {
  final customSuggestionsResponse = <String, dynamic>{
    'success': true,
    'code': 200,
    'message': null,
    'error': null,
    'data': {
      'child': {
        'id': 1,
        'name': 'Usmonjon.',
        'gender': 'boy',
        'age_display': '3 years 9 months',
      },
      'guide': {
        'id': 119,
        'period_unit': 'custom',
        'period_index': 4,
        'week_number': null,
        'gender_filter': 'boy',
        'stage_type': 'normal',
        'week_type': 'normal',
      },
      'suggestions': [
        {
          'id': 1,
          'order': 1,
          'title': 'Uxlash Vaqti Yordamchisi',
          'body':
              "Dush vaqti, keyin piJama tanlash. Sokin kitob o'qish. Kichik ichimlik bering, keyin chiroqlar o'chirilsin. Tartibni barqaror saqlang.",
        },
        {
          'id': 2,
          'order': 2,
          'title': 'Dori Vaqti',
          'body':
              "Dorini kichkinachi sovg'a yoki sevimli ichimlik bilan bering. Mukofotlar uchun stikerli jadvaldan foydalaning. Jarayonni ijobiy va sokin tuting.",
        },
        {
          'id': 3,
          'order': 3,
          'title': "Sokin O'yinlar",
          'body':
              "Pazllar, qurilish bloklari yoki chizish bilan harakat qiling. Yostiq va kitoblar bilan qulay burchak tashkil qiling. Uxlashdan oldin ekran vaqtini cheklang.",
        },
        {
          'id': 4,
          'order': 4,
          'title': "Sog'lom Gazak Yordamchisi",
          'body':
              "Uni 2 ta sog'lom variant (masalan, olma bo'laklari yoki yogurt) orasidan tanlashiga ruxsat bering. Laganda qiziqarli yuz yarating. Keyin suv iching.",
        },
      ],
    },
  };
  final customSharedPeriodResponse = <String, dynamic>{
    'success': true,
    'code': 200,
    'message': null,
    'error': null,
    'data': {
      'guide': {
        'id': 119,
        'period_unit': 'custom',
        'period_index': 4,
        'week_number': null,
        'gender_filter': 'boy',
        'stage_type': 'normal',
        'week_type': 'normal',
        'headline': "4-yilda nima bo'ladi?",
        'mood_expression': "Men endi ko'p narsalarni o'zim qila olaman!",
        'summary':
            "To'rt yoshli bolalar mustaqillik, tasavvur va ijtimoiy qiziquvchanlik bilan rivojlanayotir. Ular murakkab o'yin-kulgi o'ynashni yaxshi ko'radilar, dunyoni tushunish uchun cheksiz savollar beradilar va yugurish, sakrash va chizish uchun yaxshiroq muvofiqlashtirishni rivojlantirmoqdalar. Ularning so'z boyligi tez rivojlanmoqda va ular hikoyalar aytishni yaxshi ko'radilar.",
        'crisis_warning': null,
        'crisis_description': null,
      },
      'exercises': [
        {
          'id': 360,
          'order': 1,
          'title': 'Tasavvur Hikoya Aytish',
          'body':
              "Bolangizdan uy atrofidagi uchta tasodifiy narsa yordamida sizga hikoya aytishini so'rang. Ular personajlar va oddiy syujet yaratishga undang.",
        },
        {
          'id': 361,
          'order': 2,
          'title': "To'siqlar Trassasi",
          'body':
              "Yostiqlar, stullar va adyollar yordamida oddiy ichki to'siqlar trassasini yarating. Bolangizning yirik motor ko'nikmalarini rivojlantirish uchun to'siqlar ostidan emaklashiga, ustidan sakrashiga va orasidan o'tishiga imkon bering.",
        },
        {
          'id': 362,
          'order': 3,
          'title': "His-tuyg'ular Kariokalari",
          'body':
              "Turli xil his-tuyg'ularni (baxtli, g'amgin, g'azabli, hayratda) navbatma-navbat ijro eting va boshqa odam nimani his qilayotganini topishga harakat qiling. Bu hissiy so'z boyligi va hamdardlikni rivojlantirishga yordam beradi.",
        },
        {
          'id': 363,
          'order': 4,
          'title': "Qoidalar Bo'yicha Saralash",
          'body':
              "Bolangizga aralash narsalar (masalan, tugmalar, bloklar yoki o'yinchoqlar) bering va ulardan rang, o'lcham yoki turi bo'yicha turli usullarda saralashni so'rang. Bu erta mantiq va tasniflash ko'nikmalarini rivojlantirishga yordam beradi.",
        },
        {
          'id': 364,
          'order': 5,
          'title': 'Hamkorlikda Qurish',
          'body':
              "Bloklar yordamida baland minora yoki ma'lum bir konstruksiyani birgalikda qurish. Navbat bilan ishlash va rejangizni muhokama qilishni mashq qiling, jamoa ishi va muammolarni hal qilishni rivojlantiring.",
        },
      ],
    },
  };

  group('custom progress suggestions parser', () {
    test('parses payload data into child, guide, and suggestion items', () {
      final data = Map<String, dynamic>.from(
        customSuggestionsResponse['data']! as Map,
      );

      final result = ProgressChildPeriodSuggestions.fromJson(data);

      expect(result.child.id, 1);
      expect(result.child.name, 'Usmonjon.');
      expect(result.child.gender, Gender.boy);
      expect(result.child.ageDisplay, '3 years 9 months');

      expect(result.guide.periodUnit, ProgressPeriodUnit.custom);
      expect(result.guide.periodIndex, 4);
      expect(result.guide.weekNumber, isNull);
      expect(result.guide.stageType, 'normal');
      expect(result.guide.weekType, 'normal');

      expect(result.suggestions, hasLength(4));
      expect(result.suggestions.first.order, 1);
      expect(result.suggestions.first.title, 'Uxlash Vaqti Yordamchisi');
      expect(
        result.suggestions.first.description,
        contains("Sokin kitob o'qish"),
      );
      expect(result.suggestions.last.order, 4);
      expect(result.suggestions.last.title, "Sog'lom Gazak Yordamchisi");
    });

    test(
      'gateway unwraps the data envelope for v2 child suggestions',
      () async {
        final client = FakeApiClient(customSuggestionsResponse);
        final gateway = ProgressGatewayImpl(client);

        final result = await gateway.getChildPeriodSuggestions(
          childId: 1,
          periodUnit: ProgressPeriodUnit.custom,
          periodIndex: 4,
        );

        expect(
          client.lastPath,
          '/api/v2/children/1/progress/periods/custom/4/suggestions',
        );
        expect(client.lastQueryParameters, isNull);
        expect(result.child.id, 1);
        expect(result.guide.periodUnit, ProgressPeriodUnit.custom);
        expect(result.suggestions, hasLength(4));
        expect(result.suggestions[1].title, 'Dori Vaqti');
        expect(
          result.suggestions[1].description,
          contains("stikerli jadvaldan foydalaning"),
        );
      },
    );
  });

  group('custom shared progress parser', () {
    test('parses payload data into guide and exercise items', () {
      final data = Map<String, dynamic>.from(
        customSharedPeriodResponse['data']! as Map,
      );

      final result = ProgressSharedPeriodContent.fromJson(data);

      expect(result.guide.id, 119);
      expect(result.guide.periodUnit, ProgressPeriodUnit.custom);
      expect(result.guide.periodIndex, 4);
      expect(result.guide.weekNumber, isNull);
      expect(result.guide.genderFilter, ProgressGenderFilter.boy);
      expect(result.guide.stageType, 'normal');
      expect(result.guide.weekType, 'normal');
      expect(result.guide.headline, "4-yilda nima bo'ladi?");
      expect(
        result.guide.moodExpression,
        "Men endi ko'p narsalarni o'zim qila olaman!",
      );
      expect(result.guide.summary, contains("mustaqillik"));

      expect(result.exercises, hasLength(5));
      expect(result.exercises.first.order, 1);
      expect(result.exercises.first.title, 'Tasavvur Hikoya Aytish');
      expect(
        result.exercises.first.description,
        contains('uchta tasodifiy narsa yordamida'),
      );
      expect(result.exercises.last.order, 5);
      expect(result.exercises.last.title, 'Hamkorlikda Qurish');
    });

    test(
      'gateway unwraps the data envelope for v2 shared period content',
      () async {
        final client = FakeApiClient(customSharedPeriodResponse);
        final gateway = ProgressGatewayImpl(client);

        final result = await gateway.getSharedPeriodContent(
          periodUnit: ProgressPeriodUnit.custom,
          periodIndex: 4,
          gender: ProgressGenderFilter.boy,
        );

        expect(client.lastPath, '/api/v2/progress/periods/custom/4');
        expect(client.lastQueryParameters, {'gender': 'boy'});
        expect(result.guide.id, 119);
        expect(result.guide.periodUnit, ProgressPeriodUnit.custom);
        expect(result.guide.genderFilter, ProgressGenderFilter.boy);
        expect(result.guide.headline, "4-yilda nima bo'ladi?");
        expect(result.guide.moodExpression, contains("o'zim qila olaman"));
        expect(result.exercises, hasLength(5));
        expect(result.exercises[1].title, "To'siqlar Trassasi");
        expect(
          result.exercises[1].description,
          contains('yirik motor ko\'nikmalarini'),
        );
      },
    );
  });
}
