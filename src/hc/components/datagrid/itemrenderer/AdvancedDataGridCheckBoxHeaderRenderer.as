package hc.components.datagrid.itemrenderer
{
	import hc.components.datagrid.AdvancedDataGrid;
	import hc.components.datagrid.AdvancedDataGridColumn;
	import hc.components.form.CheckBox;
	import hc.util.Util;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IHierarchicalData;
	import mx.collections.ListCollectionView;
	import mx.controls.listClasses.IListItemRenderer;
	
	import spark.components.Group;
	
	
	public class AdvancedDataGridCheckBoxHeaderRenderer extends Group implements IListItemRenderer
	{
		private var _ck:CheckBox;
		private var _column:AdvancedDataGridColumn;
		
		public function AdvancedDataGridCheckBoxHeaderRenderer(){  
			super();  
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			_ck = new CheckBox();
			_ck.horizontalCenter = 0;
			_ck.verticalCenter = 0;
			_ck.toolTip = '全选/全不选';
			_ck.addEventListener(Event.CHANGE, changeHandle);
			this.addElement(_ck);
		}  
		
		 public  function set data(value:Object):void{  
			_column = value as AdvancedDataGridColumn;
		}  
		 
		 public  function get data():Object{  
			 return _column;
		 } 
		
		private function changeHandle(event:Event):void{       
			var dg:AdvancedDataGrid = (this.owner) as AdvancedDataGrid;
			if(dg.dataProvider is ListCollectionView){
				var list:ListCollectionView = dg.dataProvider as ListCollectionView;
				for(var i:int = 0; i < list.length ; i++){  
					var s:Object = list.getItemAt(i);
					s[_column.dataField] = _ck.selected;//更改没一行的选中状态  
				} 
				list.itemUpdated(null);
			}
			//树状表格
			else if(dg.dataProvider is HierarchicalCollectionView){
				var hcv:HierarchicalCollectionView = dg.dataProvider as HierarchicalCollectionView;
				selectAll(hcv.source, hcv.source.getRoot(), _ck.selected);
				hcv.itemUpdated(null);
			}
		} 
		
		private function selectAll(src:IHierarchicalData, obj:Object, v:Boolean):void{
			obj[_column.dataField] = v;
			if(src.hasChildren(obj)){
				var _children:Object = src.getChildren(obj);
				if(_children is Array){
					for(var i:int = 0; i<(_children as Array).length; i++){
						selectAll(src, _children[i], v);
					}
				}
				else{
					selectAll(src, _children, v);
				}
			}
		}
	}
}
