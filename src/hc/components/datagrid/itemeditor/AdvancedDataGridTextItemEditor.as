package hc.components.datagrid.itemeditor
{
	import hc.util.NumberUtil;
	import hc.util.Util;
	
	import flash.events.FocusEvent;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	
	
	public class AdvancedDataGridTextItemEditor extends TextInput
	{
		public function AdvancedDataGridTextItemEditor()
		{
			super();
		}
		
		private  function getColumn():AdvancedDataGridColumn{
			var dataGrid:AdvancedDataGrid = this.owner as AdvancedDataGrid;
			return dataGrid.columns[listData.columnIndex];
		}
	}
}