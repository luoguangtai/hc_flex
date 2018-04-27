package hc.components.form
{
	import hc.util.Util;
	import hc.util.RegExpUtil;
	
	import mx.events.FlexEvent;
	
	import spark.components.TextArea;
	
	[IconFile("/assets/icon/icon_textArea.png")]
	public class TextArea extends spark.components.TextArea implements IFormItemComponent
	{
		public var required:Boolean = false;//是否必填,如果为true则表示必填，不能为空
		
		public var minLength:Number;//字符串最小长度
		public var maxLength:Number;//字符串最大长度
		
		public function TextArea()
		{
			super();
			this.addEventListener(FlexEvent.VALUE_COMMIT,valueCommitValid);	
		}
		
		/**
		 * 数据变更提交时验证,验证通过则置空errorString
		 */
		private function valueCommitValid(event:mx.events.FlexEvent):void
		{
			validate();
		}
		
		public function validate():Boolean
		{
			var bResult:Boolean = true;
			errorString="";
			//先判断是否必填，如果是必填项，则不能为空
			if(this.required && Util.isBlank(this.text)){
				bResult = false;
				this.errorString= "必填项";
			}
			var len:int = RegExpUtil.getStringBytes(this.text);
			//如果设置了最小长度，则进行不对，不能小于最小长度
			if(!isNaN(this.minLength) && len<this.minLength){
				bResult = false;
				this.errorString= "字符不能少于 "+ minLength +"个字节";
			}
			//如果设置了最大长度，则不能超过最大长度
			if(!isNaN(this.maxLength) && len>this.maxLength){
				bResult = false;
				this.errorString= "字符不能超过 "+ maxLength +"个字节";
			}
			return bResult;
		}
		
		public function reset():void{
			this.text=_defaultValue;
			this.errorString="";
		}
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		
		/**
		 * 取控件的值
		 */ 
		public function get dataValue():String{
			return this.text;
		}
		/**
		 * 设置控件的值
		 */ 
		public function set dataValue(value:String):void{
			this.text='';
			if(Util.isNotBlank(value)){
				this.text=value;
			}
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