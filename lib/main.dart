
//Provider - это оболочка вокруг InheritedWidget, которая позволяет сделать
// их более простыми в использовании и более многоразовыми (переиспользуемыми).

// Вариант исполнения для версии Provider после версии 4.0.0
// В данном случае использован provider ^5.0.0
// Использование provider + ChangeNotifier на примере дефолтного Flutter приложения.
/// Комментрии от Ильи Краснова для грейда 12.

/// Что происходит:
// При нажатии на кнопку (например, +) метод Provider.of<Counter>(context) вызывает метод
// increment(), который выполняет своё действие(прибавляет 1) и через метод notifyListeners(),
// уведомляет об изменениях ChangeNotifierProvider. ChangeNotifierProvider уведомляет всех своих слушателей через
// Provider.of<Counter>(context), в нашем случае передаёт значение через get метод count.

/// Что для этого нужно сделать:
// 1. Создаём новый объект наблюдения внутри create. В нашем случае Counter().
// 2. К классу Counter добавляем mixin ChangeNotifier.
// 3. К методам класса Counter добавляем notifyListeners(), для того,
// чтобы они (методы) уведомляли об изменениях ChangeNotifierProvider.
// 4. Через метод context.read<T>() или Provider.of<T>(context, listen: false)
// передаём информацию в ChangeNotifierProvider.
// 5. Через метод context.watch<T>() или Provider.of<T>(context)
// прослушиваем информацию из ChangeNotifierProvider.

/// Самый простой способ прочитать значение-использовать методы расширения в [BuildContext]:
// context.watch<T>(), который заставляет виджет прослушивать изменения в T.
// context.read<T>(), который возвращает T, не прослушивая его
// context.select<T, R>(R cb(T value)), который позволяет виджету прослушивать только небольшую часть T.
// Так же можно использовать статический метод Provider.of<T>(context),
// который будет вести себя аналогично watch. Если передадите false параметру listen,
// например Provider.of<T>(context, listen: false), он будет вести себя аналогично read.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
  void decrement() {
    _count--;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => Counter()),],
            child:MyHomePage(),
    ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Example from I.Krasnov'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Использую конструкию с watch:'),
            Text(
              // Вызывает `context.watch", чтобы перестроить [Count] при изменении [Counter].
                '${context.watch<Counter>().count}',
                style: Theme.of(context).textTheme.headline2),
            Text('Использую конструкию с Provider.of'),
            Text(
              // Вызывает `Provider.of<Counter>(context).count", чтобы перестроить [Count] при изменении [Counter].
                '${Provider.of<Counter>(context).count}',
                style: Theme.of(context).textTheme.headline2),
            Text('Вызов из отдельного виджета:'),
            // Извлекается в виде отдельного виджета для оптимизации производительности.
            // Это совершенно необязательно (и редко требуется).
            // Аналогично, мы могли бы также использовать [Consumer] или [Selector].
            Count(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            // Вызывает "context.read" вместо `context.watch",
            // чтобы он не перестраивался при изменении [Counter].
            onPressed: context.read<Counter>().increment,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 20,),
          FloatingActionButton(
            // Вызывает "Provider.of" с параметром listen: false вместо `context.watch",
            // чтобы он не перестраивался при изменении [Counter].
            onPressed: Provider.of<Counter>(context, listen: false).decrement,
            tooltip: 'Increment',
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}

class Count extends StatelessWidget {
  //const Count({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      // Вызывает `context.watch", чтобы перестрать [Count] при изменении [Counter].
        '${context.watch<Counter>().count}',
        style: Theme.of(context).textTheme.headline2);
  }
}

/// Вариант испольнения Provider до версии 3.2.0
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'counter_provider.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'I.Krasnov Grade12',
//       theme: ThemeData(
//         primarySwatch: Colors.blueGrey,
//       ),
//       home: ChangeNotifierProvider<IntCounter>(builder: (_) => IntCounter(0),
//         child: HomePage('Provider Example from I.Krasnov'),
//       ),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   final String title;
//   HomePage(this.title);
//   @override
//   Widget build(BuildContext context) {
//     final counter = Provider.of<IntCounter>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Provider Demo"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '${counter.getCounter()}',
//               style: Theme.of(context).textTheme.display4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton(
//             onPressed: counter.increment,
//             tooltip: 'Increment',
//             child: Icon(Icons.add),
//           ),
//           SizedBox(height: 10),
//           FloatingActionButton(
//             onPressed: counter.decrement,
//             tooltip: 'Increment',
//             child: Icon(Icons.remove),
//           )
//         ],
//       ),
//     );
//   }
// }