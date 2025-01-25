 import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
    if (date == null) return 'No date selected';

    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    final daySuffix = (date.day >= 11 && date.day <= 13)
        ? 'th'
        : (date.day % 10 == 1)
            ? 'st'
            : (date.day % 10 == 2)
                ? 'nd'
                : (date.day % 10 == 3)
                    ? 'rd'
                    : 'th';
    return DateFormat("d'$daySuffix' MMM, yyyy").format(date);
  }