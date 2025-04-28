import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ulmo/core/helpers/stripe_services.dart';
import 'package:ulmo/features/auth/data/repo/auth_repo.dart';
import 'package:ulmo/features/auth/domain/usecases/login_google_usecase.dart';
import 'package:ulmo/features/auth/domain/usecases/login_usecase.dart';
import 'package:ulmo/features/auth/presentation/controller/otp_bloc/otp_bloc.dart';
import 'package:ulmo/features/auth/presentation/controller/register_bloc/register_bloc.dart';
import 'package:ulmo/features/bag/data/data_source/bag_data_source.dart';
import 'package:ulmo/features/bag/data/data_source/payment_data_source.dart';
import 'package:ulmo/features/bag/data/repo/bag_repo.dart';
import 'package:ulmo/features/bag/data/repo/payment_repo.dart';
import 'package:ulmo/features/bag/presentation/controller/bag_bloc.dart';
import 'package:ulmo/features/categories/data/data_source/category_data_source.dart';
import 'package:ulmo/features/categories/data/repo/category_repo_impl.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_categories.dart';
import 'package:ulmo/features/categories/domain/usecases/fetch_child_categories.dart';
import 'package:ulmo/features/categories/presentation/controller/category_bloc.dart';
import 'package:ulmo/features/favorite/presentation/controller/favorite_bloc.dart';
import 'package:ulmo/features/layout/presentation/controller/layout_bloc.dart';
import 'package:ulmo/features/product/data/data_source/filter_data_source.dart';
import 'package:ulmo/features/product/data/data_source/product_data_source.dart';
import 'package:ulmo/features/product/data/repo/product_repo.dart';
import 'package:ulmo/features/product/domain/usecases/fetch_all_products.dart';
import 'package:ulmo/features/product/domain/usecases/fetch_products.dart';
import 'package:ulmo/features/product/presentation/controller/product_bloc.dart';
import 'package:ulmo/features/review/data/data_source/review_data_source.dart';
import 'package:ulmo/features/review/data/data_source/user_data_source.dart';
import 'package:ulmo/features/review/data/repo/review_repo.dart';
import 'package:ulmo/features/review/domain/usecases/get_prodect_review.dart';
import 'package:ulmo/features/review/domain/usecases/submit_review_usecases.dart';
import 'package:ulmo/features/review/presentation/controller/review_%20bloc.dart';

import '../../features/auth/data/data_source/firebase_auth_data_source.dart';
import '../../features/auth/domain/usecases/otp_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/controller/login_bloc/login_bloc.dart';
import '../../features/bag/domain/usecases/add_item_usecase.dart';
import '../../features/bag/domain/usecases/clear_bag_usecase.dart';
import '../../features/bag/domain/usecases/get_bag_usecase.dart';
import '../../features/bag/domain/usecases/pay_usecase.dart';
import '../../features/bag/domain/usecases/remove_item_usecase.dart';
import '../../features/bag/domain/usecases/update_item_usecase.dart';
import '../../features/product/domain/usecases/filter_usecase.dart';
import '../models/product.dart';

final GetIt di = GetIt.instance;

void setupServiceLocator() {
  //data source
  di.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(),
  );

  di.registerLazySingleton<CategoryDataSource>(() => CategoryDataSource());

  di.registerLazySingleton<ProductDataSource>(() => ProductDataSource());

  di.registerLazySingleton<FilterDataSource>(() => FilterDataSource());
  di.registerLazySingleton<ReviewDataSource>(() => ReviewDataSource());
  di.registerLazySingleton<UserDataSource>(() => UserDataSource());

  di.registerLazySingleton<BagDataSource>(() => BagDataSource());

  di.registerLazySingleton<StripeServices>(() => StripeServices());

  di.registerLazySingleton<PaymentDataSource>(
    () => PaymentDataSource(
      bagSource: di<BagDataSource>(),
      stripeServises: di<StripeServices>(),
      stripeCustomerId: '',
    ),
  );

  //repo
  di.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      firebaseAuth: FirebaseAuth.instance,
      secureStorage: FlutterSecureStorage(),
      googleSignIn: GoogleSignIn(),
    ),
  );

  di.registerLazySingleton<CategoriesRepo>(
    () => CategoriesRepo(categoryDataSource: di<CategoryDataSource>()),
  );

  di.registerLazySingleton<ProductsRepo>(
    () => ProductsRepo(
      filterDataSource: di<FilterDataSource>(),
      productsDataSource: di<ProductDataSource>(),
    ),
  );

  di.registerLazySingleton<ReviewRepository>(
    () => ReviewRepository(di<ReviewDataSource>(), di<UserDataSource>()),
  );

  di.registerLazySingleton<PaymentRepositoryImpl>(
    () => PaymentRepositoryImpl(paymentDataSource: di<PaymentDataSource>()),
  );
  di.registerLazySingleton<BagRepositoryImpl>(
    () => BagRepositoryImpl(bagDataSource: di<BagDataSource>()),
  );

  //use cases
  di.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(di.get<AuthRepositoryImpl>()),
  );

  di.registerLazySingleton<LoginWithEmailUseCase>(
    () => LoginWithEmailUseCase(di.get<AuthRepositoryImpl>()),
  );
  di.registerLazySingleton<LoginWithGoogleUseCase>(
    () => LoginWithGoogleUseCase(di.get<AuthRepositoryImpl>()),
  );
  di.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(di.get<AuthRepositoryImpl>()),
  );

  di.registerLazySingleton<FetchCategoriesUseCase>(
    () => FetchCategoriesUseCase(di.get<CategoriesRepo>()),
  );

  di.registerLazySingleton<FetchChildCategoriesUseCase>(
    () => FetchChildCategoriesUseCase(di.get<CategoriesRepo>()),
  );

  di.registerLazySingleton<FetchProductsUseCase>(
    () => FetchProductsUseCase(di.get<ProductsRepo>()),
  );
  di.registerLazySingleton<FilterProductsUseCase>(
    () => FilterProductsUseCase(di.get<ProductsRepo>()),
  );
  di.registerLazySingleton<FetchCategoriesFilterUseCase>(
    () => FetchCategoriesFilterUseCase(di.get<ProductsRepo>()),
  );
  di.registerLazySingleton<SubmitReview>(
    () => SubmitReview(di.get<ReviewRepository>()),
  );
  di.registerLazySingleton<GetProductReviews>(
    () => GetProductReviews(di.get<ReviewRepository>()),
  );

  di.registerLazySingleton<AddItemToBagUseCase>(
    () => AddItemToBagUseCase(di.get<BagRepositoryImpl>()),
  );
  di.registerLazySingleton<ClearBagUseCase>(
    () => ClearBagUseCase(di.get<BagRepositoryImpl>()),
  );

  di.registerLazySingleton<GetBagUseCase>(
    () => GetBagUseCase(di.get<BagRepositoryImpl>()),
  );

  di.registerLazySingleton<RemoveItemFromBagUseCase>(
    () => RemoveItemFromBagUseCase(di.get<BagRepositoryImpl>()),
  );

  di.registerLazySingleton<UpdateBagItemQuantityUseCase>(
    () => UpdateBagItemQuantityUseCase(di.get<BagRepositoryImpl>()),
  );

  di.registerLazySingleton<PayUseCase>(
    () => PayUseCase(di.get<PaymentRepositoryImpl>()),
  );

  //  blocs
  di.registerLazySingleton<RegisterBloc>(
    () => RegisterBloc(di.get<RegisterUserUseCase>()),
  );

  di.registerLazySingleton<OtpAuthBloc>(
    () => OtpAuthBloc(di.get<VerifyOtpUseCase>()),
  );
  di.registerLazySingleton<LoginBloc>(
    () => LoginBloc(
      di.get<LoginWithEmailUseCase>(),
      di.get<LoginWithGoogleUseCase>(),
    ),
  );
  di.registerFactory<LayoutBloc>(() => LayoutBloc());
  di.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      di.get<FetchCategoriesUseCase>(),
      di.get<FetchChildCategoriesUseCase>(),
      di.get<CategoriesRepo>(),
    ),
  );
  di.registerFactory<ProductBloc>(
    () => ProductBloc(
      di.get<FetchProductsUseCase>(),
      di.get<FilterProductsUseCase>(),
      di.get<FetchCategoriesFilterUseCase>(),
    ),
  );

  di.registerFactory<ReviewBloc>(
    () => ReviewBloc(
      submitReview: di.get<SubmitReview>(),
      getProductReviews: di.get<GetProductReviews>(),
    ),
  );
  di.registerFactory<FavoriteBloc>(() => FavoriteBloc([]));

  di.registerFactory<BagBloc>(
    () => BagBloc(
      bagRepository: di.get<BagRepositoryImpl>(),
      paymentRepository: di.get<PaymentRepositoryImpl>(),
    ),
  );
}
