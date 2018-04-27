package hc.components
{
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Tree;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	[Event(name="checkBoxChanged", type="hc.events.CustomEvent")]

	/**
	 * 三状态复选框树控件
	 */
	
	public class CheckTree extends Tree
	{
		/**
		 * STATE_SCHRODINGER : 部分子项选中 
		 * STATE_CHECKED :     全部子项选中 
		 * STATE_UNCHECKED :   全部子项未选中 
		 */
		public var STATE_SCHRODINGER:int=2;
		public var STATE_CHECKED:int=1;
		public var STATE_UNCHECKED:int=0;
		
		//数据源中状态字段
		private var m_checkBoxStateField:String="state";
		//取消选择是否收回子项
		[Bindable]
		private var m_checkBoxCloseItemsOnUnCheck:Boolean=false;
		//选择项时是否展开子项
		[Bindable]
		private var m_checkBoxOpenItemsOnCheck:Boolean=false;
		//选择框左边距的偏移量
		[Bindable]
		private var m_checkBoxLeftGap:int=8;
		//选择框右边距的偏移量
		[Bindable]
		private var m_checkBoxRightGap:int=20;
		//与父项子项关联
		[Bindable]
		private var m_checkBoxCascadeOnCheck:Boolean=true;
		
		//双击项目
		public var itemDClickSelect:Boolean=true;
		
		//取数据的url
		private var _url:String = null;
		
		
		public function CheckTree()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,function(event:FlexEvent):void{
				loadData();
			});
			doubleClickEnabled=true;
		}
		/**
		 *远程服务端url 
		 */
		public function set url(value:String):void
		{
			_url = value;
			//加载数据
			if(this.initialized){
				loadData();
			}
		}
		//加载数据
		private function loadData():void{
			if(Util.isNotBlank(_url)){
				HttpUtil.doPost(_url, null, function(obj:Object):void{
					dataProvider = obj;
				},null,false);
			}
		}
		override protected function createChildren():void
		{
			var myFactory:ClassFactory=new ClassFactory(CheckTreeRenderer);
			this.itemRenderer=myFactory;
			super.createChildren();
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDClick);
		}
		public function PropertyChange():void
		{
			dispatchEvent(new ListEvent(mx.events.ListEvent.CHANGE));
		}
		/**
		 * 树菜单，双击事件
		 * @param evt 双击事件源
		 *
		 */
		public function onItemDClick(e:ListEvent):void
		{
			if(itemDClickSelect)
				OpenItems();
		}
		/**
		 * 打开Tree节点函数，被 有打开节点功能的函数调用
		 * @param item	要打开的节点
		 *
		 */
		public function OpenItems():void
		{
			if (this.selectedIndex >= 0 && this.dataDescriptor.isBranch(this.selectedItem))
				this.expandItem(this.selectedItem, !this.isItemOpen(this.selectedItem), true);
		}
		
		/**
		 * 数据源中状态字段
		 * @return 
		 * 
		 */		
		[Bindable]
		public function get checkBoxStateField():String
		{
			return m_checkBoxStateField;
		}
		public function set checkBoxStateField(v:String):void
		{
			m_checkBoxStateField=v;
			PropertyChange();
		}
		
		/**
		 * 取消选择是否收回子项
		 * @return 
		 * 
		 */		
		[Bindable]
		public function get checkBoxCloseItemsOnUnCheck():Boolean
		{
			return m_checkBoxCloseItemsOnUnCheck;
		}
		public function set checkBoxCloseItemsOnUnCheck(v:Boolean):void
		{
			m_checkBoxCloseItemsOnUnCheck=v;
			PropertyChange();
		}
		
		
		/**
		 * 选择项时是否展开子项
		 * @return 
		 * 
		 */		
		[Bindable]
		public function get checkBoxOpenItemsOnCheck():Boolean
		{
			return m_checkBoxOpenItemsOnCheck;
		}
		public function set checkBoxOpenItemsOnCheck(v:Boolean):void
		{
			m_checkBoxOpenItemsOnCheck=v;
			PropertyChange();
		}
		
		
		/**
		 * 选择框左边距的偏移量
		 * @return 
		 * 
		 */		
		[Bindable]
		public function get checkBoxLeftGap():int
		{
			return m_checkBoxLeftGap;
		}
		public function set checkBoxLeftGap(v:int):void
		{
			m_checkBoxLeftGap=v;
			PropertyChange();
		}
		
		
		/**
		 * 选择框右边距的偏移量
		 * @return 
		 * 
		 */		
		[Bindable]
		public function get checkBoxRightGap():int
		{
			return m_checkBoxRightGap;
		}
		public function set checkBoxRightGap(v:int):void
		{
			m_checkBoxRightGap=v;
			PropertyChange();
		}
		
		/**
		 * 与父项子项关联
		 * @return 
		 * 
		 */
		[Bindable]
		public function get checkBoxCascadeOnCheck():Boolean
		{
			return m_checkBoxCascadeOnCheck;
		}
		public function set checkBoxCascadeOnCheck(v:Boolean):void
		{
			m_checkBoxCascadeOnCheck=v;
			PropertyChange();
		}
		
		public function getSelected(onlyLeaf:Boolean = false):Array{
			return getSelectedItems(this, false, onlyLeaf);
		}
		
		/**
		 * 获取树的选择集 
		 * @param tree				树对象；
		 * @param includeParent		是否包括其父节点，前提是tree设置了级联选择；tree和includeParent参数没有用了，只是为了兼容以前的项目
		 * @return 
		 * 保留已经被使用的方法
		 */
		public function getSelectedItems(tree:Tree,includeParent:Boolean = false,onlyLeaf:Boolean = false):Array{
			var selectionArray :Array = new Array();
			if(tree.dataProvider is IList){
				var _list:IList = tree.dataProvider as IList;
				for(var i:int = 0; i<_list.length; i++){
					searchSelectedItem(_list.getItemAt(i), selectionArray, onlyLeaf);
				}
			}
			return selectionArray;
			
//			//转成线性集合视图			
//			if(tree.dataProvider is IHierarchicalCollectionView){
//				var hierachView:IHierarchicalCollectionView = IHierarchicalCollectionView(tree.dataProvider) ;
//				//从当前已展开的视图开始搜索
//				var cursor:IViewCursor =hierachView.createCursor();
//				
//				while(! cursor.afterLast){
//					var curDepth:int =	hierachView.getNodeDepth(cursor.current);
//					if(curDepth ==1){
//						searchSelectedItem(cursor.current,selectionArray,includeParent,onlyLeaf);
//					}
//					cursor.moveNext();				
//				}
//			}else if(tree.dataProvider is IList){
//				//数据若为集合
//				var listData:IList = IList(tree.dataProvider);
//				for(var i:int =0; i<listData.length;i++){
//					searchSelectedItem(listData.getItemAt(i),selectionArray,includeParent,onlyLeaf);
//				}
//			}
//			
//			return selectionArray;
			
		}
		
		/**
		 * 检查节点并遍历其子节点集合，判断选中的节点加入到数组中； 
		 * @param item
		 * @param selection
		 * @param includeParent
		 * 
		 */
		private function searchSelectedItem(item:Object, selection:Array, onlyLeaf:Boolean = false):void
		{
			var curState:int = this.getItemSelectedState(item);	
			//如果只需要选中叶子结点
			if(onlyLeaf){
				var isLeaf:Boolean = !item.hasOwnProperty("children");
				if(curState == STATE_CHECKED && isLeaf){
					selection.push(item);
				}
			}
			else{
				if(curState == STATE_CHECKED || curState== STATE_SCHRODINGER){
					selection.push(item);
				}
			}
			//遍历其子节点集合
			if (item.hasOwnProperty("children"))
			{
				var iCount:int = item.children.length;
				for (var i:int =0 ; i<iCount; i++)
				{
					searchSelectedItem(item.children[i], selection, onlyLeaf);
				}
			}
		}
		
		/**
		 * 获取数据项的选中状态 
		 * @param item 数据项
		 * @return 选中状态，0:未选中，1：选中
		 * 
		 */
		private  function getItemSelectedState(item:Object):int
		{
			if(! item) return 0;
			
			if(item.hasOwnProperty(m_checkBoxStateField))
			{
				return item[m_checkBoxStateField];
			}else{
				return 0;
			}
		}
		
		/**
		 * 外部传值，初始化树的选择集 
		 * @param tree
		 * @param dataField
		 * @param selectedValue
		 * 
		 */
		public function selectedString(dataField:String, selectedValue:String):Array{
			var selectedColl:ArrayCollection = new ArrayCollection(selectedValue.split(","));
			var _selItems:Array = [];
			//数据若为集合
			var listData:IList = this.dataProvider as IList;
			for(var i:int =0; i<listData.length;i++){
				intialingItemSeletedState(listData.getItemAt(i),dataField,selectedColl,_selItems);				
			}
			listData.itemUpdated(null);
			return _selItems;
		}
		
		//初始化设置数据，返回选中的叶子结点
		private  function intialingItemSeletedState(item:Object,dataField:String,selections:ArrayCollection,selItems:Array):int{			
			//遍历其子节点集合
			if (item.hasOwnProperty("children"))
			{
				var _cs1:int = 0;//是否选中
				var _cs2:int = 1;//是否全选中
				var iCount:int = item.children.length;
				for (var i:int =0 ; i<iCount; i++)
				{
					var r1:int = intialingItemSeletedState(item.children[i],dataField,selections,selItems);
					if(r1==1 || r1==2){
						_cs1 = 1;
					}
					if(r1==0 || r1==2){
						_cs2 = 0;
					}
				}
				
				if(_cs1 == 0){
					item[m_checkBoxStateField] = STATE_UNCHECKED;
					return 0;
				}
				else if(_cs2 == 1){
					item[m_checkBoxStateField] = STATE_CHECKED;
					return 1;
				}
				else{
					item[m_checkBoxStateField] = STATE_SCHRODINGER;
					return 2;
				}
			}
			else{
				var isSelected:Boolean = selections.contains(item[dataField]);
				item[m_checkBoxStateField] = isSelected?STATE_CHECKED:STATE_UNCHECKED;
				if(isSelected){
					selItems.push(item);
				}
				return isSelected?1:0;
			}
		}		
	}
}