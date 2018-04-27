package hc.components.form
{
	import hc.util.Util;
	
	import flash.events.MouseEvent;
	
	import spark.components.RadioButton;
	
	[IconFile("/assets/icon/icon_radioButton.png")]
	public class RadioButton extends spark.components.RadioButton implements IFormItemComponent
	{
		public function RadioButton()
		{
			super();
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
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
	}
}