package hc.components.form
{
	import hc.components.CheckTree;
	import hc.events.CustomEvent;
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import flash.events.KeyboardEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import spark.components.ComboBox;
	
	public class ComboBoxCheckTree extends ComboBox implements IFormItemComponent
	{
		[SkinPart(required="true")]
		public var tree:CheckTree;
		
		public var treeSelectedObject:Object;
		//tree取数据的url
		public var _treeUrl:String = null;
		//tree的显示字段
		public var _treeLabelField:String = null;
		private var _treeDataSource:Object = null;
		
		//选中的值
		private var _dataValue:String = null;
		private var selectTreeArray:Array = [];
		//数据字段，与labelField相对应
		public var dataField:String = null;
		
		//是否可编辑
		private var _editable:Boolean = false;
		//是否显示展开按钮
		private var _openButtonVisible:Boolean = true;
		
		public var required:Boolean = false;//是否必填
		
		
		public function ComboBoxCheckTree()
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
		/**
		 * 重置
		 */ 
		public function reset():void{
			this.textInput.text="";
			this.dataValue = "";
			this.errorString = "";
		}	
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		//回车将光标移动到下一个组件
		override protected function keyDownHandler(event:KeyboardEvent):void{
			super.keyDownHandler(event);
			Util.nextComponent(event, this.focusManager);
		}
		
		public function set openButtonVisible(value:Boolean):void
		{
			_openButtonVisible = value;
			if(!_openButtonVisible && this.openButton){
				this.openButton.visible = false;
			}
			if(!_openButtonVisible && this.textInput){
				this.textInput.right = 0;
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
					treeDataSource = obj;
					setSelectedText();
				},null,false);
			}
		}
		
		public function set treeDataSource(value:Object):void{
			_treeDataSource = value;
		}
		
		public function get treeDataSource():Object{
			return _treeDataSource;
		}
		
		/**
		 *tree的显示字段
		 */
		public function set treeLabelField(value:String):void
		{
			_treeLabelField = value;
		}
		
		//设置选中的值
		public function set dataValue(value:String):void{
			_dataValue = value;
			setSelectedText();
		}
		
		//取选中的值
		public function get dataValue():String
		{
			return this._dataValue;
		}
		
		//取选中的数值数组
		public function getSelected():Array{
			return selectTreeArray;
		}
		
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName,instance);
			//每次点下拉框展开的时候都会调用partAdded
			if(tree==instance){
				tree.dataProvider = _treeDataSource;
				tree.labelField = this._treeLabelField;
				tree.addEventListener("checkBoxChanged",checkBoxChanged);
				tree.selectedString(this.dataField, this.dataValue);
				checkBoxChanged(null);
			}
		}
		private function checkBoxChanged(event:CustomEvent):void{
			//获取选中的结果
			selectTreeArray = tree.getSelected(true);
			//改变文本框和dataValue
			var selectStr:String = "";
			var selectValue:String = "";
			for each(var obj:Object in selectTreeArray){
				if(selectStr.length>0){
					selectStr += ",";
				}
				selectStr += obj[this._treeLabelField];
				if(selectValue.length>0){
					selectValue += ",";
				}
				selectValue += obj[this.dataField];
			}
			this.textInput.text = selectStr;
			this._dataValue = selectValue;
		}
		
		/**
		 * 根据dataValue设置下拉框的文本
		 */ 
		private function setSelectedText():void{
			if(this.textInput==null){
				return;
			}
			this.textInput.text = '';
			if(Util.isBlank(_dataValue) || Util.isBlank(_treeDataSource)){
				return;
			}
			var selectedColl:ArrayCollection = new ArrayCollection(_dataValue.split(","));
			var _selItems:Array = [];
			
			if(_treeDataSource is Array){
				for(var i:int=0; i<_treeDataSource.length; i++){
					intialingItemSeletedState(_treeDataSource[i],dataField,selectedColl,_selItems);
				}
			}
			else{
				intialingItemSeletedState(_treeDataSource,dataField,selectedColl,_selItems);
			}
			this.textInput.text = _selItems.join(",");
		}
		
		//初始化设置数据，返回选中的叶子结点
		private  function intialingItemSeletedState(item:Object,dataField:String,selections:ArrayCollection,selItems:Array):void{			
			//遍历其子节点集合
			if (item.hasOwnProperty("children"))
			{
				var iCount:int = item.children.length;
				for (var i:int =0 ; i<iCount; i++)
				{
					intialingItemSeletedState(item.children[i],dataField,selections,selItems);
				}
			}
			else{
				var isSelected:Boolean = selections.contains(item[dataField]);
				if(isSelected){
					selItems.push(item[this._treeLabelField]);
				}
			}
		}	
	}
}