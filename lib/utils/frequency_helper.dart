String frequencyLabel(int days) {
  if (days == 1) return 'Every day';
  if (days <= 3) return 'Every few days';
  if (days <= 7) return 'Once a week';
  if (days <= 14) return 'Every two weeks';
  if (days <= 30) return 'Once a month';
  if (days <= 60) return 'Every couple of months';
  if (days <= 90) return 'Every few months';
  return 'A few times a year';
}

String monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
