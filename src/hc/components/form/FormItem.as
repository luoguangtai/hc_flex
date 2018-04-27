package hc.components.form
{
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	import spark.components.FormItem;
	
	public class FormItem extends spark.components.FormItem
	{
		private var _colSpan:int = 1;	//跨列数
		
		public function FormItem()
		{
			super();
		}
		
		/**
		 * 如果父类采用CellLayout，可以使用此放法设置元素位置，分别是第几行，第几列，跨几行，跨几列
		 * 如果输入的数组长度是2，则默认不跨行不跨列
		 */
		public function set cellPosition(v:Array):void{
			var row:int = v[0];
			var col:int = v[1];
			var rowSpan:int = 1;
			var colSpan:int = 1;
			if(v.length>2){
				rowSpan = v[2];
				colSpan = v[3];
			}
			this.top = 'row' + row + ':0';
			this.left = 'col' + col + ':0';
			this.bottom = 'row' + (row+rowSpan-1) + ':0';
			this.right = 'col' + (col+colSpan-1) + ':0';
		}
		
		/**
		 * FormItem跨列数 
		 * @return 
		 * 
		 */
		public function get colSpan():int
		{
			return _colSpan;
		}
		
		public function set colSpan(value:int):void
		{
			_colSpan = value;
		}
		
		/**
		 * 表单元素验证,返回true则通过
		 */ 
		public function validate():Boolean{
			var rs:Boolean = true;
			var items:Array = getAllFormComps();
			var element:IFormItemComponent;
			for(var i:int=0; i<items.length; i++){
				element = items[i] as IFormItemComponent;
				if(!(element as IFormItemComponent).validate()){
					rs = false;
				}
			}
			return rs;
		}
		
		public function set dataValue(obj:Object):void{
			var items:Array = getAllFormComps();
			var element:IFormItemComponent;
			for(var i:int=0; i<items.length; i++){
				element = items[i] as IFormItemComponent;
				element.dataValue = obj[element.fieldName];
//				if(obj.hasOwnProperty(element.fieldName)){
//					element.dataValue = obj[element.fieldName];
//				}
			}
		}
		
		public function get dataValue():Object{
			var obj:Object = {};
			
			var items:Array = getAllFormComps();
			var element:IFormItemComponent;
			for(var i:int=0; i<items.length; i++){
				element = items[i] as IFormItemComponent;
				obj[element.fieldName] = element.dataValue;
			}
			
			return obj;
		}
		
		public function reset(exceptFiledName:Array=null):void{
			var items:Array = getAllFormComps();
			var element:IFormItemComponent;
			
			var doReset:Boolean  = true;
			for(var i:int=0; i<items.length; i++){
				element = items[i] as IFormItemComponent;
				doReset = true;
				for(var j:int=0; exceptFiledName!=null && j<exceptFiledName.length; j++){
					if(element.fieldName == exceptFiledName[j]){
						doReset = false;
						break;
					}
				}
				if(doReset){
					element.reset();
				}
				
			}
		}
		
		/**
		 * 设置是否可编辑
		 */
		private var _editable:Boolean;
		public function set editable(v:Boolean):void{
			_editable = v;
			
			var items:Array = getAllFormComps();
			var element:IFormItemComponent;
			for(var i:int=0; i<items.length; i++){
				element = items[i] as IFormItemComponent;
				(element as UIComponent).enabled = v;
			}
		}
		
		public function get editable():Boolean{
			return _editable;
		}
		
		/**
		 * 取所有的IFormItemComponent
		 */
		public function getAllFormComps():Array{
			var items:Array = new Array();
			findFormComps(this, items);
			return items;
		}
		
		private static function findFormComps(component:IVisualElementContainer,items:Array):void{
			if(component){
				for(var m:int = 0 ;m<component.numElements ; m++){
					var tmpObj:IVisualElement = component.getElementAt(m);
					if(tmpObj is IFormItemComponent){
						items.push(tmpObj);
					}else if(tmpObj is IVisualElementContainer){
						findFormComps(tmpObj as IVisualElementContainer,items);
					}
				}
			}
		}
		
	}
}