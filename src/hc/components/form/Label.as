/**
 * 只用于显示的Label；zhangp于2015-01-21增加。
 * 
 */
package hc.components.form
{
	import flash.events.KeyboardEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import hc.util.Util;
	
	public class Label extends spark.components.Label implements IFormItemComponent
	{				
		private var _dataType:String = 'string';//数据类型	
		
		public var nextComponent:Boolean = true;//是否启用回车转到下一组件
		
		public function Label(){
			super();	
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{
				text = Util.isNotBlank(text)?text:_defaultValue;
			});
		}
		
		/**
		 * 按回车建的时候，如果验证通过则转向下一个组件
		 */ 
		override protected function keyDownHandler(event:KeyboardEvent):void{
			super.keyDownHandler(event);
			if(nextComponent)
				Util.nextComponent(event, this.focusManager);
		}
		
		
		//[Inspectable(category="General", enumeration="文本,数字,正整数,正浮点数,1位小数,2位小数,日期,身份证,电话号码,邮政编码,电子邮箱,法人代码,银行账号,中文" , defaultValue="文本")]
		[Inspectable(category="General", enumeration="string,number,+int,+float,float1,+float1,float2,+float2,date,idCard,tel,mobileTel,postCode,email,entCode,bankAccount,customize,chinese" , defaultValue="string")]
		public function set dataType(value:String):void
		{
			_dataType=value;
		}
		
		//--------------------------------------------------
		//   	 reset 重置
		//--------------------------------------------------
		public function reset():void{
			this.text = _defaultValue;
			this.errorString = "";
		}

		public function validate():Boolean
		{
			return true;
		}
		
		/**
		 * 设置值,传入一个表单值
		 */ 
		public function set dataValue(v:String):void{
			this.text = '';
			if(Util.isNotBlank(v)){
				this.text = String(v);
			}
		}
		/**
		 * 取控件的值
		 */ 
		public function get dataValue():String{
			return this.text;
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
		private var _defaultValue:String = '';
		public function get defaultValue():String{
			return _defaultValue;
		}
		public function set defaultValue(obj:String):void{
			_defaultValue = obj;
		}
	}

}