      package com.adobe.cairngorm.samples.login.business
      {
          import com.adobe.cairngorm.business.ServiceLocator;
          import com.adobe.cairngorm.samples.login.vo.LoginVO;
          import mx.rpc.AsyncToken;
          import mx.rpc.IResponder;

          public class LoginDelegate
          {
              private var responder : IResponder;
              private var service : Object;

              public function LoginDelegate( responder : IResponder )
              {
                  this.service = ServiceLocator.getInstance().getService( "loginService" );
                  this.responder = responder;
              }

              public function login( loginVO : LoginVO ): void
              {
                  var token : AsyncToken = service.getUser(loginVO);
                  token.resultHandler = responder.result;
                  token.faultHandler = responder.fault;
              }
          }
      }
       

