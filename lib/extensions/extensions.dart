import 'package:intl/intl.dart';

DateFormat get _dateTimeFormat => DateFormat('yyyy-MM-dd hh:mm aa');
DateFormat get _verbalDate => DateFormat('MMM dd, yyyy');
DateFormat get _verbalDateTime => DateFormat('dd MMM yyyy | hh:mm aa');
DateFormat get _verbalTime => DateFormat('hh:mm aa');
DateFormat get _verbalDateTimeWithDay => DateFormat('EEE, MMM dd | hh:mm aa');
DateFormat get _markerDate => DateFormat('EEE, dd MMM');

extension DateX on DateTime {
  String get toDateTime {
    return _dateTimeFormat.format(this);
  }

  String get toVerbalDate {
    return _verbalDate.format(this);
  }

  String get toVerbalDateTime {
    return _verbalDateTime.format(this);
  }

  String get toVerbalTime {
    return _verbalTime.format(this);
  }

  String get toVerbalDateTimeWithDay {
    return _verbalDateTimeWithDay.format(this);
  }

  String get toMarkerDate {
    final now = DateTime.now();
    if (year == now.year && month == now.month && day == now.day) {
      return 'Today at $toVerbalTime';
    }
    //yesterday
    else if (year == now.year && month == now.month && day == now.day - 1) {
      return 'Yesterday at $toVerbalTime';
    } else {
      return toLocal().toVerbalDateTime;
    }
  }
}

extension NumX on num {
  String get toCurrency {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs.',
    ).format(this);
  }
}
