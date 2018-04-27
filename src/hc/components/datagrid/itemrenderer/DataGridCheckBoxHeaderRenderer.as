package hc.components.datagrid.itemrenderer
{
	import hc.components.form.CheckBox;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	import spark.components.gridClasses.GridItemRenderer;
	
	public class DataGridCheckBoxHeaderRenderer extends DataGridHeaderRenderer
	{
		private var cb:CheckBox;
		
		public function DataGridCheckBoxHeaderRenderer()
		{
			super();
			cb = new CheckBox();
			cb.horizontalCenter = 0;
			cb.verticalCenter = 0;
			cb.toolTip = "全选/全不选";
			cb.label = '';
			cb.addEventListener(Event.CHANGE, changeHandle);
			this.addElement(cb);
		}
		
		//点击check box时，根据状况修改data的属性
		private function changeHandle(e:Event):void{
			var d:IList = this.grid.dataProvider;
			for(var i:int=0; i<d.length; i++){
				d.getItemAt(i)[this.column.dataField] = cb.selected;
			}
			d.itemUpdated(null);
		}
		
		override public function prepare(hasBeenRecycled:Boolean):void {
			var d:IList = this.grid.dataProvider;
			if(d!=null){
				for(var i:int=0; i<d.length; i++){
					if(d.getItemAt(i)[this.column.dataField]!=true){
						cb.selected = false;
						return;
					}
				}
				cb.selected = true;
			}
		}
	}
}