package hc.util
{
	import hc.components.datagrid.DataGrid;
	import hc.components.detailGrid.DetailLabel;
	import hc.components.form.FormItem;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	public class FreeFormUtil
	{	
		/**
		 * 验证多个表单
		 */
		public static function validateForm(array:Array):Boolean{
			var ret:Boolean = true;
			//获取所有的IFormItemComponent元素
			var itemComponents:Array = findAllComponents(array);
			var formItem:FormItem;
			for(var i:int = 0 ; i < itemComponents.length; i++){
				formItem = itemComponents[i] as FormItem;
				if(!formItem.validate()){
					ret = false;
				}
			}
			return ret;
		}
		
		/**
		 * 获取多个表单的值
		 */
		public static function getFormParam(array:Array):Object{
			var itemComponents:Array = findAllComponents(array);
			var formItem:FormItem;
			var obj:Object = {};
			for(var i:int = 0 ; i < itemComponents.length; i++){
				formItem = itemComponents[i] as FormItem;
				Util.copy(formItem.dataValue, obj);
			}
			return obj;
		}
		
		/**
		 * 表单赋值
		 * 参数：
		 * array：多个FORM的数组
		 * p:     给FORM赋值的对象 里面的对象的名称 更FORM的ID一致
		 * 返回值 null
		 **/
		public static function setFormValue(array:Array,o:Object):void{
			//获取所有的IFormItemComponent元素
			var itemComponents:Array = findAllComponents(array);
			//依次赋值
			for(var i:int = 0 ; i < itemComponents.length; i++){
				resetValues(itemComponents[i],o);
			}
		}
		/**
		 * 表单操作
		 * 参数：
		 * array：多个FORM的数组
		 * p:     给FORM赋值的对象 里面的对象的名称 更FORM的ID一致
		 * 返回值 null
		 * */
		private static function resetValues(obj:Object,p:Object=null):void
		{
			setVal4Obj(obj,p);
		}
		/**
		 * 为对象设置值
		 */
		private static function setVal4Obj(itemComponent:Object,dataItem:Object):void{	
			
			if (itemComponent is DetailLabel){	
				if(Util.isNotBlank(itemComponent.fieldName)){
					var fieldName:String = String(itemComponent.fieldName);
					var fieldValue:Object = dataItem[fieldName];
					(itemComponent as DetailLabel).dataValue  = (fieldValue!=null)? String(fieldValue): "";
				}
			}else if(itemComponent is FormItem){
				
			}
		}
		
		public static function getFieldValue(attributeName : String, dataObj:Object):Object
		{
			if(dataObj==null) return null;
			
			var isHasDetail:Boolean = ( attributeName.indexOf(".") >= 0);
			if(isHasDetail)
			{
				var strArray:Array = attributeName.split(".");
				var tableName:String;
				var fieldName:String;
				
				if(strArray.length ==2)
				{
					//businessId为'表名'.'属性名'
					tableName = String(strArray[0]);
					fieldName = String(strArray[1]);
					
					if (!dataObj.hasOwnProperty(tableName))
					{
						return dataObj[attributeName];	
					}
					return dataObj[tableName][fieldName];					
				}else if (strArray.length ==3 )
				{
					//businessId为'主表名'.'从表名'.'属性名'
					var masterName:String = String(strArray[0]);
					tableName = String(strArray[1]);
					fieldName = String(strArray[2]);
					
					if (!dataObj.hasOwnProperty(masterName) || !dataObj[masterName].hasOwnProperty(tableName) )
					{
						return dataObj[attributeName];	
					}
					return dataObj[masterName][tableName][fieldName];	
				}
			}
			//businessId为'属性名'
			return dataObj[attributeName];
		}
		
		/**
		 * 查找所有元素
		 */
		private static function findAllComponents(array:Array):Array{
			var itemComponents:Array = new Array();
			for(var u:int = 0 ;u<array.length ; u++ ){
				var component:Object = array[u];
				if(component is DataGrid){
					itemComponents.addItem(component);
				}
				else if(component is IVisualElementContainer){
					itemComponents = findFormItemComponents((component as IVisualElementContainer),itemComponents);
				}
			}
			return itemComponents;
		}
		private static function findFormItemComponents(component:IVisualElementContainer,formItemComponents:Array):Array{
			if(!component){
				return formItemComponents;
			}
			for(var m:int = 0 ;m<component.numElements ; m++){
				var tmpObj:IVisualElement = component.getElementAt(m);
				if(tmpObj is FormItem){
					formItemComponents.push(tmpObj);
				}else if(tmpObj is DetailLabel){
					formItemComponents.push(tmpObj);
				}else if(tmpObj is IVisualElementContainer){
					findFormItemComponents(tmpObj as IVisualElementContainer,formItemComponents);
				}
			}
			return formItemComponents;
		}
	}
}