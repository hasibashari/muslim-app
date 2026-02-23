import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  final String greeting;
  final String formattedDate;

  const HomeState({required this.greeting, required this.formattedDate});
}

final homeProvider = Provider<HomeState>((ref) {
  final hour = DateTime.now().hour;
  late String greeting;
  if (hour < 4) {
    greeting = 'Selamat Malam';
  } else if (hour < 10) {
    greeting = 'Selamat Pagi';
  } else if (hour < 15) {
    greeting = 'Selamat Siang';
  } else if (hour < 18) {
    greeting = 'Selamat Sore';
  } else {
    greeting = 'Selamat Malam';
  }

  final now = DateTime.now();
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final date =
      '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

  return HomeState(greeting: greeting, formattedDate: date);
});
