import 'package:chrome_flutter/Blocs/PutAwayBloc/PutAwayBloc.dart';
import 'package:chrome_flutter/Blocs/PutAwayDetailBloc/PutAwayDetailBloc.dart';
import 'package:chrome_flutter/Blocs/StockInBloc/StockInBloc.dart';
import 'package:chrome_flutter/Blocs/StockOutBloc/StockOutBloc.dart';
import 'package:chrome_flutter/Blocs/StockOutDetailBloc/StockOutDetailBloc.dart';
import 'package:chrome_flutter/Data/Repositories/PutAwayDetailRepository/PutAwayDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/PutAwayRepository/PutAwayRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockInDetailRepository/StockInDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockInRepository/StockInRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockOutDetailRepository/StockOutDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockOutRepository/StockOutRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Blocs/LoginBloc/LoginBloc.dart';
import 'Blocs/LoginBloc/LoginEvent.dart';
import 'Blocs/MenuBloc/MenuBloc.dart';
import 'Blocs/QRGeneratorBloc/QRGeneratorBloc.dart';
import 'Blocs/StockInDetailBloc/StockInDetailBloc.dart';
import 'Data/Repositories/LoginRepository/LoginRepository.dart';
import 'Data/Repositories/QRGeneratorRepository/QRGeneratorRepository.dart';
import 'Presentation/Screens/LoginScreen/LoginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late LoginBloc loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loginBloc = LoginBloc(LoginRepository());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.detached) {
      loginBloc.add(AppClosedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => loginBloc),
        BlocProvider(create: (_) => MenuBloc()),
        BlocProvider(
          create: (_) => StockInBloc(stockInRepository: StockInRepository()),
        ),

        BlocProvider(
          create:
              (_) => StockInDetailBloc(
                stockInDetailRepository: StockInDetailRepository(),
              ),
        ),
        BlocProvider(
          create:
              (_) => PutAwayDetailBloc(
                putAwayDetailRepository: PutAwayDetailRepository(),
              ),
        ),
        BlocProvider(
          create:
              (_) => QRGeneratorBloc(
                qrGeneratorRepository: QRGeneratorRepository(),
              ),
        ),
        BlocProvider(
          create: (_) => PutAwayBloc(putAwayRepository: PutAwayRepository()),
        ),
        BlocProvider(
          create: (_) => StockOutBloc(stockOutRepository: StockOutRepository()),
        ),
        BlocProvider(
          create:
              (_) => StockOutDetailBloc(
                stockOutDetailRepository: StockOutDetailRepository(),
              ),
        ),
      ],
      child: MaterialApp(home: LoginScreen()),
    );
  }
}
