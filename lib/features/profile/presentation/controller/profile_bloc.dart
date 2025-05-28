import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulmo/features/profile/domain/usecases/delete_payment_method_usecase.dart';
import 'package:ulmo/features/profile/domain/usecases/get_payment_methods_usecase.dart';
import 'package:ulmo/features/profile/domain/usecases/save_payment_method_usecase.dart';
import 'package:ulmo/features/profile/domain/usecases/set_default_payment_method_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_user_orders_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_profile_photo_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateProfileUseCase updateProfile;
  final UploadProfilePhotoUseCase uploadProfilePhoto;
  final ChangePasswordUseCase changePassword;
  final GetUserOrdersUseCase getUserOrders;
  final SignOutUseCase signOut;

  // Payment method use cases
  final GetPaymentMethodsUseCase getPaymentMethods;
  final SavePaymentMethodUseCase savePaymentMethod;
  final DeletePaymentMethodUseCase deletePaymentMethod;
  final SetDefaultPaymentMethodUseCase setDefaultPaymentMethod;

  ProfileBloc({
    required this.getUserProfile,
    required this.updateProfile,
    required this.uploadProfilePhoto,
    required this.changePassword,
    required this.getUserOrders,
    required this.signOut,
    required this.getPaymentMethods,
    required this.savePaymentMethod,
    required this.deletePaymentMethod,
    required this.setDefaultPaymentMethod,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadProfilePhoto>(_onUploadProfilePhoto);
    on<UpdateProfileWithPhoto>(_onUpdateProfileWithPhoto);
    on<ChangePassword>(_onChangePassword);
    on<LoadOrders>(_onLoadOrders);
    on<SignOut>(_onSignOut);
    on<LoadOrderDetails>(_onLoadOrderDetails);
    // Payment method events
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<AddPaymentMethod>(_onAddPaymentMethod);
    on<DeletePaymentMethod>(_onDeletePaymentMethod);
    on<SetDefaultPaymentMethod>(_onSetDefaultPaymentMethod);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final user = await getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final updatedUser = await updateProfile(event.profileData);
      emit(ProfileUpdated(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUploadProfilePhoto(
    UploadProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final photoUrl = await uploadProfilePhoto(event.photo);
      emit(ProfilePhotoUploaded(photoUrl));

      // After successful photo upload, reload the profile
      add(LoadProfile());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfileWithPhoto(
    UpdateProfileWithPhoto event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      // First upload the photo
      final photoUrl = await uploadProfilePhoto(event.photo);

      // Then update the profile with photo URL and other data
      final profileData = Map<String, dynamic>.from(event.profileData);
      profileData['avatarUrl'] = photoUrl;

      final updatedUser = await updateProfile(profileData);
      emit(ProfileUpdated(updatedUser));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await changePassword(event.currentPassword, event.newPassword);
      emit(ProfilePasswordChanged());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final orders = await getUserOrders();
      emit(ProfileOrdersLoaded(orders));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      await signOut();
      emit(ProfileSignedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      // You might want to create a dedicated use case for this
      // For now, we can use the existing methods and filter
      final orders = await getUserOrders();
      final orderDetails = orders.firstWhere(
        (order) => order['id'] == event.orderId,
        orElse: () => throw Exception('Order not found'),
      );

      emit(OrderDetailsLoaded(orderDetails));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final cards = await getPaymentMethods();

      // Extract default card ID
      final defaultCardId =
          cards.isNotEmpty
              ? cards
                  .firstWhere(
                    (card) => card.isDefault,
                    orElse: () => cards.first,
                  )
                  .id
              : null;

      emit(PaymentMethodsLoaded(cards, defaultCardId));
    } catch (e) {
      emit(ProfileError('Failed to load payment methods: ${e.toString()}'));
    }
  }

  Future<void> _onAddPaymentMethod(
    AddPaymentMethod event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final savedCard = await savePaymentMethod(event.card);
      emit(PaymentMethodAdded(savedCard));

      // Reload payment methods to show updated list
      add(LoadPaymentMethods());
    } catch (e) {
      emit(ProfileError('Failed to add payment method: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePaymentMethod(
    DeletePaymentMethod event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await deletePaymentMethod(event.cardId);
      emit(PaymentMethodDeleted());

      // Reload payment methods to show updated list
      add(LoadPaymentMethods());
    } catch (e) {
      emit(ProfileError('Failed to delete payment method: ${e.toString()}'));
    }
  }

  Future<void> _onSetDefaultPaymentMethod(
    SetDefaultPaymentMethod event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await setDefaultPaymentMethod(event.cardId);
      emit(DefaultPaymentMethodSet(event.cardId));

      // Reload payment methods to show updated list
      add(LoadPaymentMethods());
    } catch (e) {
      emit(
        ProfileError('Failed to set default payment method: ${e.toString()}'),
      );
    }
  }
}
