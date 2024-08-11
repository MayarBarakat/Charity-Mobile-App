import 'package:charity/layout/charity_layout.dart';
import 'package:charity/module/auth_screens/login_screen/login_screen.dart';
import 'package:charity/shared/components/constants.dart';
import 'package:charity/shared/cubit/charity_cubit.dart';
import 'package:charity/shared/network/local/cache_helper.dart';
import 'package:charity/shared/network/remote/dio_helper.dart';
import 'package:charity/shared/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();
  bool isHasToken = false;
  if(await CacheHelper.getData(key: 'token') != null){
    isHasToken = true;
    token = await CacheHelper.getData(key: 'token')??'';
  }
  runApp( MyApp(isHasToken: isHasToken,));
}

class MyApp extends StatelessWidget {
  final bool isHasToken;
  const MyApp({super.key,required this.isHasToken});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
           !isHasToken?CharityCubit():CharityCubit()..getCampaigns(start: '1', count: '10')
             ..getAds(start: '1', count: '10')..getRequests( start: '1', count: '10')
             ..getPreviousDonationCampaignsModel()..getPreviousDonationRequestsModel()..getUserData(),
        ),
      ],
      child: BlocConsumer<CharityCubit, CharityState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: theme(),
        home:isHasToken?const CharityLayout(): LoginScreen(),
      );
  },
),
    );
  }
}


