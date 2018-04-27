package hc.components.datagrid
{
	import hc.components.datagrid.itemrenderer.AdvancedDataGridCheckBoxItemRenderer;
	import hc.components.datagrid.itemrenderer.AdvancedDataGridHeaderRenderer;
	import hc.util.Util;
	
	import flash.events.Event;
	
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IHierarchicalData;
	import mx.collections.ListCollectionView;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	
	import spark.components.Label;
	
	public class AdvancedDataGrid extends mx.controls.AdvancedDataGrid
	{
		protected var footer:AdvancedDataGridFooter;
		protected var footerHeight:int = 30;
		
		/**
		 * 是否显示合计行Footer
		 */
		private var _showFooterGroup:Boolean = false;
		
		public function AdvancedDataGrid()
		{
			super();
			this.sortExpertMode = true;
			this.sortableColumns = false;
			this.draggableColumns = false;
			this.displayItemsExpanded = true;
			this.headerHeight = 30;
			this.rowHeight = 30;
			this.headerRenderer = new ClassFactory(AdvancedDataGridHeaderRenderer);
		}
		
		public function set showFooterGroup(value:Boolean):void{
			_showFooterGroup = value;
		}
		
		//增加合计行
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (!footer && _showFooterGroup)
			{
				footer = new AdvancedDataGridFooter();
				footer.styleName = this;
				addChild(footer);
			}
		}
		
		/**
		 * 重写adjustListContent方法以确定footer的位置
		 */
		override protected function adjustListContent(unscaledWidth:Number = -1,
													  unscaledHeight:Number = -1):void
		{
			super.adjustListContent(unscaledWidth, unscaledHeight);
			if(footer){
				listContent.setActualSize(listContent.width, listContent.height - footerHeight);
				footer.setActualSize(listContent.width, footerHeight);
				footer.move(listContent.x, listContent.y + listContent.height + 1);
			}
		}
		
		override public function invalidateDisplayList():void
		{
			super.invalidateDisplayList();
			if (footer){
				footer.invalidateDisplayList();
			}
		}
		
		override protected function collectionChangeHandler(event:Event):void{
			//如果是树状表格、而且有checkbox列则根据叶子结点设置父节点的选中状态
			if(event.target is HierarchicalCollectionView){
				for(var i:int=0; i<this.columnCount; i++){
					if(this.columns[i] is AdvancedDataGridColumn){
						var _col:AdvancedDataGridColumn = this.columns[i] as AdvancedDataGridColumn;
						if(_col.itemRenderer!=null){
							if((_col.itemRenderer as ClassFactory).generator==AdvancedDataGridCheckBoxItemRenderer){
								var _hcv:HierarchicalCollectionView = event.target as HierarchicalCollectionView;
								var _root:Object = _hcv.source.getRoot();
								if(_root is Array){
									for(var j:int=0; j<(_root as Array).length; j++){
										setSel(_hcv.source, _root[j], _col.dataField);
									}
								}
								else{
									setSel(_hcv.source, _root, _col.dataField);
								}
							} 
						}
					}
				}
			}
			super.collectionChangeHandler(event);
		}
		
		//0-未选中  1-选中  2-部分选中
		private function setSel(src:IHierarchicalData, obj:Object, dataField:String):int{
			if(src.hasChildren(obj)){
				var _children:Object = src.getChildren(obj);
				
				obj[dataField] = false;
				obj['_allSelected'] = true;
				if(_children is Array){
					for(var i:int = 0; i<(_children as Array).length; i++){
						var r1:int = setSel(src, _children[i], dataField);
						if(r1==1 || r1==2){
							obj[dataField] = true;
						}
						if(r1==0 || r1==2){
							obj['_allSelected'] = false;
						}
					}
				}
				else{
					var r2:int = setSel(src, _children, dataField);
					obj[dataField] = (r2==1 || r2==2);
					obj['_allSelected'] = (r2==0 || r2==1);
				}
				
				if(obj[dataField] == false){
					return 0;
				}
				else if(obj['_allSelected'] == true){
					return 1;
				}
				else{
					return 2;
				}
			}
			else{
				return (obj[dataField]==true || obj[dataField]=='true')?1:0;
			}
		}
		
		public function getSelected(dataField:String, value:Object=true, onlyLeaf:Boolean=true):Array{
			var result:Array = [];
			if(this.dataProvider is ListCollectionView){
				var list:ListCollectionView = this.dataProvider as ListCollectionView;
				for(var i:int = 0; i < list.length ; i++){  
					var s:Object = list.getItemAt(i);
					if(s[dataField] == value){
						result.push(s);
					}
				} 
			}
			//树状表格
			else if(this.dataProvider is HierarchicalCollectionView){
				var hcv:HierarchicalCollectionView = this.dataProvider as HierarchicalCollectionView;
				//如果有根结点则会调用if(src.hasChildren(obj)){,否则调用if(obj is Array){
				getSel(hcv.source, hcv.source.getRoot(), dataField, value, result, onlyLeaf);
			}
			
			return result;
		}
		
		private function getSel(src:IHierarchicalData, obj:Object, dataField:String, v:Object, result:Array, onlyLeaf:Boolean=true):void{
			if(src.hasChildren(obj)){
				//不仅仅取叶子结点
				if(!onlyLeaf && obj[dataField]==v){
					result.push(obj);
				}
				var _children:Object = src.getChildren(obj);
				if(_children is Array){
					for(var i:int = 0; i<(_children as Array).length; i++){
						getSel(src, _children[i], dataField, v, result, onlyLeaf);
					}
				}
				else{
					getSel(src, _children, dataField, v, result, onlyLeaf);
				}
			}
			else{
				if(obj is Array){
					for(var i:int = 0; i<(obj as Array).length; i++){
						getSel(src, obj[i], dataField, v, result, onlyLeaf);
					}
				}
				else{
					if(obj[dataField]==v){
						result.push(obj);
					}
				}
			}
		}
	}
}