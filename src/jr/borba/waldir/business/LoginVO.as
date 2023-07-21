      package com.adobe.cairngorm.samples.login.vo
      {
          import com.adobe.cairngorm.vo.ValueObject;
          
          [RemoteClass(alias="com.adobe.cairngorm.samples.login.vo.LoginVO")]
          [Bindable]
          
          public class LoginVO implements ValueObject
          {
              public var username : String;
              public var password : String;
              public var loginDate : Date;
          }   
      }

