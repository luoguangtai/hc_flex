package hc.components.datagrid
{
	import flash.geom.Rectangle;
	
	import spark.components.GridColumnHeaderGroup;
	import spark.components.gridClasses.IGridItemRenderer;
	
	public class DataGridColumnFooterGroup extends GridColumnHeaderGroup
	{
		public function DataGridColumnFooterGroup()
		{
			super();
			this.layout = new DataGridColumnFooterGroupLayout();
		}
		
		override public function getHeaderIndexAt(x:Number, y:Number):int
		{
			return DataGridColumnFooterGroupLayout(layout).getHeaderIndexAt(x, y);
		}
		
		override public function getSeparatorIndexAt(x:Number, y:Number):int
		{
			return DataGridColumnFooterGroupLayout(layout).getSeparatorIndexAt(x, y);
		}
		
		override public function getHeaderRendererAt(columnIndex:int):IGridItemRenderer
		{
			return DataGridColumnFooterGroupLayout(layout).getHeaderRendererAt(columnIndex);
		}
		
		override public function getHeaderBounds(columnIndex:int):Rectangle
		{
			return DataGridColumnFooterGroupLayout(layout).getHeaderBounds(columnIndex);
		}
	}
}