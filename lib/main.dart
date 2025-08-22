import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';
void main() {
  runApp(ProviderScope(child: const App()));
}

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<int> build() async {
    // await Future.delayed(Duration(seconds: 2));
    return 0;
  }

  void increment() async {
   update((state) => state + 1);
   //  state = AsyncError("Bug", StackTrace.current);
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(myNotifierProvider);
    return MaterialApp(home:
      Scaffold(
        appBar: AppBar(),
        body: switch (count) {
          AsyncData(:final value) => Text(value.toString()),
          AsyncError(:final error) => Text(error.toString()),
        _ => CircularProgressIndicator(),
        },
        floatingActionButton: FloatingActionButton(onPressed: () => ref.read(myNotifierProvider.notifier).increment()),
      ));
  }
}
