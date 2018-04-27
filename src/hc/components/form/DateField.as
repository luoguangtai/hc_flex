package hc.components.form
{
	import hc.util.DateUtil;
	import hc.util.Util;
	
	import flash.events.KeyboardEvent;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	[IconFile("/assets/icon/icon_dateField.png")]
	public class DateField extends mx.controls.DateField implements IFormItemComponent
	{
		public var required:Boolean = false;//是否必填,如果为true则表示必填，不能为空
		
		public function DateField()
		{
			super();
			dayNames =["日","一","二","三","四","五","六"];
			monthNames=['1','2','3','4','5','6','7','8','9','10','11','12'];
			monthSymbol = "月";
			yearSymbol="年"
			formatString="YYYY-MM-DD";
			yearNavigationEnabled=true;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{
				reset();
			});
		}
		
		//回车将光标移动到下一个组件
		override protected function keyDownHandler(event:KeyboardEvent):void{
			super.keyDownHandler(event);
			Util.nextComponent(event, this.focusManager);
		}
		
		/**
		 * 获取选中的日期，格式为YYYY-MM-DD的字符串，如果没有选中则返回空字符串
		 */ 
		public function get dataValue():String{
			return this.selectedDate?DateUtil.formatDate(selectedDate,DateUtil.dfStr1):null;
		}
		
		public function set dataValue(v:String):void{
			this.selectedDate = DateUtil.parse(v);
		}
		
		public function reset():void
		{
			if(_defaultValue!=null){
				selectedDate = _defaultValue;
			}
			else{
				selectedDate = null;
			}
			this.errorString = '';
		}
		
		public function validate():Boolean
		{
			if(required && Util.isBlank(dataValue)){
				this.errorString= "必填项";
				return false;
			}
			else{
				this.errorString = '';
				return true;
			}
		}
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		
		/**
		 * 默认值
		 */ 
		private var _defaultValue:Date = null
		public function get defaultValue():Date{
			return _defaultValue;
		}
		public function set defaultValue(obj:Date):void{
			_defaultValue = obj;
		}
	}
}