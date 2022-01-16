class SignVerificationMethods {
  static int minAge=18,
             maxAge=100;
  static bool isNameValid(String s) {
    return s.length>=3;
  }
  static bool isPhoneNumberValid(String s) {
    if(s.length<9 || s.length>16) {
      return false;
    }
    if(s[0]!='+' && (s[0].compareTo('0')<0 || s[0].compareTo('9')>0) ) {
      return false;
    }
    for(int i=1; i<s.length; ++i) {
      if(s[i].compareTo('0')<0 || s[i].compareTo('9')>0) {
        return false;
      }
    }
    return true;
  }
  static bool isDateBirthValid(String s) {
    List<String> lt=s.split("/");
    if(lt.length!=3) {
      return false;
    }
    int day, month, year;
    try {
      day=int.parse(lt[0].trim());
      month=int.parse(lt[1].trim());
      year=int.parse(lt[2].trim());
    }catch(err) {
      return false;
    }
    bool leapYear(int year) {
      return (year%400==0)||((year%4==0)&&(year%100!=0));
    }
    int numberOfDayInMonth(int month, int year) {
      if(month<1 || month>12) {
        return -1;
      }
      if(month==2) {
        return 28+(leapYear(year)?1:0);
      }
      if(month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12) {
        return 31;
      }
      return 30;
    }
    if(day<1 || month<1 || month>12 || year<1900 || day>numberOfDayInMonth(month, year)) {
      return false;
    }
    DateTime dtNow=DateTime.now();
    int _day=dtNow.day,
        _month=dtNow.month,
        _year=dtNow.year,
        differenceInYear;
    if(_day<day) {
      --_month;
    }
    if(_month<month) {
      --_year;
    }
    differenceInYear=_year-year;
    // print("$_year $year $differenceInYear");
    return differenceInYear>=minAge && differenceInYear<=maxAge;
  }
  static bool isEmailValid(String s) {
    return (new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")).hasMatch(s);
  }
  static bool isPasswordValid(String s) {
    if(s.length<8) {
      return false;
    }
    return true;
    String numbers = "0123456789",
           lowerCase = "abcdefghijklmnopqrstuvwxyz",
           upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
           specialCharacters = "!@#%^_()-+?";
    bool numbersExist=false,
        lowerCaseExist=false,
        upperCaseExist=false,
        specialCharactersExist=false;
    for(int i=0; i<s.length; ++i) {
      if(numbers.indexOf(s[i])!=-1) {
        numbersExist=true;
      }else if(lowerCase.indexOf(s[i])!=-1) {
        lowerCaseExist=true;
      }else if(upperCase.indexOf(s[i])!=-1) {
        upperCaseExist=true;
      }else if(specialCharacters.indexOf(s[i])!=-1) {
        specialCharactersExist=true;
      }
      if(numbersExist &&
          lowerCaseExist &&
          upperCaseExist &&
          specialCharactersExist) {
        return true;
      }
    }
    return false;
  }
}