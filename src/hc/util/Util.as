package hc.util
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.ProgressBar;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import spark.components.Button;
	import spark.modules.Module;
	import spark.modules.ModuleLoader;
	
	public class Util
	{
		//加载公共类，避免Module的时候无法使用公共类；通过在编译参数增加-keep-all-type-selectors=true解决
//		public static function importCommonClass():void{
//			var alert:Alert;
//			var popupManager:PopUpManager;
//			var dragManager:DragManager;
//			var progressBar:ProgressBar;
//			var titleWindow:TitleWindow;
//		}
		//调试信息
		public static function debug(obj:Object):void{
			Alert.show(ObjectUtil.toString(obj));
		}
		
		/**
		 * 将第一个对象的属性复制给第二个对象
		 */ 
		public static function copy(srcObj:Object, toObj:Object):void{
			if(srcObj==null || toObj==null){
				return;
			}
			
			var claInfo:Object = ObjectUtil.getClassInfo(srcObj);           
			var props:Array = claInfo["properties"] as Array;  
			for each(var q:QName in props){
				toObj[q.localName] = srcObj[q.localName];
			}  
		}
		
		/**
		 * 深度复制
		 */
		public static function clone(source:Object):*{
			var myBA:ByteArray = new ByteArray();   
			myBA.writeObject(source);     
			myBA.position = 0;       
			return(myBA.readObject());
		}
		
		/**
		 * 判断一个对象是否为空，如果是String则trim后判断字符串长度
		 */
		public static function isBlank(obj:Object):Boolean{
			 if(obj==null){
				 return true;
			 }
			 if(obj is String){
				 var str:String = obj as String;
				 if(StringUtil.trim(str).length==0){
					 return true
				 }
				 else{
					 return false;
				 }
			 }
			 else{
				 return false;
			 }
		}
		
		/**
		 * 判断一个对象是否不为空，如果是String，
		 */
		public static function isNotBlank(obj:Object):Boolean{
			return !isBlank(obj);
		}
		
		//找出应该选中的节点
		public static function getItemFromListData(obj:IList, keyName:String, keyValue:String):Object{
			var item:Object;
			for each(var o:Object in obj){
				if(o[keyName] == keyValue){
					item = o;
					break;
				}
			}
			return item;
		}
		
		//格式化文件大小
		public static function formatFileSize(num:Number):String{
			var strReturn:String; 
			var numSize:Number = Number(num / 1024);
			strReturn = String(numSize.toFixed(1) + " KB");
			if (numSize > 1024) {
				numSize = numSize / 1024;
				strReturn = String(numSize.toFixed(1) + " MB");
				if (numSize > 1024) {
					numSize = numSize / 1024;
					strReturn = String(numSize.toFixed(1) + " GB");
				}
			}				
			return strReturn;
		}
		
		/**
		 * 让下一个组件获得焦点，类似TAB的功能
		 */ 
		public static function nextComponent(event:KeyboardEvent, fm:IFocusManager):void{
			if(event.keyCode==Keyboard.ENTER){
				var nextComponent:IFocusManagerComponent = 	fm.getNextFocusManagerComponent(); 
				if(nextComponent){
					nextComponent.setFocus();
				}
			}
		}
		
		/**
		 * 为ModuleLoader指定url，加载Module
		 */
		public static function loadModule(ml:ModuleLoader, url:String):void{
			var mchild:Module = ml.child as Module;
			if(mchild!=null){
				mchild.removeAllElements();
				mchild = null;
			}
			ml.unloadModule();
			System.gc();
			
			if (url.indexOf("?")>0){
				url += "&" + new Date().time;			
			}
			else{
				url += "?" + new Date().time;
			}
			ml.url = url;
			ml.loadModule();
		}
		
		/**
		 * 显示进度条
		 */ 
		private static var progressBar:ProgressBar;
		public static function showProgress():void{
			if(progressBar==null){
				progressBar = new ProgressBar();
				progressBar.indeterminate = true;
				progressBar.labelPlacement = 'center';
				progressBar.label = '请稍候...';
				progressBar.height = 35;
				progressBar.setStyle('barColor', 0x339933);
			}
			PopUpManager.removePopUp(progressBar);
			PopUpManager.addPopUp(progressBar, Sprite(FlexGlobals.topLevelApplication), true);
			PopUpManager.centerPopUp(progressBar);
		}
		
		/**
		 * 隐藏进度条
		 */ 
		public static function closeProgress():void{
			if(progressBar!=null){
				PopUpManager.removePopUp(progressBar);
			}
		}
		
		/**
		 * 移出焦点，防止重复按回车键多次提交
		 */
		public static function removeFocus():void{
			if((FlexGlobals.topLevelApplication as UIComponent).stage!=null){
				(FlexGlobals.topLevelApplication as UIComponent).stage.focus = null;
			}
		}
		
		/**
		 * 设置当前焦点的按钮状态，用在提交的时候禁用按钮；问题是禁用后如果再按TAB切换焦点，这个按钮就不会再恢复了
		 */
		public static function setFocusButtonEnabled(v:Boolean = true):void{
			var comp:IFocusManagerComponent = (FlexGlobals.topLevelApplication as UIComponent).focusManager.getFocus();
			if(comp!=null && comp is Button){
				(comp as Button).enabled = v;
			}
		}
		/**
		 * 实现ArrayList的group by和sum
		 * @param beforeGroupBySumList group by前的list
		 * @param afterGroupBySumList group by后的list
		 * @param groupByFieldArry group by字段
		 * @param sumFieldArry sum字段
		 * @param conFieldArry connect字段 连接字段
		 * */
		public static function groupBySumList(beforeGroupBySumList:ArrayList,afterGroupBySumList:ArrayList
											  ,groupByFieldArry:Array,sumFieldArry:Array=null,conFieldArry:Array=null):void{
			if(beforeGroupBySumList==null) return;
			if(groupByFieldArry==null) return;
			for(var m:int=0;m<beforeGroupBySumList.length;m++){
				var beforeGroupByObj:Object = beforeGroupBySumList.getItemAt(m);
				var afterGroupBySumObj:Object = getMatchListObject(afterGroupBySumList,beforeGroupByObj,groupByFieldArry);
				if(Util.isNotBlank(afterGroupBySumObj)){
					if(Util.isNotBlank(sumFieldArry)){
						for(var j:int=0;j<sumFieldArry.length;j++){
							var sumField:String = sumFieldArry[j];
							var sumFieldValue1:Number = Util.isNotBlank(afterGroupBySumObj[sumField])?Number(afterGroupBySumObj[sumField]):0;
							var sumFieldValue2:Number = Util.isNotBlank(beforeGroupByObj[sumField])?Number(beforeGroupByObj[sumField]):0;
							afterGroupBySumObj[sumField]=sumFieldValue1+sumFieldValue2;
						}
					}
					if(Util.isNotBlank(conFieldArry)){
						for(var k:int=0;k<conFieldArry.length;k++){
							var conField:String = conFieldArry[k];
							var conFieldValue1:String = Util.isNotBlank(afterGroupBySumObj[conField])?String(afterGroupBySumObj[conField]):"";
							var conFieldValue2:String = Util.isNotBlank(beforeGroupByObj[conField])?String(beforeGroupByObj[conField]):"";
							if(Util.isNotBlank(conFieldValue1)&&Util.isNotBlank(conFieldValue2)){
								afterGroupBySumObj[conField]=conFieldValue1+"|"+conFieldValue2;
							}else{
								afterGroupBySumObj[conField]=conFieldValue1+conFieldValue2;
							}
						}
					}
				}else{
					afterGroupBySumList.addItem(beforeGroupByObj);
				}
			}
		}
		/**
		 * 查找list匹配的object
		 * */
		private static function getMatchListObject(afterGroupBySumList:ArrayList,beforeGroupByObj:Object,groupByFieldArry:Array):Object{
			if(groupByFieldArry==null) return null;
			var returnObj:Object = null;
			for(var n:int=0;n<afterGroupBySumList.length;n++){
				var afterGroupBySumObj:Object = afterGroupBySumList.getItemAt(n);
				var matchFlag:Boolean=true;
				for(var k:int=0;k<groupByFieldArry.length;k++){
					var matchField:String  = groupByFieldArry[k];
					if(afterGroupBySumObj[matchField] != beforeGroupByObj[matchField]){
						matchFlag=false;
					}
				}
				if(matchFlag)
				{
					returnObj =  afterGroupBySumObj;
					break;
				}
			}
			return returnObj;
		}
	}
}