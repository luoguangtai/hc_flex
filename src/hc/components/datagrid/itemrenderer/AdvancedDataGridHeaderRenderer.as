package hc.components.datagrid.itemrenderer
{
	
	import hc.util.Util;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.core.mx_internal;
	
	
	public class AdvancedDataGridHeaderRenderer extends mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer
	{
		public function AdvancedDataGridHeaderRenderer(){  
			super();  
		}  
		
		override protected function commitProperties():void{
			super.commitProperties();
			
			if(this.data is AdvancedDataGridColumn && !(this.data is AdvancedDataGridColumnGroup)){
				if((this.data as AdvancedDataGridColumn).editable){
					label.text = '*' + label.text;
				}
			}
		}
	}
}
