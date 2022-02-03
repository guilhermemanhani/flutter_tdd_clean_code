import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_code/injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Center(
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                // color: Colors.red,
                // height: 400,
                width: MediaQuery.of(context).size.width * 0.8,
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    color: Colors.green,
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
        // buildBody(context),
      ),
    );
  }

  // BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  //   return BlocProvider(
  //     create: (_) => sl<NumberTriviaBloc>(),
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Column(
  //           children: [
  //             const SizedBox(height: 10),
  //             BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
  //               builder: (context, state) {
  //                 if (state is Empty) {
  //                   return const MessageDisplay(message: 'Start searching');
  //                 } else if (state is Loading) {
  //                   return const LoadingWidget();
  //                 } else if (state is Loaded) {
  //                   return TriviaDisplay(numberTrivia: state.trivia);
  //                 } else if (state is Error) {
  //                   return MessageDisplay(message: state.message);
  //                 }
  //                 return SizedBox(
  //                   height: MediaQuery.of(context).size.height / 3,
  //                   child: const Placeholder(),
  //                 );
  //               },
  //             ),
  //             const SizedBox(height: 20),
  //             const TriviaControls(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
