package hc.components.datagrid
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.EventPriority;
	
	import spark.components.DataGrid;
	import spark.components.GridColumnHeaderGroup;
	import spark.components.Label;
	import spark.components.gridClasses.IDataGridElement;
	import spark.primitives.Rect;
	
	public class DataGrid extends spark.components.DataGrid
	{
		[SkinPart(required="false")]
		public var columnFooterGroup:GridColumnHeaderGroup; 
		
		[SkinPart(required="false")]
		public var pageBar:PageBar; 
		
		[SkinPart(required="false")]
		public var border:Rect; 
		
		[SkinPart(required="false")]
		public var noDataMsg:Label; 
		
		public function DataGrid()
		{
			super();
			//回车跳到下一个编辑框
			this.addEventListener(FocusEvent.FOCUS_IN,defaultFocusInHandler,false,EventPriority.DEFAULT_HANDLER);
			this.rowHeight = 25;
		}
		
		/**不分页需要显示的list*/
		private var _dataList:String = "dataList";
		public function set dataList(value:String):void
		{
			this._dataList=value;
		}
		
		public function get dataList():String
		{
			return this._dataList;
		}
		/**
		 * 是否显示合计行Footer
		 */
		[Bindable]
		public var showFooterGroup:Boolean = false;
		
		/**
		 * 是否显示分页
		 * */
		[Bindable]
		public var showPageBar:Boolean = false;
		
		/**
		 * 每页记录数
		 */ 
		[Bindable]
		public var pageSize:int = 20;
		
		/**
		 * 表格的URL
		 */ 
		public var url:String = '';
		
		/**
		 * 参数
		 */ 
		public var param:Object = null;
		
		
		/**
		 * 加载数据，如果不输入参数则表示刷新当前页
		 */ 
		public function loadData(currentPageNum:int = 0, callback:Function=null, showLoading:Boolean = false):void{
			param = (param==null) ? {} : param;
			if(showPageBar){
				currentPageNum = currentPageNum<1 ? pageBar.currPage : currentPageNum;
				param._start = currentPageNum;
				param._limit = pageSize;
			}
			else{
				param._start = 0;
				param._limit = 1000;
			}
			HttpUtil.doPost(url, param, function(obj:Object):void{
				//返回结果不分页
				if(obj is Array){
					dataProvider = new ArrayList(obj as Array);
				}
				else{
					//分页
					if(obj.hasOwnProperty("page")){
						dataProvider = new ArrayList(obj.page.dataList as Array);
						pageBar.setData(obj.page.totalCount, currentPageNum);
					}else{
						dataProvider = new ArrayList(obj[dataList] as Array);
					}
				}
				
				if(callback!=null){
					callback();
				}
			}, null, showLoading);
		}
		
		override public function set columns(value:IList):void
		{
			super.columns = value;
			
			if (columnFooterGroup)
			{
				columnFooterGroup.layout.clearVirtualLayoutCache();
				columnFooterGroup.invalidateSize();
				columnFooterGroup.invalidateDisplayList();
			}			
		}
		
		override public function set nestLevel(value:int):void
		{
			super.nestLevel = value;
			
			if (grid)
				initializeDataGridElement(columnFooterGroup);
		}
		
		private function initializeDataGridElement(elt:IDataGridElement):void
		{
			if (!elt)
				return;
			
			elt.dataGrid = this;
			if (elt.nestLevel <= grid.nestLevel)
				elt.nestLevel = grid.nestLevel + 1;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == grid)
			{
				initializeDataGridElement(columnFooterGroup);
				
				grid.addEventListener("invalidateSize", grid_invalidateSizeHandler);            
				grid.addEventListener("invalidateDisplayList", grid_invalidateDisplayListHandler);
			}
			
			if (instance == columnFooterGroup) 
			{				
				if (grid)
					initializeDataGridElement(columnFooterGroup);
			}	
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == columnFooterGroup)
			{
				columnFooterGroup.dataGrid = null;
			}
		}
		
		private function grid_invalidateSizeHandler(event:Event):void
		{
			if (columnFooterGroup)
				columnFooterGroup.invalidateSize();
		}
		
		private function grid_invalidateDisplayListHandler(event:Event):void
		{
			if (columnFooterGroup)
				columnFooterGroup.invalidateDisplayList();
		}
		
		override protected function createChildren():void{
			super.createChildren();
		}
		
		/**
		 * ============================================编辑回车跳转===================
		 * */
		protected function defaultFocusInHandler(event:FocusEvent):void{
			if(!event.isDefaultPrevented() && this.itemEditorInstance){
				if(this.itemEditorInstance.hasEventListener(KeyboardEvent.KEY_DOWN)){
					//键盘事件的级别一定要高，flex也有一个默认的键盘事件，默认事件执行完之后会直接中止传播
					this.itemEditorInstance.addEventListener(KeyboardEvent.KEY_DOWN, defaultKeyDownHandler,false,100);
				}
			}
		}
		
		protected function defaultKeyDownHandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				var rowIndex:int = this.editorRowIndex;
				var columnIndex:int = this.editorColumnIndex;
				if(rowIndex == -1 || columnIndex == -1){
					return;
				}
				
				var v:Object = getNextEditableCell(rowIndex,columnIndex);
				if(v == null) return ;
				this.startItemEditorSession(v.rowIndex,v.columnIndex);                                       
				this.selectedIndex = v.rowIndex;
			}
		}
		
		/**
		 * 取下一个可编辑的单元格
		 */ 
		protected function getNextEditableCell(rowIndex:int,columnIndex:int):Object{
			if(rowIndex < this.dataProvider.length-1 || columnIndex < this.columns.length - 1){
				var v:Object = {};
				if(columnIndex < this.columns.length - 1){
					columnIndex++;
				} else {
					rowIndex++;
					columnIndex = 0;
				}
				var gridColumn:DataGridColumn = (this.columns.getItemAt(columnIndex) as DataGridColumn);
				if(gridColumn.visible && gridColumn.editable){
					v.rowIndex = rowIndex;
					v.columnIndex = columnIndex;
				}else{
					return getNextEditableCell(rowIndex,columnIndex);
				}
				return v;
			}
			return null;
		}
		
		public function getSelected(dataField:String, value:Object=true):Array{
			var result:Array = [];
			for(var i:int = 0; i < this.dataProvider.length ; i++){  
				var s:Object = this.dataProvider.getItemAt(i);
				if(s[dataField] == value){
					result.push(s);
				}
			} 
			
			return result;
		}
		
		override public function set dataProvider(value:IList):void
		{
			super.dataProvider = value;
			if(noDataMsg){
				noDataMsg.visible = value.length==0;
			}
		}
		
	}
}