import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/app.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_event.dart';
import 'package:smart_lunch/blocs/cafeteria/cafeteria_bloc.dart';
import 'package:smart_lunch/blocs/cafeteria_hours/cafeteria_hours_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/family/family_bloc.dart';
import 'package:smart_lunch/blocs/history/history_bloc.dart';
import 'package:smart_lunch/blocs/home_bloc/home_bloc.dart';
import 'package:smart_lunch/blocs/language/language_bloc.dart';
import 'package:smart_lunch/blocs/language/language_event.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/products/products_bloc.dart';
import 'package:smart_lunch/blocs/sales/sales_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/data/providers/secure_storage_provider.dart';
import 'package:smart_lunch/data/repositories/History/History_repository.dart';
import 'package:smart_lunch/data/repositories/api/api_client_repository.dart';
import 'package:smart_lunch/data/repositories/app_version/app_version_repository.dart';
import 'package:smart_lunch/data/repositories/cafeteria/cafeteria_repository.dart';
import 'package:smart_lunch/data/repositories/croem/croem_repository.dart';
import 'package:smart_lunch/data/repositories/family/family_repository.dart';
import 'package:smart_lunch/data/repositories/language/language_repository.dart';
import 'package:smart_lunch/data/repositories/openpay/openpay_repository.dart';
import 'package:smart_lunch/data/repositories/product/product_repository.dart';
import 'package:smart_lunch/data/repositories/sales/sales_repository.dart';
import 'package:smart_lunch/data/repositories/session/session_repository.dart';
import 'package:smart_lunch/data/repositories/users/users_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageProvider = StorageProvider();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LanguageRepository>(
          create: (_) => LanguageRepository(storageProvider),
        ),

        RepositoryProvider<SessionRepository>(
          create: (_) => SessionRepository(storageProvider),
        ),

        RepositoryProvider<ApiClientRepository>(
          create: (context) =>
              ApiClientRepository(context.read<SessionRepository>()),
        ),

        RepositoryProvider<CafeteriaRepository>(
          create: (context) =>
              CafeteriaRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<AppVersionRepository>(
          create: (context) =>
              AppVersionRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<UserRepository>(
          create: (context) =>
              UserRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<FamlilyRepository>(
          create: (context) =>
              FamlilyRepository(context.read<ApiClientRepository>()),
        ),
        RepositoryProvider<SalesRepository>(
          create: (context) =>
              SalesRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<OpenpayRepository>(
          create: (context) =>
              OpenpayRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<CroemRepository>(
          create: (context) =>
              CroemRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<ProductsRepository>(
          create: (context) =>
              ProductsRepository(context.read<ApiClientRepository>()),
        ),

        RepositoryProvider<HistoryRepository>(
          create: (context) =>
              HistoryRepository(context.read<ApiClientRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LanguageBloc(context.read<LanguageRepository>())
                  ..add(LoadLanguage()),
          ),

          BlocProvider(
            create: (context) => SessionBloc(
              sessionRepository: context.read<SessionRepository>(),
            )..add(CheckSessionEvent()),
          ),

          BlocProvider(
            create: (context) => CafeteriaBloc(
              context.read<CafeteriaRepository>(),
              storageProvider,
            ),
          ),

          BlocProvider(create: (context) => CafeteriaHoursBloc()),

          BlocProvider(
            create: (context) =>
                AppVersionBloc(context.read<AppVersionRepository>())
                  ..add(LoadAppversion()),
          ),

          BlocProvider(
            create: (context) => UsersBloc(context.read<UserRepository>()),
          ),
          BlocProvider(
            create: (context) => FamilyBloc(context.read<FamlilyRepository>()),
          ),

          BlocProvider(
            create: (context) =>
                SalesHistoryBloc(context.read<SalesRepository>()),
          ),

          BlocProvider(
            create: (context) => SalesBloc(context.read<SalesRepository>()),
          ),

          BlocProvider(
            create: (context) =>
                ProductsBloc(context.read<ProductsRepository>()),
          ),

          BlocProvider(
            create: (context) => OpenpayBloc(context.read<OpenpayRepository>()),
          ),

          BlocProvider(
            create: (context) => CroemBloc(context.read<CroemRepository>()),
          ),

          BlocProvider(
            create: (context) => HistoryBloc(context.read<HistoryRepository>()),
          ),

          BlocProvider(create: (context) => HomeBloc()),
        ],
        child: const App(),
      ),
    ),
  );
}
