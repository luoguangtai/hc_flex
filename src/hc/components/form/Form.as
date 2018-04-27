package hc.components.form
{
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	
	import spark.components.Group;
	import spark.layouts.VerticalLayout;
	
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	public class Form extends spark.components.Form
	{
		private var _formLayout:FormLayout;	//布局
		private var _dataValue:Object = null;
		
		public function Form()
		{
			super();
			_formLayout = new FormLayout();
			this.layout = _formLayout;
		}
		/**
		 * 布局显示的列数 
		 * @return 
		 * 
		 */
		public function get columnCount():int
		{
			return _formLayout.columnCount;
		}
		
		public function set columnCount(value:int):void
		{		
			_formLayout.columnCount = value;
		}	
		
		//-------------------------------------
		//	hGap
		//-------------------------------------
		
		/**
		 * Form上的FormItem列之间的水平间距 
		 * @return 
		 * 
		 */
		public function get hGap():Number{
			return _formLayout.hGap;
		}
		
		public function set hGap(value:Number):void{
			_formLayout.hGap=value;
		}
		
		//-------------------------------------
		//	vGap
		//-------------------------------------
		
		/**
		 * Form上的FormItem行之间的竖直间距
		 * @return 
		 * 
		 */
		public function get vGap():Number{
			return _formLayout.vGap;
		}
		
		public function set vGap(value:Number):void{	
			_formLayout.vGap=value;
		}
		
		
		//-------------------------------------
		//	paddingBottom
		//-------------------------------------
		
		public function get paddingBottom():Number
		{
			return _formLayout.paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_formLayout.paddingBottom = value;
		}
		
		//-------------------------------------
		//	paddingTop
		//-------------------------------------
		public function get paddingTop():Number
		{
			return _formLayout.paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_formLayout.paddingTop = value;
		}
		
		//-------------------------------------
		//	paddingRight
		//-------------------------------------
		public function get paddingRight():Number
		{
			return _formLayout.paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_formLayout.paddingRight=value;
		}
		
		//-------------------------------------
		//	paddingLeft
		//-------------------------------------
		public function get paddingLeft():Number
		{
			return _formLayout.paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_formLayout.paddingLeft = value;
		}
		/**
		 * 表单验证,返回true则通过
		 */ 
		public function validate():Boolean{
			var rs:Boolean = true;
			var items:Array = getAllFormItems();
			var formItem:FormItem;
			for(var i:int = 0 ; i < items.length; i++){
				formItem = items[i] as FormItem;
				if(!formItem.validate()){
					rs = false;
				}
			}
			return rs;
		}
		
		/**
		 * 给表单设置值
		 */ 
		public function set dataValue(obj:Object):void{
			_dataValue = obj;
			var items:Array = getAllFormItems();
			var formItem:FormItem;
			for(var i:int = 0 ; i < items.length; i++){
				formItem = items[i] as FormItem;
				formItem.dataValue = obj;
			}
		}
		
		/**
		 * 取表单的值
		 */ 
		public function get dataValue():Object{
			var items:Array = getAllFormItems();
			var formItem:FormItem;
			var obj:Object = _dataValue;
			if(Util.isBlank(obj)){
				obj = {};
			}
			for(var i:int = 0 ; i < items.length; i++){
				formItem = items[i] as FormItem;
				Util.copy(formItem.dataValue, obj);
			}
			return obj;
		}
		
		/**
		 * 表单重置
		 */ 
		public function reset(exceptFiledName:Array=null):void{
			_dataValue = {};
			var items:Array = getAllFormItems();
			var formItem:FormItem;
			for(var i:int = 0 ; i < items.length; i++){
				formItem = items[i] as FormItem;
				formItem.reset(exceptFiledName);
			}
		}
		
		public function set editable(v:Boolean):void{
			var items:Array = getAllFormItems();
			var formItem:FormItem;
			for(var i:int = 0 ; i < items.length; i++){
				formItem = items[i] as FormItem;
				formItem.editable = v;
			}
		}
		
		/**
		 * 从服务器加载数据
		 */ 
		public function loadData(url:String, param:Object):void{
			this.reset();
			HttpUtil.doPost(url, param, function(obj:Object):void{
				dataValue = obj;
			});
		}
		
		/**
		 * 向服务器提交表单数据,会自动验证表单内的所有元素
		 * 为了避免表单重复提交，可以传入触发表单提交的按钮，会自动禁用，完成后启用
		 */ 
		public function submit(url:String, callabck:Function = null):void{
			if(this.validate()){
				HttpUtil.doPost(url, this.dataValue, callabck, null, true);
			}
		}
		
		/**
		 * 取表单所有的FormItem
		 */
		public function getAllFormItems():Array{
			var items:Array = new Array();
			findFormItems(this, items);
			return items;
		}
		
		private static function findFormItems(component:IVisualElementContainer,formItems:Array):void{
			if(component){
				for(var m:int = 0 ;m<component.numElements ; m++){
					var tmpObj:IVisualElement = component.getElementAt(m);
					if(tmpObj is FormItem){
						formItems.push(tmpObj);
					}else if(tmpObj is IVisualElementContainer){
						findFormItems(tmpObj as IVisualElementContainer,formItems);
					}
				}
			}
		}
	}
}