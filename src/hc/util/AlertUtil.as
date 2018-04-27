package hc.util
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class AlertUtil
	{
		[Embed(source="/assets/icon/alert_questionbig.png")]
		[Bindable]
		private static var questionIcon:Class;
		
		[Embed(source="/assets/icon/alert_errorbig.png")]
		[Bindable]
		private static var errorIcon:Class;
		
		[Embed(source="/assets/icon/alert_okbig.png")]
		[Bindable]
		private static var successIcon:Class;
		
		[Embed(source="/assets/icon/alert_infobig.png")]
		[Bindable]
		private static var infoIcon:Class;
		
		[Embed(source="/assets/icon/alert_warningbig.png")]
		[Bindable]
		private static var warningIcon:Class;
		
		Alert.yesLabel = '是';
		Alert.noLabel = "否";
		Alert.okLabel = "确定";
		
		public static function show(title:String, message:String, flags:uint, defaultButtonFlag:uint, 
									icon:Class, callback:Function=null, width:int=300, height:int=180):Alert{
			var t:Alert = Alert.show(message, title, flags, null, function(event:CloseEvent):void{
				if(callback!=null){
					callback(event);
				}
			}, icon, defaultButtonFlag);
			t.width = width;
			t.height = height;
			t.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):void{
				if(event.keyCode==Keyboard.ESCAPE)
				{
					PopUpManager.removePopUp(t);
				}
			});
			return t;
		}
		
		//确认
		public static function confirm(title:String, message:String, yesHandle:Function, width:int=300, height:int=180):Alert{
			return AlertUtil.show(title, message, Alert.YES|Alert.NO, Alert.YES, questionIcon, function(event:CloseEvent):void{
				if(event.detail == Alert.YES){
					yesHandle();
				}
			}, width, height);
		}
		
		//确认删除
		public static function confirmDelete(yesHandle:Function, width:int=300, height:int=180):Alert{
			return AlertUtil.show("确定删除", "确定删除选中的数据吗？", Alert.YES|Alert.NO, Alert.NO, questionIcon, function(event:CloseEvent):void{
				if(event.detail == Alert.YES){
					yesHandle();
				}
			}, width, height); 
		}
		
		//错误
		public static function error(msg:String, width:int=300, height:int=180):Alert{
			return AlertUtil.show("错误", msg, Alert.OK, Alert.OK, errorIcon, null, width, height); 
		}
		
		//成功
		public static function success(msg:String, width:int=300, height:int=180):Alert{
			return AlertUtil.show("成功", msg, Alert.OK, Alert.OK, successIcon, null, width, height); 
		}
		
		public static function info(msg:String, width:int=300, height:int=180):Alert{
			return AlertUtil.show("信息", msg, Alert.OK, Alert.OK, infoIcon, null, width, height);
		}
		
		//警告
		public static function warning(msg:String, width:int=300, height:int=180):Alert{
			return AlertUtil.show("警告", msg, Alert.OK, Alert.OK, warningIcon, null, width, height);
		}
		
	}
}