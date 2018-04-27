package hc.components.datagrid.itemeditor
{
	import hc.util.NumberUtil;
	import hc.util.Util;
	
	import flash.events.FocusEvent;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	
	
	public class AdvancedDataGridNumberItemEditor extends TextInput
	{
		private var _v:String = '';
		public function AdvancedDataGridNumberItemEditor()
		{
			super();
			this.restrict = "0-9\+\-\.";
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			var col:AdvancedDataGridColumn = getColumn();
			this.text = data[col.dataField];
			_v = this.text;
		}
		
		override protected function focusOutHandler(event:FocusEvent):void{
			var col:AdvancedDataGridColumn = getColumn();
			if(Util.isBlank(this.text)){
				data[col.dataField] = null;
			}
			else if(!NumberUtil.isNumber(this.text)){
				data[col.dataField] = _v;
			}
			else{
				data[col.dataField] = Number(this.text);
			}
		}
		
//		override protected function commitProperties():void{
//			super.commitProperties();
//			var col:AdvancedDataGridColumn = getColumn();
//			if(Util.isBlank(this.text)){
//				data[col.dataField] = null;
//			}
//		}
		
		private  function getColumn():AdvancedDataGridColumn{
			var dataGrid:AdvancedDataGrid = this.owner as AdvancedDataGrid;
			return dataGrid.columns[listData.columnIndex];
		}
	}
}