package hc.components.form
{
	
	import hc.components.Tree;
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	
	import spark.components.ComboBox;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	
	public class ComboBoxTree extends spark.components.ComboBox implements IFormItemComponent
	{
		[SkinPart(required="false")]
		public var tree:Tree;
		
		public var treeSelectedObject:Object;
		//tree是否只可以选择子节点  ,true,只可以选择子节点
		public var _isSelectLeaf:Boolean = false;
		//tree取数据的url
		public var _treeUrl:String = null;
		//tree的显示字段
		public var _treeLabelField:String = null;
		protected var _treeDataSource:Object = null;
		
		//是否可编辑
		private var _editable:Boolean = true;
		//是否显示展开按钮
		private var _openButtonVisible:Boolean = true;
		
		public var required:Boolean = false;//是否必填
		//选中的值
		private var _dataValue:String = null;
		//数据字段，与labelField相对应
		public var dataField:String = null;
		
		public function ComboBoxTree()
		{
			super();
			this.labelField = "label";
			this.dataField = "cd";
			this.addEventListener(FlexEvent.VALUE_COMMIT, valueCommitValid);
		}
		/**
		 * 数据变更提交时验证,验证通过则置空errorString
		 */
		private function valueCommitValid(event:FlexEvent):void
		{
			validate();
		}
		public function validate():Boolean
		{
			if(this.textInput.text==""&&this.textInput.text==null){
				if(this.tree){
					this.tree.selectedIndex = -1;
				}
			}
			var bResult:Boolean = true;
			//先判断是否必填，如果是必填项，则不能为空
			if(this.required){
				if(this.textInput.text==""&&this.textInput.text==null)
					bResult = false;
				this.errorString= "必填项";
			}
			
			//如果全部验证通过，则清空errorString
			if(bResult)
			{
				this.errorString="";
			}
			return bResult;
		}
		
		public function set treeDataSource(obj:Object):void{
			_treeDataSource = obj; 
			setSelected(_treeDataSource);
		}
		
		public function get treeDataSource():Object{
			return _treeDataSource;
		}
		/**
		 * 重置
		 */ 
		public function reset():void{
			this.textInput.text="";
			this.dataValue = "";
			this.selectedItemCt=null;
			this.errorString = "";
		}	
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		//设置选中的值
		public function set dataValue(value:String):void{
			_dataValue = value;
			setSelected(treeDataSource);
		}
		
		//取选中的值
		public function get dataValue():String
		{
			return this._dataValue;
		}
		override public function set dataProvider(value:IList):void{
			super.dataProvider = value;
		}
		//设置选中
		private function  setSelected(obj:Object):void
		{
			this.errorString = '';
			if(!this.dataField || !this._dataValue || !obj) return;
			if(obj[this.dataField]==this.dataValue){
				this.textInput.text=obj[this._treeLabelField];
				this.selectedItemCt=obj;
				return;
			}
			if(obj.hasOwnProperty("children")){
				var childrenObj:Object = obj["children"];
				for(var i:String in childrenObj){
					if(childrenObj[i][this.dataField]==this.dataValue){
						this.textInput.text=childrenObj[i][this._treeLabelField];
						this.selectedItemCt=childrenObj[i];
						return;
					}
					//trace(childrenObj[i].orgNameAbbr);
					if(childrenObj[i]!=null)
					{
						if(childrenObj[i].hasOwnProperty("children"))
						{
							setSelected(childrenObj[i]);
						}
					}
				}
			}
		}
		/**
		 * 设置是否能手动输入数据
		 */
		public function set editable(value:Boolean):void
		{
			_editable = value;
			if(this.textInput){
				this.textInput.editable = value;
			}
		}
		public function set openButtonVisible(value:Boolean):void
		{
			_openButtonVisible = value;
			if(!_openButtonVisible && this.openButton){
				this.openButton.visible = false;
			}else if(_openButtonVisible && this.openButton){
				this.openButton.visible = true;
			}
			if(!_openButtonVisible && this.textInput){
				this.textInput.right = 0;
			}else if(_openButtonVisible && this.textInput){
				this.textInput.right = 18;
			}
		}
		override protected function createChildren():void{
			super.createChildren();
			this.textInput.editable = _editable;
			this.openButton.visible = _openButtonVisible;
			if(!_openButtonVisible){
				this.textInput.right = 0;
			}
		}
		/**
		 *tree取数据的url
		 */
		public function set treeUrl(value:String):void
		{
			_treeUrl = value;
			if(Util.isNotBlank(_treeUrl)){
				HttpUtil.doPost(_treeUrl, null, function(obj:Object):void{
					_treeDataSource = obj;
					setSelected(_treeDataSource);
				},null,false);
			}
		}
		
		/**
		 *tree的显示字段
		 */
		public function set treeLabelField(value:String):void
		{
			_treeLabelField = value;
		}
		
		/**
		 *是否只能选择子节点，  true：只可以选择子节点
		 */
		public function set isSelectLeaf(value:Boolean):void
		{
			_isSelectLeaf = value;
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName,instance);
			if(tree==instance){
				tree.dataProvider=_treeDataSource;
				tree.labelField=this._treeLabelField;
				tree.addEventListener(ListEvent.ITEM_CLICK,onTreeClick);
				tree.addEventListener(TreeEvent.ITEM_OPEN,onTreeItemOpen);
				tree.addEventListener(FlexEvent.CREATION_COMPLETE,function(event:FlexEvent):void{
					if(dataField!=null && dataValue!=null){
						locateNode(dataField,dataValue);
						treeScrollBySelectIndex();
					}
				});
			}
		} 
		
		protected function onTreeItemOpen(event:TreeEvent):void
		{
			if (treeSelectedObject && !tree.isItemOpen(treeSelectedObject))
			{
				tree.selectedItem=this.treeSelectedObject;
				tree.expandItem(tree.selectedItem, true);
				expandParents(tree.selectedItem);
			}
		}
		
		public function expandParents(node:Object):void
		{
			if (node && !tree.isItemOpen(node))
			{
				tree.expandItem(node, true);
				expandParents(tree.getParentItem(node));
				//expandParents(node.parent()); 
			}		
		}
		//tree单击
		protected function onTreeClick(event:ListEvent):void
		{
			treeSelectedObject=TreeItemRenderer(event.itemRenderer).data;
			if(this._isSelectLeaf){
				if(!tree.dataDescriptor.isBranch(treeSelectedObject)){
					writeValue(event);
				}
				else{
					tree.expandItem(treeSelectedObject, true);
				}
			}else{
				writeValue(event);
			}
		}
		/**
		 * tree单击选中的值写入ComboBox
		 * */
		protected function writeValue(event:ListEvent):void{
			this.textInput.text=TreeItemRenderer(event.itemRenderer).data[this._treeLabelField];
			this.dataValue = TreeItemRenderer(event.itemRenderer).data[this.dataField];
			var va:String = TreeItemRenderer(event.itemRenderer).data[this.dataField];
			locateNode(dataField,va);
			treeScrollBySelectIndex();
			this.selectedItemCt=TreeItemRenderer(event.itemRenderer).data;
			closeDropDown(true);
			
			//抛出change事件
			this.dispatchEvent(new IndexChangeEvent('change'));
		}
		private var locatedNode:Object = null;
		/**
		 * 定位树结点
		 */
		public function locateNode(key:String,val:String):void{
			var parentList:ArrayList = new ArrayList();
			if(!matchTreeNode(key,val,tree.dataProvider,0,parentList)) return ;
			if(parentList.length > 0){
				for(var i:int=0;i<parentList.length-1;i++){
					tree.expandItem(parentList.getItemAt(i),true);
				}
				tree.selectedItem=locatedNode;
			}
		}
		private function matchTreeNode(key:String,val:String,obj:Object,index:int,parentList:ArrayList):Boolean{
			for each(var item:Object in obj){
				if(parentList.length>index){
					parentList.setItemAt(item,index);
				}else{
					parentList.addItem(item);
				}
				if(item[key]==val){
					locatedNode = item;
					return true;
				}else if(item["children"] != null){
					if(matchTreeNode(key,val,item["children"] as Array,index+1,parentList)){
						return true;
					}	
				}
			}
			return false;
		}
		/**
		 * 定位树结点
		 */
		private function treeScrollBySelectIndex():void{
			if(tree!=null){
				var indexI:int = tree.selectedIndex;
				if(indexI>-1){
					tree.scrollToIndex(indexI);
				}
			}
		}
		public var _selectedItemCt:Object = null;
		/**
		 * 设置选中树的对象
		 */
		public function set selectedItemCt(value:Object):void
		{
			this._selectedItemCt=value;
		}
		/**
		 *获取选中树的对象 
		 * */
		public function get selectedItemCt():Object
		{
			return this._selectedItemCt;
		}
		override protected function textInput_changeHandler(event:TextOperationEvent):void
		{
			// TODO Auto Generated method stub
			//super.textInput_changeHandler(event);
			
		}
	}
}