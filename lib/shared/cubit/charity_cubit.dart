import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:charity/layout/charity_layout.dart';
import 'package:charity/models/ads_model/ads_model.dart';
import 'package:charity/models/campaign_details_model/campaign_details_model.dart';
import 'package:charity/models/campaigns_model/campaigns_model.dart';
import 'package:charity/models/request_details_model/request_details_model.dart';
import 'package:charity/models/requests/request_model.dart';
import 'package:charity/models/signup_error_model/signup_error_model.dart';
import 'package:charity/models/user_model/user_model.dart';
import 'package:charity/module/ads/ads_screen.dart';
import 'package:charity/module/auth_screens/signup_screen/confirm_code_screen.dart';
import 'package:charity/module/campaign/campaign_screen.dart';
import 'package:charity/module/donation_screen/donation_layout.dart';
import 'package:charity/module/settings/settings_layout.dart';
import 'package:charity/shared/components/components.dart';
import 'package:charity/shared/components/constants.dart';
import 'package:charity/shared/network/end_points.dart';
import 'package:charity/shared/network/local/cache_helper.dart';
import 'package:charity/shared/network/remote/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/about_us_model/about_us_model.dart';
import '../../models/previous_donation_campaigns_model/previous_donation_campaigns_model.dart';
import '../../models/previous_donation_requests_model/previous_donation_request_model.dart';
import '../../models/previous_request_model/previous_request_model.dart';
import '../../module/auth_screens/login_screen/login_screen.dart';
import '../../module/request_screens/request_screen/request_screen.dart';
part 'charity_state.dart';

class CharityCubit extends Cubit<CharityState> {
  CharityCubit() : super(CharityInitial());
  static CharityCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreen = [
     const CampaignScreen(),
    const AdsScreen(),
    const RequestScreen(),
    DonationScreen(),
    SettingsPage(),
  ];
   int walletAmount = (100 + Random().nextInt(100000 - 100).toInt()) as int;

  void changeBottom(int index) {
    currentIndex = index;
    emit(CharityChangeBottomState());
  }

  ////// Login Method ///////
  bool loadingLogin = false;

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    loadingLogin = true;
    emit(CharityLoginLoadingState());
    try {
      final response = await DioHelper.postData(url: LOG_IN, data: {
        'email': email,
        'password': password,
      });
      String result = response.data;

      loadingLogin = false;

      if (response.statusCode == 200) {
        // Assuming a successful response contains the result "Success"

        showAwesomeSnackbar(context: context,
            message: 'Login Successfully',
            contentType: ContentType.success);
        token = result;
        await CacheHelper.saveData(key: 'token', value: token);
        await getUserData();
        await refresh();
        currentIndex = 0;
        emit(CharityLoginSuccessfullyState());
        navigateAndFinish(context, const CharityLayout());

      } else {
        // If the status code is not 200, show an error toast with the server's message
        showAwesomeSnackbar(context: context,
            message: result,
            contentType: ContentType.warning);
        emit(CharityLoginErrorState());
      }
    } catch (error) {
      loadingLogin = false;

      // Extract the error message from the server response if available
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.warning);
      emit(CharityLoginErrorState());
    }
  }

  ///////////////////

  ////// Send email to reset the Password //////
  bool loadingSendEmailInResetPassword = false;
  Future<void> sendEmailInResetPassword({
    required BuildContext context,
    required String email
})async{
    loadingSendEmailInResetPassword = true;
    emit(CharitySendEmailInPasswordLoadingState());

    try{
      final response = await DioHelper.postData(url: RESET_PASSWORD, data: {
        'email': email
      });
      String result = response.data;

      loadingSendEmailInResetPassword = false;
      if(response.statusCode == 200){
        refresh();
        currentIndex = 0;
        emit(CharitySendEmailInPasswordSuccessfullyState());
        showAwesomeSnackbar(context: context,
            message: 'Email send Successfully',
            contentType: ContentType.success);
      }else {
        // If the status code is not 200, show an error toast with the server's message
        showAwesomeSnackbar(context: context,
            message: result,
            contentType: ContentType.warning);
        emit(CharitySendEmailInPasswordErrorState());
      }

    }catch(error){
      loadingSendEmailInResetPassword = false;

      // Extract the error message from the server response if available
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
      emit(CharitySendEmailInPasswordErrorState());
    }
  }
  
  /////////////////////////
  
  //////////////// Reset password confirmation //////////////////
  bool loadingResetConfirmation = false;
  Future<void> resetConfirmation({
    required BuildContext context,
    required String email,
    required String code,
    required String newPassword,
})async{
    loadingResetConfirmation = true;
    emit(CharityResetConfirmationLoadingState());
    
    try{
      final response =await DioHelper.postData(url: RESET_CONFIRMATION, data: {
        'email':email,
        'code':code,
        'newPassword':newPassword
      });
      String result = response.data;
      loadingResetConfirmation = false;
      if(response.statusCode == 200 && result != 'rong code'){

        showAwesomeSnackbar(context: context,
            message: 'Password reset successfully',
            contentType: ContentType.success);
        token = result;
        currentIndex = 0;
        refresh();
        await CacheHelper.saveData(key: 'token', value: token);
        emit(CharityResetConfirmationSuccessfullyState());
        navigateAndFinish(context, const CharityLayout());
      }else {
        // If the status code is not 200, show an error toast with the server's message
        showAwesomeSnackbar(context: context,
            message: result,
            contentType: ContentType.warning);
        emit(CharityResetConfirmationErrorState());
      }
    }catch(error){
      loadingResetConfirmation = false;

      // Extract the error message from the server response if available
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data['error'] ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
      emit(CharityResetConfirmationErrorState());
    }
  }
  /////////////////////////////////////////

//////////////////////////// Sign up ///////////////////////////////

  bool loadingSignup = false;
  late SignupErrorModel signupErrorModel;
  Future<void> signup({
    required BuildContext context,
    required String nationalNumber,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String birthDate,
    required String address,
})async{
    loadingSignup = true;
    emit(CharitySignupLoadingState());
    
    try{
      final response = await DioHelper.postData(url: SIGNUP, data: {
        'id':nationalNumber,
        'name':name,
        'Email':email,
        'password':password,
        'fullNumber':phoneNumber,
        'Date':birthDate,
        'addr':address,
      });
      loadingSignup = false;
      bool modelError = false;
      try{
        modelError = response.data['success'];
      }catch(error){
        modelError = false;
      }
      if(response.statusCode == 200 && modelError){
        emit(CharitySignupSuccessfullyState());
        navigateTo(context, ConfirmCodeScreen(email: email));
      }
      else{
        try{
          signupErrorModel = SignupErrorModel.fromJson(response.data);
          showAwesomeSnackbar(context: context,
              message: signupErrorModel.errors!.first.msg!, contentType: ContentType.warning);
          emit(CharitySignupErrorState());
        }catch(error){
          String errorMsg = response.data;
          showAwesomeSnackbar(context: context, message: errorMsg, contentType: ContentType.warning);
          emit(CharitySignupErrorState());
        }

      }
    }catch(error){
      loadingSignup = false;
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
      emit(CharitySignupErrorState());
    }
    
  }

  ////////////////////////////////////////////////////////////////////////
/////////////////////// Confirm the Code of create account///////////////////////////////

bool loadingConfirmCodeAfterSignup = false;
  Future<void> confirmCode({
    required BuildContext context,
    required String email,
    required code
})async{
    loadingConfirmCodeAfterSignup = true;
    emit(CharityConfirmCodeLoadingState());
    
    try{
      final response = await DioHelper.postData(url: CONFIRM_CODE, data: {
        'email':email,
        'code':code
      });
      String result = response.data;
      loadingConfirmCodeAfterSignup = false;
      if(response.statusCode == 200 && result != 'Confirmation code not found'){
        showAwesomeSnackbar(context: context,
            message: 'The Code Confirmed Successfully',
            contentType: ContentType.success);
        token = result;
        await CacheHelper.saveData(key: 'token', value: token);
        await getUserData();
        await refresh();
        currentIndex = 0;
        emit(CharityConfirmCodeSuccessfullyState());
        navigateAndFinish(context, const CharityLayout());
      }else{
        showAwesomeSnackbar(context: context,
            message: result,
            contentType: ContentType.failure);
        emit(CharityConfirmCodeErrorState());
      }
    }catch(error){
      loadingConfirmCodeAfterSignup = false;
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
      emit(CharityConfirmCodeErrorState());
    }
  }

  bool loadingCampaign = false;
  bool isHasInternet = true;
   late List<CampaignsModel> campaignsModel;
  Future<void> getCampaigns({
    required String start,
    required String count,
})async{
    loadingCampaign = true;
    isHasInternet = true;
    emit(CharityCampaignsLoadingState());
    try{
      final response = await DioHelper.postData(url: CAMPAIGNS, data: {
        'start':start,
        'count':count
      });
      loadingCampaign = false;
      isHasInternet = true;
      print(response.data);
      if(response.statusCode == 200){

        campaignsModel = CampaignsModel.fromJsonList(response.data);
        print(campaignsModel.first);
        emit(CharityCampaignsSuccessfullyState());
      }else{
        isHasInternet = false;
        emit(CharityCampaignsErrorState());
      }
    }catch(error){
      print(error);
      loadingCampaign = false;
      isHasInternet = false;
      emit(CharityCampaignsErrorState());
    }
  }
  bool loadingCampDetails = false;
  late List<CampaignDetailsModel> campaignDetailsModel;
  Future<void> getCampDetails({
    required String id,
})async{
    loadingCampDetails = true;
    emit(CharityCampaignsDetailsLoadingState());
    final response = await DioHelper.postData(url: CAMPAIGN_DETAILS, data: {
      'id':id
    });
    try{
      loadingCampDetails = false;
      campaignDetailsModel = CampaignDetailsModel.fromJsonList(response.data);
      emit(CharityCampaignsDetailsSuccessfullyState());
    }catch(error){
      print(error);
      loadingCampDetails = false;
      emit(CharityCampaignsDetailsErrorState());
    }
  }
  bool loadingAds = false;
  late List<AdsModel> ads;
  Future<void> getAds({
    required String start,
    required String count,
})async{
    loadingAds = true;
    emit(CharityAdsLoadingState());
    try{
      final response = await DioHelper.postData(url: ADS, data: {
        'start':start,
        'count':count
      });
      loadingAds = false;
      ads = AdsModel.fromJsonList(response.data);
      emit(CharityAdsSuccessfullyState());
    }catch(error){
      print(error);
      loadingAds = false;
      emit(CharityAdsErrorState());
    }
  }

  Future<void> refresh()async {
     getCampaigns(start: '1', count: '10');
     getAds(start: '1', count: '10');
     getRequests( start: '1', count: '10');
     getPreviousDonationCampaignsModel();
     getPreviousDonationRequestsModel();
     getUserData();
  }
  bool loadingAddRequest = false;
  Future<void> addRequest({
    required BuildContext context,
    required String title,
    required String work,
    required String reason,
})async{
    loadingAddRequest = true;
    emit(CharityAddRequestLoadingState());

    try{
      final response = await DioHelper.postData(url: ADD_REQUEST, data: {
        'title':title,
        'work':work,
        'reason':reason,
      });
      loadingAddRequest = false;
      emit(CharityAddRequestSuccessfullyState());
      showAwesomeSnackbar(context: context,
          message: 'Request Has been add successfully',
          contentType: ContentType.success);
    }catch(error){
      print(error);
      loadingAddRequest = false;
      // Extract the error message from the server response if available
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
      emit(CharityAddRequestErrorState());
    }
 }
  bool loadingPreviousRequest = false;
  bool isRequestGet = false;
  late List<PreviousRequestsModel> previousRequestModel;
  Future<void> getPreviousModel({
    required BuildContext context,
})async{
    loadingPreviousRequest = true;
    emit(CharityPreviousRequestLoadingState());

    try{
      final response = await DioHelper.getData(url: PREVIOUS_REQUEST);
      loadingPreviousRequest = false;
      isRequestGet = false;
      previousRequestModel = PreviousRequestsModel.fromJsonList(response.data);
      emit(CharityPreviousRequestSuccessfullyState());
    }catch(error){
      print(error);
      loadingPreviousRequest = false;
      isRequestGet = true;

      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.failure);
    }
    emit(CharityPreviousRequestErrorState());
  }
  Future<void> requestCancel({
    required BuildContext context,
    required int idRequest,
  }) async {
    try {
      final response = await DioHelper.postData(url: REQUEST_CANCEL, data: {
        'idRequest': idRequest.toString(),
      });
      showAwesomeSnackbar(
        context: context,
        message: 'Request has been deleted successfully',
        contentType: ContentType.success,
      );
       getPreviousModel(context: context);
      Navigator.of(context).pop();
      emit(CharityPreviousRequestDeleteSuccessfullyState());
    } catch (error) {
      print('Error while deleting the request: $error');
      showAwesomeSnackbar(
        context: context,
        message: 'Error deleting the request',
        contentType: ContentType.failure,
      );
      emit(CharityPreviousRequestDeleteErrorState());
    }
  }
  Future<void> donatForFund({
    required BuildContext context,
    required String amount,
})async{
    try{
      final response = await DioHelper.postData(url: DONATION_FOR_FUND, data: {
        'amount':amount,
      });
      if(response.statusCode == 200){
        showAwesomeSnackbar(context: context,
            message: 'Thank you for your donation of $amount SYP!',
            contentType: ContentType.success);
        walletAmount -= int.parse(amount);
        Navigator.pop(context);
        emit(CharityDonatForFundSuccessfullyState());
      }
    }catch(error){
      print(error);
      showAwesomeSnackbar(context: context,
          message: 'An error while Donat',
          contentType: ContentType.failure);
      emit(CharityDonatForFundErrorState());

    }
  }
  Future<void> donatToCampaign({
    required BuildContext context,
    required String id,
    required String amount,
})async{
    try{
      final response = await DioHelper.postData(url: DONATION_TO_CAMPAIGN, data: {
        'id':id,
        'amount':amount
      });
      if(response.statusCode == 200){
        showAwesomeSnackbar(context: context,
            message: 'Thank you for your donation of $amount SYP!',
            contentType: ContentType.success);
        walletAmount -= int.parse(amount);
        refresh();
        Navigator.pop(context);
        emit(CharityDonatToCampaignSuccessfullyState());
      }
    }catch(error){
      print(error);
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data['error'] ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.warning);
      emit(CharityDonatToCampaignErrorState());
    }
  }
  bool loadingRequests = false;
  late List<RequestsModel> requestsModel;
  Future<void> getRequests({

    required String start,
    required String count,
})async{
    loadingRequests = true;
    emit(CharityGetRequestsLoadingState());
    try{
      final response = await DioHelper.postData(url: REQUESTS, data: {
        'start':start,
        'count':count,
      });
      loadingRequests = false;
      if(response.statusCode == 200){
        requestsModel = RequestsModel.fromJsonList(response.data);
        emit(CharityGetRequestsSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingRequests = false;
      emit(CharityGetRequestsErrorState());
    }
  }


  bool loadingRequestDetails = false;
  late List<RequestDetailsModel> requestDetailsModel;
  Future<void> getRequestDetailsModel({
    required BuildContext context,
    required String id,
})async{
    loadingRequestDetails = true;
    emit(CharityRequestDetailsLoadingState());
    try{
      final response = await DioHelper.postData(url: REQUEST_DETAILS, data: {
        'id':id
      });
      loadingRequestDetails = false;
      if(response.statusCode == 200){
        requestDetailsModel = RequestDetailsModel.fromJsonList(response.data);
        emit(CharityRequestDetailsSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingRequestDetails = false;
      emit(CharityRequestDetailsErrorState());
    }
  }
  Future<void> donatToRequest({
    required BuildContext context,
    required String id,
    required String amount,
  })async{

    emit(CharityRequestDetailsLoadingState());
    try{
      final response = await DioHelper.postData(url: DONATION_TO_REQUEST, data: {
        'id':id,
        'amount':amount
      });

      if(response.statusCode == 200){
        showAwesomeSnackbar(context: context,
            message: 'Thank you for your donation of $amount SYP!',
            contentType: ContentType.success);
        refresh();
        walletAmount -= int.parse(amount);
        Navigator.pop(context);
        emit(CharityDonatToRequestSuccessfullyState());
      }
    }catch(error){
      print(error);
      String errorMessage = 'An error occurred';
      if (error is DioError && error.response != null) {
        errorMessage = error.response?.data['error'] ?? errorMessage;
      }
      showAwesomeSnackbar(context: context,
          message: errorMessage,
          contentType: ContentType.warning);

      emit(CharityDonatToRequestErrorState());
    }
  }
  bool loadingPreviousDonationCampaigns = false;
  late List<PreviousDonationCampaignsModel> previousDonationCampaignsModel;
  Future<void> getPreviousDonationCampaignsModel()async{
    loadingPreviousDonationCampaigns = true;
    emit(CharityPreviousDonationCampaignsLoadingState());
    try{
      final response = await DioHelper.getData(url: PREVIOUS_DONATION_CAMPAIGNS);
      if(response.statusCode == 200){
        previousDonationCampaignsModel = PreviousDonationCampaignsModel.fromJsonList(response.data);
        loadingPreviousDonationCampaigns = false;
        emit(CharityPreviousDonationCampaignsSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingPreviousDonationCampaigns = false;
      emit(CharityPreviousDonationCampaignsErrorState());
    }
  }
  bool loadingPreviousRequestsCampaigns = false;
  late List<PreviousDonationRequestsModel> previousDonationRequestsModel;
  Future<void> getPreviousDonationRequestsModel()async{
    loadingPreviousRequestsCampaigns = true;
    emit(CharityPreviousDonationRequestsLoadingState());
    try{
      final response = await DioHelper.getData(url: PREVIOUS_DONATION_REQUESTS);
      if(response.statusCode == 200){
        previousDonationRequestsModel = PreviousDonationRequestsModel.fromJsonList(response.data);
        loadingPreviousRequestsCampaigns = false;
        emit(CharityPreviousDonationRequestsSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingPreviousRequestsCampaigns = false;
      emit(CharityPreviousDonationRequestsErrorState());
    }
  }
  bool loadingUserData = false;
  late List<UserModel> userModel;
  Future<void> getUserData()async{
    loadingUserData = true;
    emit(CharityUserDataLoadingState());
    try{
      final response = await DioHelper.getData(url:USER_DATA);
      if(response.statusCode == 200){
        userModel = UserModel.fromJsonList(response.data);
        await CacheHelper.saveData(key: 'id', value: userModel.first.idKey);
        await CacheHelper.saveData(key: 'email', value: userModel.first.email);
        await CacheHelper.saveData(key: 'name', value: userModel.first.name);
        loadingUserData = false;
        emit(CharityUserDataSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingUserData = false;
      emit(CharityUserDataErrorState());
    }
  }
  bool loadingEditProfile = false;
  Future<void> editUser({
    required BuildContext context,
    required String name,
    required String fullNumber,
    required String Date,
    required String addr,
    required String userId,
})async{
    loadingEditProfile = true;
    emit(CharityEditProfileLoadingState());
    try{
      final response = await DioHelper.postData(url: EDIT_PROFILE, data: {
        'name':name,
        'fullNumber':fullNumber,
        'Date':Date,
        'addr':addr,
        'userId':userId,
      });
      loadingEditProfile = false;
      showAwesomeSnackbar(context: context,
          message: 'The profile has been edit successfully',
          contentType: ContentType.success);
      await getUserData();
      Navigator.pop(context);
      emit(CharityEditProfileSuccessfullyState());
    }catch(error){
      print(error);
      loadingEditProfile = false;
      showAwesomeSnackbar(context: context,
          message: 'Error while Editing Profile Information',
          contentType: ContentType.failure);
      emit(CharityEditProfileErrorState());
    }
  }
  bool loadingAboutUs = false;
  late List<AboutUsModel> aboutUsModel;
  Future<void> getAboutUs()async{
    loadingAboutUs = true;
    emit(CharityAboutUsLoadingState());
    try{
      final response = await DioHelper.getData(url: ABOUT_US);
      if(response.statusCode == 200){
        aboutUsModel = AboutUsModel.fromJsonList(response.data);
        loadingAboutUs = false;
        emit(CharityAboutUsSuccessfullyState());
      }
    }catch(error){
      print(error);
      loadingAboutUs = false;
      emit(CharityAboutUsErrorState());
    }
  }

  Future<void>logout({
    required BuildContext context,
})async{
    CacheHelper.removeData(key: 'token');
    CacheHelper.removeData(key: 'id');
    CacheHelper.removeData(key: 'email');
    CacheHelper.removeData(key: 'name');
    userModel.clear();
    currentIndex =0;
    emit(CharityLogoutSuccessfullyState());
    navigateAndFinish(context, LoginScreen());
  }
}
