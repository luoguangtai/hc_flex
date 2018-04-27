package hc.components.form
{
	import hc.util.Util;
	
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.NumericStepper;
	
	public class NumericStepper extends spark.components.NumericStepper implements IFormItemComponent
	{
		
		public var required:Boolean = false;//是否必填,如果为true则表示必填，不能为空
		
		public var chinese:Boolean = false;//是否用中文数字显示，true中文显示
		
		public var editable:Boolean = true;//是否允许键盘输入,true允许
		
		
		
		public function NumericStepper()
		{
			super();
				
		    this.valueFormatFunction=formatValue;
			this.valueParseFunction=parseValue;			
			
			this.addEventListener(FlexEvent.VALUE_COMMIT,valueCommitValid);			
			this.addEventListener(TextEvent.TEXT_INPUT, keybordValueChange);
		}
		
		/**
		 * 数据变更提交时验证,验证通过则置空errorString
		 */
		private function valueCommitValid(event:mx.events.FlexEvent):void
		{
			validate();
		}
		
		/**
		 *键盘输入时，内容改变事件 
		 * @param event
		 * 
		 */
		private function keybordValueChange(event:flash.events.TextEvent):void
		{
			
		}
		
		private function formatValue(value:Number):String
		{
			if(this.chinese)
			{
				
			}
			
			this.textDisplay.editable=this.editable;
			
			
			return value.toString();
		}
		private function parseValue(value:String):Number
		{
			if(chinese)
			{
				
			}
			
			if(Util.isBlank(value))
			{
				return NaN;
			}
			return  Number(value);
		}
		
		
			
		/**
		 * 按回车建的时候，如果验证通过则转向下一个组件
		 */ 
		override protected function keyDownHandler(event:KeyboardEvent):void{
						
			super.keyDownHandler(event);
			Util.nextComponent(event, this.focusManager);
		}
		
		
		public function validate():Boolean
		{
			var bResult:Boolean = false;
			
 
			if(this.required && isNaN(this.value))  
			{
				
				this.errorString= "必填项";
				bResult=false;
			}
			else
			{
				this.errorString= "";
				bResult=true;
			}
			
			return bResult;
		}
		
		
		/**
		 *控件值重置 
		 * 
		 */
		public function reset():void{
			this.value = 0 ;
			this.errorString = "";
		}	
		
	
		
		/**
		 * 设置值,传入一个表单值
		 */ 
		public function set dataValue(v:String):void{
			this.value=Number(v);
		}
		
		/**
		 * 取控件的值
		 */ 
		public function get dataValue():String{
			return String(this.value);
		}
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
	}
}