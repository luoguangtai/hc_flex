package hc.components.datagrid.itemrenderer
{
	import hc.components.datagrid.AdvancedDataGrid;
	import hc.components.datagrid.AdvancedDataGridColumn;
	import hc.components.form.CheckBox;
	import hc.util.Util;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.ICollectionView;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	
	import spark.components.Group;
	
	public class AdvancedDataGridCheckBoxItemRenderer extends Group implements IListItemRenderer,IDropInListItemRenderer
	{
		private var _ck:CheckBox;
		private var _data:Object; 
		private var _listData:BaseListData;
		
		
		public function AdvancedDataGridCheckBoxItemRenderer(){  
			super();  
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			_ck = new CheckBox(); 
			_ck.horizontalCenter = 0;
			_ck.verticalCenter = 0;
			_ck.addEventListener(Event.CHANGE, changeHandle);
			this.addElement(_ck);
		}  
		
		public function set data(value:Object):void{ 
			_data = value; //保存整行的引用  
			_ck.selected = (value[getColumn().dataField] == true  || value[getColumn().dataField] =="true");  
			
			if(_ck.selected==true && _data['_allSelected']==false){
				_ck.alpha = 0.4;
			}
			else{
				_ck.alpha = 1;
			}
		}  
		
		public function get data():Object{ 
			return this._data; 
		}  
		
		//点击check box时，根据状况向selectedItems array中添加当前行的引用，或者从array中移除  
		private function changeHandle(e:Event):void{   
			var dataField:String = getColumn().dataField;
			_data[dataField] = _ck.selected;
			
			//树状表格
			var dg:AdvancedDataGrid = (this.owner) as AdvancedDataGrid;
			if(dg.dataProvider is HierarchicalCollectionView){
				var hcv:HierarchicalCollectionView = dg.dataProvider as HierarchicalCollectionView;
//				selectAll(hcv.source, _data, dataField, _ck.selected);
				selectChildren(hcv, _data, dataField, _ck.selected);
				selectParent(hcv, _data, dataField);
				hcv.itemUpdated(_data);
			}
		}  
		
//		private function selectAll(src:IHierarchicalData, obj:Object, dataField:String, v:Boolean):void{
//			obj[dataField] = v;
//			if(src.hasChildren(obj)){
//				var _children:Object = src.getChildren(obj);
//				if(_children is Array){
//					for(var i:int = 0; i<(_children as Array).length; i++){
//						selectAll(src, _children[i], dataField, v);
//					}
//				}
//				else{
//					selectAll(src, _children, dataField, v);
//				}
//			}
//		}
		
		private function selectChildren(src:HierarchicalCollectionView, obj:Object, dataField:String, v:Boolean):void{
			obj[dataField] = v;
			obj['_allSelected'] = true;
			var _children:ICollectionView = src.getChildren(obj);
			if(_children!=null && (_children is ArrayCollection)){
				var _list:ArrayCollection = _children as ArrayCollection;
				for(var i:int=0; i<_list.length; i++){
					selectChildren(src, _list.getItemAt(i), dataField, v);
				}
			}
		}
		
		private function selectParent(src:HierarchicalCollectionView, obj:Object, dataField:String):void{
			var _parent:Object = src.getParentItem(obj);
			if(_parent!=null){
				//判断下级结点是否有一个选中
				var hasSelectedChild:Boolean = false;
				//是否全部选中
				var allSelectedChild:Boolean = true;
				//子节点
				var _children:ICollectionView = src.getChildren(_parent);
				if(_children!=null && (_children is ArrayCollection)){
					var _list:ArrayCollection = _children as ArrayCollection;
					for(var i:int=0; i<_list.length; i++){
						if(_list.getItemAt(i)[dataField] == true || _list.getItemAt(i)[dataField] == 'true'){
							hasSelectedChild = true;
						}
						else{
							allSelectedChild = false;
						}
						
						//如果下级没有全部选中也认为上级不是全部选中
						if(_list.getItemAt(i)['_allSelected'] == false){
							allSelectedChild = false;
						}
					}
				}
				_parent[dataField] = hasSelectedChild;
				_parent['_allSelected'] = allSelectedChild;
				//继续找上级
				selectParent(src, _parent, dataField);
			}
		}
		
		private  function getColumn():AdvancedDataGridColumn{
			var dataGrid:AdvancedDataGrid = this.owner as AdvancedDataGrid;
			return dataGrid.columns[listData.columnIndex];
		}
		
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		
	}
}
