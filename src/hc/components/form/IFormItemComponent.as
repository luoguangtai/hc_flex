package hc.components.form
{
	public interface IFormItemComponent
	{
		/**
		 * 控件数据输入验证 
		 * @return 
		 */
		function validate():Boolean;
		
		/**
		 * 控件重置
		 */ 
		function reset():void;
		
		/**
		 * 设置控件绑定数据的字段名
		 * @param value
		 */
		function set fieldName(value:String):void;
		
		function get fieldName():String;
		
		/**
		 * 获得控件输入的值
		 */
		function get dataValue():String;
		
		
		function set dataValue(obj:String):void;
	}
}