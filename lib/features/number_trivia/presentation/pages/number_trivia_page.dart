import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_code/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_clean_code/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    // return MessageDisplay(message: 'Start searching');
                  } else if (state is Loading) {
                    // return LoadingWidget();
                  } else if (state is Loaded) {
                    // return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    // return MessageDisplay(message: state.message);
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: const Placeholder(),
                  );
                },
              ),
              const SizedBox(height: 20),
              // TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
