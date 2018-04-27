package hc.components.datagrid
{
import flash.display.Shape;

import mx.controls.Label;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
import mx.core.ClassFactory;
import mx.core.EdgeMetrics;
import mx.core.UIComponent;
import mx.core.mx_internal;


use namespace mx_internal;

public class AdvancedDataGridFooter extends UIComponent
{

	public function AdvancedDataGridFooter()
	{
		super();
	}

	protected var overlay:Shape;

	protected var dataGrid:AdvancedDataGrid;

	/**
	 *  Create the actual border here.
	 */
	override protected function createChildren():void
	{
		dataGrid = parent as AdvancedDataGrid;
		overlay = new Shape();
		addChild(overlay);	
	}

	/**
	 *	Lay it out
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		try{
			overlay.graphics.clear();
	
			while (numChildren > 1)
				removeChildAt(1);
			
			//底色
			overlay.graphics.beginFill(0xdce7f1, 1);
			overlay.graphics.drawRect(0,0,w,h);
			overlay.graphics.endFill();
			//上边线
			overlay.graphics.lineStyle(1, 0x96aac8);
			overlay.graphics.moveTo(0, 0);
			overlay.graphics.lineTo(w, 0);
			//底下的边框
			lineCol = dataGrid.getStyle("borderColor");
			overlay.graphics.lineStyle(1, lineCol);
			overlay.graphics.moveTo(0, h);
			overlay.graphics.lineTo(w, h);
	
			var cols:Array = dataGrid.columns;
			var firstCol:int = dataGrid.horizontalScrollPosition;
	
			var colIndex:int = 0;
			var n:int = cols.length;
			var i:int = 0;
			// 找到当前显示的第一列
			while (colIndex < firstCol)
			{
				if (cols[i++].visible)
					colIndex ++;
			}
			
			var vm:EdgeMetrics = dataGrid.viewMetrics;
	        var lineCol:uint = dataGrid.getStyle("verticalGridLineColor");
	        var vlines:Boolean = dataGrid.getStyle("verticalGridLines");
			overlay.graphics.lineStyle(1, lineCol);
	
			var xx:Number = 0;
			var yy:Number = 0;
			
			while (xx < w && i < cols.length)
			{
				var col:mx.controls.advancedDataGridClasses.AdvancedDataGridColumn = cols[i++];
				//当该列可见，增加合计列
				if( col.visible){
					if (col is hc.components.datagrid.AdvancedDataGridColumn)
					{					
						var fdgc:hc.components.datagrid.AdvancedDataGridColumn = col as hc.components.datagrid.AdvancedDataGridColumn;
						var valueStr:String = "";
						//若汇总函数不存在，不需要转化
						if(fdgc.summaryFunction){
							valueStr = fdgc.summaryFunction(dataGrid.dataProvider,fdgc.dataField);
						}
						else{
							valueStr = fdgc.footerText;
						}
						
						var renderer:AdvancedDataGridItemRenderer =  new ClassFactory(AdvancedDataGridItemRenderer).newInstance();
						renderer.listData = new AdvancedDataGridListData(valueStr, fdgc.dataField, i - 1, null, dataGrid, -1);
						this.addChild(renderer);
						renderer.x = xx;
						renderer.y = yy;
						renderer.setActualSize(col.width - 1, dataGrid.rowHeight);
							
						if (vlines)
						{
							overlay.graphics.moveTo(xx + col.width, yy);
							overlay.graphics.lineTo(xx + col.width, h);
						}
					}
					xx += col.width;
				}			
			}
		}catch(e:Error){
		}
	}
}
}