      package com.adobe.cairngorm.samples.login.commands
      {
          import com.adobe.cairngorm.commands.Command;
          import com.adobe.cairngorm.control.CairngormEvent;
          import com.adobe.cairngorm.samples.login.business.LoginDelegate;
          import com.adobe.cairngorm.samples.login.control.LoginEvent;
          import com.adobe.cairngorm.samples.login.model.ModelLocator;
          import mx.rpc.IResponder;
          
          public class LoginCommand implements Command, IResponder
          {
              private var model : ModelLocator = ModelLocator.getInstance();
              public function execute( event : CairngormEvent ) : void
              {
                  model.login.isPending = true;
                  var delegate : LoginDelegate = new LoginDelegate( this );   
                  var loginEvent : LoginEvent = event as LoginEvent; 
                  delegate.login( loginEvent.loginVO );        
              }
              public function result( event : Object ) : void
              {         
                  model.login.loginVO = event.result;
                  model.login.loginDate = new Date();
                  model.login.isPending = false;
                  model.workflowState = ModelLocator.VIEWING_LOGGED_IN_SCREEN;
              }
              public function fault( event : Object ) : void
              {
                  model.login.statusMessage = event.fault.faultString;
                  model.login.isPending = false;
                  model.workflowState = ModelLocator.VIEWING_ERROR_SCREEN;
              }
          }
      }

