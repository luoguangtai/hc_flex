package hc.components.datagrid.itemrenderer
{
	import hc.components.form.CheckBox;
	
	import flash.events.Event;
	
	import spark.components.gridClasses.GridItemRenderer;
	
	public class DataGridCheckBoxItemRenderer extends GridItemRenderer
	{
		private var cb:CheckBox;
		public function DataGridCheckBoxItemRenderer()
		{
			super();
			cb = new CheckBox();
			cb.horizontalCenter = 0;
			cb.verticalCenter = 0;
			cb.addEventListener(Event.CHANGE, changeHandle);
			this.addElement(cb);
		}
		
		override public function prepare(hasBeenRecycled:Boolean):void {
			if(data!=null){
				cb.selected = (true == data[column.dataField]);
			}
		}
		
		//点击check box时，根据状况修改data的属性
		private function changeHandle(e:Event):void{
			if(data!=null){
				data[column.dataField] = cb.selected;
				this.grid.dataProvider.itemUpdated(data);
			}
		}
	}
}