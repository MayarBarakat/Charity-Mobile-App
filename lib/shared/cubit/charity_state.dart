part of 'charity_cubit.dart';

@immutable
sealed class CharityState {}

final class CharityInitial extends CharityState {}

final class CharityChangeBottomState extends CharityState {}

final class CharityLoginSuccessfullyState extends CharityState {}
final class CharityLoginLoadingState extends CharityState {}
final class CharityLoginErrorState extends CharityState {}

final class CharitySignupSuccessfullyState extends CharityState {}
final class CharitySignupLoadingState extends CharityState {}
final class CharitySignupErrorState extends CharityState {}

final class CharitySendEmailInPasswordSuccessfullyState extends CharityState {}
final class CharitySendEmailInPasswordLoadingState extends CharityState {}
final class CharitySendEmailInPasswordErrorState extends CharityState {}

final class CharityResetConfirmationSuccessfullyState extends CharityState {}
final class CharityResetConfirmationLoadingState extends CharityState {}
final class CharityResetConfirmationErrorState extends CharityState {}

final class CharityConfirmCodeSuccessfullyState extends CharityState {}
final class CharityConfirmCodeLoadingState extends CharityState {}
final class CharityConfirmCodeErrorState extends CharityState {}

final class CharityCampaignsSuccessfullyState extends CharityState {}
final class CharityCampaignsLoadingState extends CharityState {}
final class CharityCampaignsErrorState extends CharityState {}

final class CharityCampaignsDetailsSuccessfullyState extends CharityState {}
final class CharityCampaignsDetailsLoadingState extends CharityState {}
final class CharityCampaignsDetailsErrorState extends CharityState {}


final class CharityAdsSuccessfullyState extends CharityState {}
final class CharityAdsLoadingState extends CharityState {}
final class CharityAdsErrorState extends CharityState {}

final class CharityAddRequestSuccessfullyState extends CharityState {}
final class CharityAddRequestLoadingState extends CharityState {}
final class CharityAddRequestErrorState extends CharityState {}

final class CharityPreviousRequestSuccessfullyState extends CharityState {}
final class CharityPreviousRequestLoadingState extends CharityState {}
final class CharityPreviousRequestErrorState extends CharityState {}


final class CharityPreviousRequestDeleteSuccessfullyState extends CharityState {}
final class CharityPreviousRequestDeleteErrorState extends CharityState {}

final class CharityDonatForFundSuccessfullyState extends CharityState {}
final class CharityDonatForFundErrorState extends CharityState {}

final class CharityDonatToCampaignSuccessfullyState extends CharityState {}
final class CharityDonatToCampaignErrorState extends CharityState {}

final class CharityDonatToRequestSuccessfullyState extends CharityState {}
final class CharityDonatToRequestErrorState extends CharityState {}

final class CharityUserDataSuccessfullyState extends CharityState {}
final class CharityUserDataLoadingState extends CharityState {}
final class CharityUserDataErrorState extends CharityState {}

final class CharityGetRequestsSuccessfullyState extends CharityState {}
final class CharityGetRequestsLoadingState extends CharityState {}
final class CharityGetRequestsErrorState extends CharityState {}

final class CharityRequestDetailsSuccessfullyState extends CharityState {}
final class CharityRequestDetailsLoadingState extends CharityState {}
final class CharityRequestDetailsErrorState extends CharityState {}

final class CharityPreviousDonationCampaignsSuccessfullyState extends CharityState {}
final class CharityPreviousDonationCampaignsLoadingState extends CharityState {}
final class CharityPreviousDonationCampaignsErrorState extends CharityState {}

final class CharityPreviousDonationRequestsSuccessfullyState extends CharityState {}
final class CharityPreviousDonationRequestsLoadingState extends CharityState {}
final class CharityPreviousDonationRequestsErrorState extends CharityState {}

final class CharityEditProfileSuccessfullyState extends CharityState {}
final class CharityEditProfileLoadingState extends CharityState {}
final class CharityEditProfileErrorState extends CharityState {}

final class CharityAboutUsSuccessfullyState extends CharityState {}
final class CharityAboutUsLoadingState extends CharityState {}
final class CharityAboutUsErrorState extends CharityState {}

final class CharityLogoutSuccessfullyState extends CharityState {}