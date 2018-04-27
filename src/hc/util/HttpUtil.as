package hc.util
{
	import hc.components.MessageDialog;
	
	import flash.net.URLVariables;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	public class HttpUtil
	{
		private static const POST:String = 'POST';
		private static const CONTENT_TYPE_FORM_UTF8:String = 'application/x-www-form-urlencoded;charset=UTF-8';
		
		//服务器的URL，在开发阶段通过修改index.template.html赋值
		private static var _serverURL:String = null;
		private static function get serverURL():String{
			if(_serverURL==null){
				_serverURL = FlexGlobals.topLevelApplication.parameters['serverURL'];
				if(Util.isBlank(_serverURL)){
					_serverURL = '';
				}
			}
			return _serverURL;
		}
		/**
		 * 向服务端发送POST请求 ，开发阶段通过修改index.template.html加入serverURL指定服务器地址，部署的时候去掉serverURL
		 * @param action			请求地址
		 * @param params			发送数据,可以是URLVariables，或者普通的Object（自动转换成URLVariables提交）
		 * @param callback			回调方法
		 * @param callbackFault		请求失败回调方法
		 * @param showBusyCursor	是否显示繁忙图标，默认不显示
		 * @param target			调用此方法的组件，通常是Button，用来防止表单重复提交；改成显示进度条来防止重复提交
		 * @param returnJson		是否反回json对象,如果为false则返回text
		 * @param charset           编码，经测试采用 'application/x-www-form-urlencoded;charset=GBK'也没用，需要在调用的界面上加System.useCodepage = true
		 */
		public static function doPost(action:String, 
									  params:Object=null, 
									  callback:Function = null, 
									  callbackFault:Function = null,
									  showBusyCursor:Boolean = false, 
									  returnJson:Boolean = true):void{
			var http:HTTPService = new HTTPService();
			http.rootURL = HttpUtil.serverURL;
			http.url = action;
			http.method = POST;
			http.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			http.contentType = CONTENT_TYPE_FORM_UTF8;
//			http.showBusyCursor = showBusyCursor;
			//禁用组件，防止表单重复提交
//			if(target){
//				target.enabled = false;
//			}
			//弹出滚动条，也可以防止表单重复提交；在加载表格、提交表单的时候使用
			if(showBusyCursor){
				//移出焦点防止重复提交
				Util.removeFocus();
				//如果是按钮则让按钮失去焦点
				http.showBusyCursor = true;
				Util.showProgress();
			}
			
			//如果回调函数不为空则增加事件
			http.addEventListener(ResultEvent.RESULT,function(event:ResultEvent):void{
				//返回值
				var rs:String = event.result.toString();
				if(returnJson){
					try{
						var json:Object = JSON.parse(rs);
						//成功，返回数据
						if(json.success){
							if(callback!=null){
								callback(json.data);
							}
						}
						//处理失败
						else{
							if(callbackFault!=null){
								callbackFault(json.errors);
							}
							else{
								MessageDialog.error(getErrorMsg(json.errors));
							}
						}
					}
					//JSON格式错误
					catch(err:Error){
						MessageDialog.error('错误：' + err.message);
					}
				}
				else if(callback!=null){
					callback(rs);
				}
				//移除繁忙光标，偶尔会一直转
				if(showBusyCursor){
					CursorManager.removeBusyCursor();
					Util.closeProgress();
				}
				
//				if(target){
//					target.enabled = true;
//				}
			});
			//请求失败，这个是指404、500错误
			http.addEventListener(FaultEvent.FAULT,function(event:FaultEvent):void{
				if(callbackFault!=null){
					callbackFault(event.fault.toString());
				}
				else{
					MessageDialog.error(event.fault.toString());
				}
				
				//移除繁忙光标，否则会一直转
				if(showBusyCursor){
					CursorManager.removeBusyCursor();
					Util.closeProgress();
				}
				
//				if(target){
//					target.enabled = true;
//				}
			});
			http.send(toURLVariables(params));
		}
		
		/**
		 * 输入参数创建URLVariables，调用方法 HttpUtil.param('id','1111','name','test');过滤掉空值
		 */
		public static function param(arg:*,... rest):URLVariables{
			var param:URLVariables = new URLVariables();
			for(var i:int=0;i<rest.length;i+=2){
				if(Util.isNotBlank(rest[i+1])){
					param[rest[i]] = rest[i+1];
				}
			}
			return param;
		}
		
		/**
		 * 把Object转换成URLVariables
		 * 如果obj等于null，则返回null
		 * 如果obj是字符串、数值、日期或者是数组，则赋予param参数名
		 * 如果是{id:'aaa',name:'bbb'}这类对象，把值赋给URLVariables
		 */ 
		public static function toURLVariables(obj:Object):URLVariables{
			if(obj==null){
				return null;
			}
			if(obj is URLVariables){
				//删除为空的属性，避免传"null"字符串到服务端
				if(obj!=null){
					for(var t:String in obj){
						if(obj[t]==null){
							delete obj[t];
						}
					}
				}
				return obj as URLVariables;
			}
			
			var param:URLVariables = new URLVariables();
			if(obj is Number || obj is String || obj is Boolean || obj is uint || obj is Date || obj is Array){
				param['param'] = obj;
			}
			else{
				var claInfo:Object = ObjectUtil.getClassInfo(obj);           
				var props:Array = claInfo["properties"] as Array;  
				for each(var q:QName in props){
					if(Util.isNotBlank(obj[q.localName])){
						param[q.localName] = obj[q.localName];
					}
				}  
			}
			return param;
		}
		
		/**
		 * 把多个错误消息拼成一串
		 */ 
		private static function getErrorMsg(obj:Object):String{
			if(obj is String || obj is Number || obj is Boolean || obj is uint || obj is Date){
				return obj.toString();
			}
			else if(obj is Array){
				return (obj as Array).join('\n');
			}
			else{
				var str:String = '';
				var claInfo:Object = ObjectUtil.getClassInfo(obj);           
				var props:Array = claInfo["properties"] as Array;  
				for each(var q:QName in props){
					if(Util.isNotBlank(obj[q.localName])){
						str += obj[q.localName] + '\n';
					}
				} 
				return str;
			}
		}
	}
}