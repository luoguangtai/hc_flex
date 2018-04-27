package hc.components.datagrid.itemrenderer
{
	import hc.components.datagrid.AdvancedDataGrid;
	import hc.components.datagrid.AdvancedDataGridColumn;
	import hc.components.form.RadioButton;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.HierarchicalCollectionView;
	import mx.collections.IHierarchicalData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	
	import spark.components.Group;
	
	public class AdvancedDataGridRadioButtonItemRenderer extends Group implements IListItemRenderer,IDropInListItemRenderer
	{
		private var _rb:RadioButton;
		private var _data:Object; 
		private var _listData:BaseListData;
		
		public function AdvancedDataGridRadioButtonItemRenderer(){  
			super();  
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			_rb = new RadioButton(); 
			_rb.horizontalCenter = 0;
			_rb.verticalCenter = 0;
			_rb.addEventListener(Event.CHANGE, changeHandle);
			this.addElement(_rb);
		}  
		
		public function set data(value:Object):void{ 
			_data = value; //保存整行的引用  
			_rb.selected = (value[getColumn().dataField] == true  || value[getColumn().dataField] =="true");  
			
			//树状表格只在叶子上显示单选扭
			var dg:AdvancedDataGrid = this.owner as AdvancedDataGrid;
			if(dg.dataProvider is HierarchicalCollectionView){
				var hcv:HierarchicalCollectionView = dg.dataProvider as HierarchicalCollectionView;
				if(hcv.source.hasChildren(value)){
					_rb.visible = false;
				} 
				else{
					_rb.visible = true;
				}
			}
		}  
		
		 public function get data():Object{ 
			return this._data; 
		}  
		
		//点击check box时，根据状况向selectedItems array中添加当前行的引用，或者从array中移除  
		private function changeHandle(e:Event):void{   
			var dataField:String = getColumn().dataField;
			
			var dg:AdvancedDataGrid = this.owner as AdvancedDataGrid;
			//表格的数据源
			if(dg.dataProvider is ArrayCollection){
				var list:ArrayCollection = dg.dataProvider as ArrayCollection;
				
				for(var i:int = 0; i < list.length ; i++){  
					//去除其他行的选择状态
					if(_data == list.getItemAt(i)){
						list.getItemAt(i)[dataField] =  true;
					}
					else{
						list.getItemAt(i)[dataField] =  false;
					}
				} 
				list.itemUpdated(null);
			}
			//树状表格
			else if(dg.dataProvider is HierarchicalCollectionView){
				var hcv:HierarchicalCollectionView = dg.dataProvider as HierarchicalCollectionView;
				//把其它行的值设为false
				resetTreeDataValue(hcv.source, hcv.source.getRoot(), dataField);
			}
		}  
		
		private function resetTreeDataValue(src:IHierarchicalData, obj:Object, dataField:String):void{
			if(src.hasChildren(obj)){
				var _children:Object = src.getChildren(obj);
				if(_children is Array){
					for(var i:int = 0; i<(_children as Array).length; i++){
						resetTreeDataValue(src, _children[i], dataField);
					}
				}
				else{
					resetTreeDataValue(src, _children, dataField);
				}
			}
			else{
				if(_data==obj){
					obj[dataField] = true;
				}
				else{
					obj[dataField] = false;
				}
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
