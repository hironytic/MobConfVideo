import 'package:flutter/widgets.dart';

abstract class Bloc {
  void dispose();
}

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T Function() createBloc;
  BlocProvider({
    @required this.child,
    @required this.createBloc,
  });
  _BlocProviderState createState() => _BlocProviderState<T>(bloc: createBloc());

  static T of<T extends Bloc>(BuildContext context) =>
      _ProviderInherited.of<T>(context);
}

class _BlocProviderState<T extends Bloc> extends State<BlocProvider> {
  final T bloc;
  _BlocProviderState({@required this.bloc});
  @override
  Widget build(BuildContext context) {
    return _ProviderInherited<T>(
      bloc: bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class _ProviderInherited<T extends Bloc> extends InheritedWidget {
  final T bloc;
  final Widget child;
  _ProviderInherited({
    @required this.bloc,
    @required this.child,
  }) : super(child: child);

  static T of<T extends Bloc>(BuildContext context) {
    Type typeOf<T>() => T;
    return (context.inheritFromWidgetOfExactType(
            typeOf<_ProviderInherited<T>>()) as _ProviderInherited<T>)
        .bloc;
  }

  @override
  bool updateShouldNotify(_ProviderInherited oldWidget) => false;
}
