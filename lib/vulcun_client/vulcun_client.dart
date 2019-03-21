//Will make calls to vulcun server
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

class VulcunClient {
  String accessToken, refreshToken, currentUsername;

  VulcunClient(this.accessToken, this.refreshToken);

  Future<bool> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Settings.outputAccessToken, this.accessToken);
    prefs.setString(Settings.outputRefreshToken, this.refreshToken);
    prefs.setString(Settings.usernameKeyword, this.currentUsername);
    return true;
  }

  Future<bool> retreiveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString(Settings.outputAccessToken);
    this.refreshToken = prefs.getString(Settings.outputRefreshToken);
    this.currentUsername = prefs.getString(Settings.usernameKeyword);
    return true;
  }

  Future<bool> checkAccessTokenExpired(String responseGiven) async {
    //Checks if accces token was expired
    print(responseGiven);
    Map output = json.decode(responseGiven);
    if (output[Settings.outputMsgKeyword] == Settings.outputTokenExpired) {
      String url = Settings.vulcunHostName + Settings.refreshTokenURL;
      Map<String, String> headers = {
        Settings.authorizationKeyword:
            Settings.bearerKeyword + " " + this.refreshToken
      };
      var response = await http.get(url, headers: headers);
      Map currentOutput = json.decode(response.body);
      this.accessToken = currentOutput[Settings.outputAccessToken];
      this.refreshToken = currentOutput[Settings.outputRefreshToken];
      return true;
    }

    return false;
  }

  Future<Map> requestForRegistration(Map userData) async {
    //Registers
    String url = Settings.vulcunHostName + Settings.registerURL + "?";

    userData.forEach((key, value) => {url += "$key=$value&"});
    url = url.substring(0, url.length - 1); //Removing last '&' sign

    var response = await http.post(url);

    Map<String, dynamic> output = json.decode(response.body);

    if (output[Settings.outputMsgKeyword] == Settings.outputWentWrong) {
      return output[Settings.outputErrorKeyword];
    } else {
      await this.requestForAuthenticate(userData[Settings.usernameKeyword],
          userData[Settings.passwordKeyword]);
    }

    return {"0" : Settings.responseSuccess};
  }

  Future<bool> signOut() async {
    //Revokes access and refresh token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Settings.outputAccessToken);
    prefs.remove(Settings.outputRefreshToken);
    prefs.remove(Settings.usernameKeyword);
    Map<String, String> accessTokenheaders = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };
    Map<String, String> refreshTokenheaders = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.refreshToken
    };
    http.delete(Settings.vulcunHostName + Settings.revokeAccessToken,
        headers: accessTokenheaders);
    http.delete(Settings.vulcunHostName + Settings.revokeRefreshToken,
        headers: refreshTokenheaders);

    return true;
  }

  Future<bool> requestForAuthenticate(String username, String password) async {
    //Returns url for basic auth
    String url = Settings.vulcunHostName + Settings.authenticateURL;
    url += "?";
    url += "${Settings.usernameKeyword}=$username&";
    url += "${Settings.passwordKeyword}=$password";
    var response = await http.post(url);
    print(response.body);
    Map output = json.decode(response.body);
    if (output[Settings.outputMsgKeyword] == Settings.outputWentWrong) {
      return false;
    }
    this.accessToken = output[Settings.outputAccessToken];
    this.refreshToken = output[Settings.outputRefreshToken];
    this.currentUsername = username;
    return true;
  }

  Future<Map<String, dynamic>> requestForViewUserData(String username) async {
    //Returns url for viewing user data
    String url = Settings.vulcunHostName +
        Settings.resourceHeader +
        Settings.viewUserData +
        username;
    
    Map<String, String> headers = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };
    var response = await http.get(url, headers: headers);
    Map<String, dynamic>  output= json.decode(response.body);
    if (await this.checkAccessTokenExpired(response.body)) {
      return this.requestForViewUserData(username);
    }
    return output;
  }

  Future<bool> requestForUpdateUserData(
      String username, String field, String newValue) async {
    //Update User Data
    String url = Settings.vulcunHostName +
        Settings.resourceHeader +
        Settings.updateUserData +
        username +
        "/" +
        field +
        "/" +
        newValue +
        "/";
    Map<String, String> headers = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };

    var response = await http.put(url, headers: headers);
    if (await this.checkAccessTokenExpired(response.body)) {
      return this.requestForUpdateUserData(username, field, newValue);
    }
    return true;
  }

  //MCQS

  Future<Map> requestForMCQSLeaderboard() async {
    //Will Get Leaderboard
    String url = Settings.vulcunHostName +
        Settings.resourceHeader +
        Settings.mcqsHeader +
        Settings.leaderboard;
    Map<String, String> headers = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };
    var response = await http.get(url, headers: headers);
    if (await this
        .checkAccessTokenExpired(response.body.replaceAll("'", '"'))) {
      return this.requestForMCQSLeaderboard();
    }

    Map output = json.decode(response.body.replaceAll("'", '"'));
    return output;
  }

  Future<Map> requestForMCQSGenerateMCQS(String subject) async {
    //Will Get MCQS From Server
    String url = Settings.vulcunHostName +
        Settings.resourceHeader +
        Settings.mcqsHeader +
        Settings.generateMCQS +
        subject;
    Map<String, String> headers = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };
    var response = await http.get(url, headers: headers);
    if (await this.checkAccessTokenExpired(response.body)) {
      return this.requestForMCQSGenerateMCQS(subject);
    }
    Map output = json.decode(response.body);
    return output;
  }

  Future<Map> requestForVerifyMCQReciept(String subject, String receipt) async {
    //Will Post MCQ Reciept For Verification
    String url = Settings.vulcunHostName +
        Settings.resourceHeader +
        Settings.mcqsHeader +
        Settings.recieptMCQS +
        subject +
        "/" +
        receipt +
        "/";
    Map<String, String> headers = {
      Settings.authorizationKeyword:
          Settings.bearerKeyword + " " + this.accessToken
    };
    var response = await http.post(url, headers: headers);
    print(response.body);
    if (await this.checkAccessTokenExpired(response.body)) {
      return this.requestForVerifyMCQReciept(subject, receipt);
    }
    Map output = json.decode(response.body);
    return output;
  }
}
