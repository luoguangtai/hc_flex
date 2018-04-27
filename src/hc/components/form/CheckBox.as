package hc.components.form
{
	import hc.util.Util;
	
	import flash.events.KeyboardEvent;
	
	import spark.components.CheckBox;
	
	[IconFile("/assets/icon/icon_checkBox.png")]
	public class CheckBox extends spark.components.CheckBox implements IFormItemComponent
	{
		private var _value:String;
		private var _fieldName:String = null;
		public function CheckBox()
		{
			super();
		}

		public function get value():String
		{
			return _value;
		}

		public function set value(value:String):void
		{
			_value = value;
		}
		
		/**
		 * 控件数据输入验证 
		 * @return 
		 */
		public function validate():Boolean{
			return true;
		}
		
		/**
		 * 控件重置
		 */ 
		public function reset():void{
			this.selected = false;
		}
		
		/**
		 * 设置控件绑定数据的字段名
		 * @param value
		 */
		public function set fieldName(value:String):void{
			_fieldName = value;
		}
		
		public function get fieldName():String{
			return _fieldName;
		}
		
		/**
		 * 获得控件输入的值
		 */
		public function get dataValue():String{
			return this.selected + '';
		}
		
		
		public function set dataValue(obj:String):void{
			if(obj=='1' || obj=='true'){
				this.selected = true;
			}
			else{
				this.selected = false;
			}
		}

	}
}