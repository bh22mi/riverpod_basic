import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_example/main.dart';

abstract class WebsocketClient {
  Stream<int> getCounterStream([int? start]);
}

class FakeWebsocketClient implements WebsocketClient {
  @override
  Stream<int> getCounterStream([int? start]) async* {
    int i = start!;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i++;
    }
  }
}

final webSocketProvier =
    Provider<WebsocketClient>((ref) => FakeWebsocketClient());

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<int> counter = ref.watch(counterProvider(5));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(counterProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Text(counter
            .when(
                data: (int vavl) => vavl,
                error: (Object e, _) => e,
                loading: () => 5)
            .toString()),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //      ref.read(counterProvider.notifier).state++;
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
