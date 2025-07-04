import 'package:chrome_flutter/Blocs/ManufacturingOrderDetailBloc/ManufacturingOrderDetailBloc.dart';
import 'package:chrome_flutter/Blocs/MovementBloc/MovementBloc.dart';
import 'package:chrome_flutter/Blocs/MovementDetailBloc/MovementDetailBloc.dart';
import 'package:chrome_flutter/Blocs/PickListBloc/PickListBloc.dart';
import 'package:chrome_flutter/Blocs/PickListDetailBloc/PickListDetailBloc.dart';
import 'package:chrome_flutter/Blocs/PutAwayBloc/PutAwayBloc.dart';
import 'package:chrome_flutter/Blocs/PutAwayDetailBloc/PutAwayDetailBloc.dart';
import 'package:chrome_flutter/Blocs/StockInBloc/StockInBloc.dart';
import 'package:chrome_flutter/Blocs/StockOutBloc/StockOutBloc.dart';
import 'package:chrome_flutter/Blocs/StockOutDetailBloc/StockOutDetailBloc.dart';
import 'package:chrome_flutter/Blocs/StockTakeBloc/StockTakeBloc.dart';
import 'package:chrome_flutter/Blocs/StockTakeDetailBloc/StockTakeDetailBloc.dart';
import 'package:chrome_flutter/Blocs/TransferBloc/TransferBloc.dart';
import 'package:chrome_flutter/Data/Repositories/ManufacturingOrderDetailRepository/ManufacturingOrderDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/ManufacturingOrderRepository/ManufacturingOrderRepository.dart';
import 'package:chrome_flutter/Data/Repositories/MovementDetailRepository/MovementDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/MovementRepository/MovementRepository.dart';
import 'package:chrome_flutter/Data/Repositories/PickListDetailRepository/PickListDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/PickListRepository/PickListRepository.dart';
import 'package:chrome_flutter/Data/Repositories/PutAwayDetailRepository/PutAwayDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/PutAwayRepository/PutAwayRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockInDetailRepository/StockInDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockInRepository/StockInRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockOutDetailRepository/StockOutDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockOutRepository/StockOutRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockTakeDetailRepository/StockTakeDetailRepository.dart';
import 'package:chrome_flutter/Data/Repositories/StockTakeRepository/StockTakeRepository.dart';
import 'package:chrome_flutter/Data/Repositories/TransferRepository/TransferRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Blocs/LoginBloc/LoginBloc.dart';
import 'Blocs/LoginBloc/LoginEvent.dart';
import 'Blocs/ManufacturingOrderBloc/ManufacturingOrderBloc.dart';
import 'Blocs/MenuBloc/MenuBloc.dart';
import 'Blocs/QRGeneratorBloc/QRGeneratorBloc.dart';
import 'Blocs/StockInDetailBloc/StockInDetailBloc.dart';
import 'Blocs/TransferDetailBloc/TransferDetailBloc.dart';
import 'Data/Repositories/LoginRepository/LoginRepository.dart';
import 'Data/Repositories/QRGeneratorRepository/QRGeneratorRepository.dart';
import 'Data/Repositories/TransferDetailRepository/TransferDetailRepository.dart';
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
        BlocProvider(
          create: (_) => PickListBloc(pickListRepository: PickListRepository()),
        ),
        BlocProvider(
          create:
              (_) => PickListDetailBloc(
                pickListDetailRepository: PickListDetailRepository(),
              ),
        ),
        BlocProvider(
          create: (_) => TransferBloc(transferRepository: TransferRepository()),
        ),
        BlocProvider(
          create:
              (_) => TransferDetailBloc(
                transferDetailRepository: TransferDetailRepository(),
              ),
        ),

        BlocProvider(
          create: (_) => MovementBloc(movementRepository: MovementRepository()),
        ),
        BlocProvider(
          create:
              (_) => MovementDetailBloc(
                movementDetailRepository: MovementDetailRepository(),
              ),
        ),

        BlocProvider(
          create:
              (_) => StockTakeBloc(stockTakeRepository: StockTakeRepository()),
        ),
        BlocProvider(
          create:
              (_) => StockTakeDetailBloc(
                stockTakeDetailRepository: StockTakeDetailRepository(),
              ),
        ),

        BlocProvider(
          create:
              (_) => ManufacturingOrderBloc(
                manufacturingOrderRepository: ManufacturingOrderRepository(),
              ),
        ),

        BlocProvider(
          create:
              (_) => ManufacturingOrderDetailBloc(
                manufacturingOrderDetailRepository:
                    ManufacturingOrderDetailRepository(),
              ),
        ),
      ],
      child: MaterialApp(home: LoginScreen()),
    );
  }
}
