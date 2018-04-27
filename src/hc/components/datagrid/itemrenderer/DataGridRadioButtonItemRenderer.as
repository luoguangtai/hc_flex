package hc.components.datagrid.itemrenderer
{
	import hc.components.form.RadioButton;
	
	import flash.events.Event;
	
	import mx.collections.IList;
	
	import spark.components.gridClasses.GridItemRenderer;
	
	/**
	 * 表格单选框
	 **/
	public class DataGridRadioButtonItemRenderer extends GridItemRenderer
	{
		private var rb:RadioButton;
		public function DataGridRadioButtonItemRenderer()
		{
			super();
			rb = new RadioButton();
			rb.horizontalCenter = 0;
			rb.verticalCenter = 0;
			rb.addEventListener(Event.CHANGE, changeHandel);
			this.addElement(rb);
		}
		
		private function changeHandel(e:Event):void{
			if(data != null){
				//点击radioButton时
				if(rb.selected){
					var data_list:IList = this.grid.dataProvider;
					for(var i:Number=0; i<data_list.length; i++)
					{
						//去除其他行的选择状态
						if(data == data_list.getItemAt(i)){
							data_list.getItemAt(i)[column.dataField] =  true;
						}
						else{
							data_list.getItemAt(i)[column.dataField] =  false;
						}
					}
					data_list.itemUpdated(null);//更新数据
				}
			}
		}
		
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if(data!=null){
				rb.selected = (true == data[column.dataField]);
			}
		}
		
//		override public function prepare(hasBeenRecycled:Boolean):void {
//			if(data!=null){
//				rb.selected = (true == data[column.dataField]);
//			}
//		}
		
	}
}