package hc.components.form
{
	import hc.util.Util;
	import spark.components.Label;
	
	public class Hidden extends spark.components.Label implements IFormItemComponent
	{				
		public function Hidden()
		{
			super();
			super.visible=false;
			super.includeInLayout = false;
			super.width=0;
			super.height=0;
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
			var bResult:Boolean = true;
			return bResult;
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