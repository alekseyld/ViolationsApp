import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photocontrolapp/blocs/blocs.dart';
import 'package:photocontrolapp/screens/screens.dart';
import 'package:photocontrolapp/widgets/widgets.dart';

class ViolationList extends StatelessWidget {
  final ViolationType violationType;

  ViolationList({this.violationType});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ViolationsBloc>(context)
      ..add(ViolationsLoaded(violationType));
    final bloc = BlocProvider.of<ViolationsBloc>(context);

    return BlocBuilder<ViolationsBloc, ViolationsState>(
      condition: (previous, current) {
        return current.type == violationType;
      },
      builder: (context, state) {
        if (state is ViolationsLoadSuccess) {
          var violations = state.violations;


          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 1),
            itemCount: violations.length,
            itemBuilder: (context, index) {
              var violation = violations[index];

              return CardItem(
                violation: violation,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        bloc: bloc,
                        violation: violation,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is ViolationsLoadFailure) {
          return Center(
            child: Text("Error on loading violations"),
          );
        }

        return LoadingIndicator();
      },
    );
  }
}
