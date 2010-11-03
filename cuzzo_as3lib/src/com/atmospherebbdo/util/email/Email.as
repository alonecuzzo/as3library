package com.atmospherebbdo.util.email 
{
	import com.atmospherebbdo.log.ILog;
	import com.atmospherebbdo.log.LogFactory;
	import com.atmospherebbdo.log.LogLevel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;	

	/**
	 * Dispatched when a server-side script that sends email returns success.
	 * 
	 * @eventType com.atmospherebbdo.util.email.EmailEvent.SUCCESS
	 */
	[Event(name="emailSuccess", type="com.atmospherebbdo.util.email.EmailEvent")]

	/**
	 * Dispatched when a server-side script that sends email returns success.
	 * 
	 * @eventType com.atmospherebbdo.util.email.EmailEvent.FAILURE
	 */
	[Event(name="emailFailure", type="com.atmospherebbdo.util.email.EmailEvent")]
	/**	 * @author markhawley	 */	public class Email extends EventDispatcher
	{
		private var log:ILog;
		
		private var toName:String;
		private var toEmail:String;
		private var fromName:String;
		private var fromEmail:String;
		private var subject:String;
		private var body:String;
		
		/**
		 * Build an email with this constructor.
		 * 
		 * @param	toName	String, the name to send email to
		 * @param	toEmail	String, the address to send email to
		 * @param	fromName	String, the name to appear to come from
		 * @param	fromEmail	String, the address to appear to come from
		 * @param	subject	String, the email subject line. Certain tokens
		 * 			may be used here -- see below.
		 * @param	messageTemplate	String, the body of the email. Certain
		 * 			tokens may be used here -- see below.
		 * @param	personalMessage	String, a message that may be added to the
		 * 			messageTemplate or subject via special tokens.
		 * @param	siteURL	String, a link that may be added via a special token
		 * 			in the messageTemplate or subject line.
		 */
		public function Email( toName:String, toEmail:String, fromName:String, 
			fromEmail:String, subject:String, messageTemplate:String, 
			personalMessage:String="", siteURL:String="")
		{
			log = LogFactory.getLog( this, LogLevel.INFO );
			log.info("Email(%s)", arguments);
			
			this.toName = toName;
			this.toEmail = toEmail;
			this.fromName = fromName;
			this.fromEmail = fromEmail;
			
			// push the siteURL, a personal message, etc. into your subject
			// or message body...
			
			this.subject = subject
				.replace("##FROM_NAME##", fromName)
				.replace("##TO_NAME##", toName)
				.replace("##PERSONAL_MESSAGE##", personalMessage)
				.replace("##SITE_URL##", siteURL);
			
			this.body = messageTemplate
				.replace("##FROM_NAME##", fromName)
				.replace("##TO_NAME##", toName)
				.replace("##PERSONAL_MESSAGE##", personalMessage)
				.replace("##SITE_URL##", "<a href="+siteURL+">"+siteURL+"</a>");
		}

		/**
		 * Sends this email.
		 * 
		 * @param	mailScript	String (defaults to the usual script)
		 * @param	proxyScript	String (defaults to a proxy.php in the same 
		 * 						directory as the current html file.)
		 */
		public function send( 
			mailScript:String="http://72.3.133.92/scripts/sendToFriend/sendtofriend.php", 
			proxyScript:String="proxy.php" ) :void
		{
			var url:String = null == proxyScript ? mailScript : proxyScript;
			
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			requestVars.body = body;
			requestVars.toName = toName;
			requestVars.toEmail = toEmail;
			requestVars.fromEmail = fromEmail;
			requestVars.fromName = fromName;
			requestVars.subject = subject;
			requestVars.proxiedScript = mailScript;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);

			try 
			{
				urlLoader.load(request);
			} 
			catch (e:Error) 
			{
				dispatchEvent(new EmailEvent(EmailEvent.FAILURE, toEmail, fromEmail));
			}
		}

		private function loaderCompleteHandler(e:Event):void 
		{
			var responseVars:URLVariables = URLVariables( e.target.data );
			log.info( "responseVars: " + responseVars );
			log.info( "success: " + responseVars.success);
			
			if (responseVars.success == 1)
			{
				dispatchEvent(new EmailEvent(EmailEvent.SUCCESS));
			}
			else
			{
				dispatchEvent(new EmailEvent(EmailEvent.FAILURE));
			}
		}

		private function httpStatusHandler( e:HTTPStatusEvent ):void 
		{
			// do nothing
		}

		private function securityErrorHandler( e:SecurityErrorEvent ):void 
		{
			dispatchEvent(new EmailEvent(EmailEvent.FAILURE));
		}

		private function ioErrorHandler( e:IOErrorEvent ):void 
		{
			dispatchEvent(new EmailEvent(EmailEvent.FAILURE));
		}
	}}