//Setting For Dart


class Settings {
  //Main Settings
  static final String vulcunHostName = "http://zerotechh6677.pythonanywhere.com";


  //KEYWORDS
  static final String usernameKeyword = "USERNAME";
  static final String passwordKeyword = "PASSWORDHASH";
  static final String emailKeyword = "EMAIL";
  static final String firstNameKeyword = "FIRSTNAME";
  static final String lastNameKeyword = "LASTNAME";
  static final String citydKeyword = "CITY";
  static final String stateKeyword = "STATE";
  static final String trackingKeyword = "TRACKING";
  static final String questionKeyword = "QUESTION";
  static final String optionsKeyword = "OPTIONS";
  static final String optionSelectedKeyword = "OPTIONSELECTED";
  static final String authorizationKeyword = "Authorization";
  static final String bearerKeyword = "Bearer";


  //API URLS
  //MAIN URLs
  static final String authenticateURL = "/authenticate/";
  static final String registerURL = "/register/";
  static final String freshAuthenticateURL = "/fresh-authenticate/";
  static final String refreshTokenURL = "/refresh/";
  static final String revokeAccessToken = "/revoke-access-token/";
  static final String revokeRefreshToken = "/revoke-refresh-token/";

  static final String outputMsgKeyword = "msg";
  static final String outputErrorKeyword = "error";
  static final String outputTokenExpired = "Token has expired";
  static final String outputWentWrong = "Something Went Wrong";
  static final String outputAccessToken = "access_token";
  static final String outputRefreshToken = "refresh_token";

  //USER DATA URLs
  static final String resourceHeader = "/resource";
  static final String viewUserData = "/view-user-data/";
  static final String updateUserData = "/update-user-data/";

  //MCQS URLs
  static final String mcqsHeader = "/mcqs";
  static final String generateMCQS = "/generate_mcqs/";
  static final String leaderboard = "/leaderboard";
  static final String recieptMCQS = "/verify_reciept/";

  static final responseSuccess= "Success";

}