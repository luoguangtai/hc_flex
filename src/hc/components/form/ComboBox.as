package hc.components.form
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.StringUtil;
	
	import spark.components.ComboBox;
	import spark.components.supportClasses.ItemRenderer;
	import spark.events.DropDownEvent;
	import spark.events.TextOperationEvent;
	import spark.skins.spark.DefaultItemRenderer;
	
	import hc.components.form.CheckBoxItemRenderer;
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	[IconFile("/assets/icon/icon_comboBox.png")]
	public class ComboBox extends spark.components.ComboBox implements IFormItemComponent
	{
		
		/**
		 * 标识下拉框类型为单选或多选，当comboBoxType为single表示单选，multiple表示多选。
		 */
		private var _comboBoxType:String = 'single';
		
		//是否可编辑
		private var _editable:Boolean = true;
		//是否显示展开按钮
		private var _openButtonVisible:Boolean = true;
		//选中的值
		private var _dataValue:String = null;
		//数据字段，与labelField相对应
		public var dataField:String = null;
		
		//取数据的url
		private var _url:String = null;
		
		public var required:Boolean = false;//是否必填
		
		//3种类型的下拉框：必须选一个、显示空值、显示-全部-
		[Inspectable(category="General", enumeration="normal,showBlank,showAll" , defaultValue="normal")]
		public var type:String = 'normal';//是否必填,如果为true则表示必填，不能为空
		
		private var unSelectedCount:int = 0;//记录多选下拉框未选中的项数
		
		public function ComboBox()
		{
			super();
			this.labelField = "label";
			this.dataField = "cd";
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{
				loadData()
			});
			this.addEventListener(FlexEvent.VALUE_COMMIT, valueCommitValid);
		}
		
		override protected function item_mouseDownHandler(event:MouseEvent):void
		{
			if(_comboBoxType=="single"){
				super.item_mouseDownHandler(event);
				closeDropDown(true);
			}
		}
		/**
		 * 数据变更提交时验证,验证通过则置空errorString
		 */
		private function valueCommitValid(event:FlexEvent):void
		{
			validate();
		}
		
		//回车将光标移动到下一个组件
		override protected function keyDownHandler(event:KeyboardEvent):void{
			super.keyDownHandler(event);
			Util.nextComponent(event, this.focusManager);
		}
		
		//加载数据
		private var allList:IList;//记录原始数据源
		private function loadData():void{
			if(Util.isNotBlank(_url)){
				HttpUtil.doPost(_url, null, function(obj:Object):void{
					dataProvider = new ArrayList(obj as Array);
				},null,false);
			}
		}
		
		override public function set dataProvider(value:IList):void{
			//第一行增加空值
			var obj:Object = {};
			if(type=='showBlank'){
				obj[this.labelField] = '';
				obj[this.dataField] = '';
				value.addItemAt(obj, 0);
			}
			if(type=='showAll'){
				obj[this.labelField] = '--全部--';
				obj[this.dataField] = '';
				value.addItemAt(obj, 0);
			}
//			if(type=='normal'){
//				this.selectedIndex=-1;
//			}
			allList = value;
			super.dataProvider = value;
			
			//设置默认选中
			setSelected();
		}

		public function set openButtonVisible(value:Boolean):void
		{
			_openButtonVisible = value;
			if(!_openButtonVisible && this.openButton){
				this.openButton.visible = false;
			}
			else if(_openButtonVisible && this.openButton){
				this.openButton.visible = true;
			}
			if(!_openButtonVisible && this.textInput){
				this.textInput.right = 0;
			}
			else if(_openButtonVisible && this.textInput){
				this.textInput.right = 18;
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
		
		public function set url(value:String):void
		{
			_url = value;
			//加载数据
			if(this.initialized){
				loadData();
			}
		}
		
		public function get comboBoxType():String
		{
			return _comboBoxType;
		}
		
		[Inspectable(category="General", enumeration="single,multiple" , defaultValue="single")]
		public function set comboBoxType(value:String):void
		{
			_comboBoxType = value;
			if(_comboBoxType=='multiple'){
				itemRenderer = new ClassFactory(CheckBoxItemRenderer);//多选下拉框
			}
			else{
				itemRenderer = new ClassFactory(DefaultItemRenderer);
			}
		}
		
		override protected function createChildren():void{
			super.createChildren();
			this.textInput.editable = _editable;
			this.openButton.visible = _openButtonVisible;
			if(!_openButtonVisible){
				this.textInput.right = 0;
			}
//			if(_comboBoxType=='multiple'){
//				itemRenderer = new ClassFactory(CheckBoxItemRenderer);//多选下拉框
//			}
		}
		
		//设置选中
		private function setSelected():void{
			this.errorString = '';
			if(!this.dataField || !this.dataProvider || !this._dataValue) return;
			var itemObj:Object = null;
			for (var i:int=0; i<this.dataProvider.length; i++){
				itemObj =  this.dataProvider.getItemAt(i);
				if(_comboBoxType=="single"){//单选
					if (_dataValue == itemObj[dataField]){
						this.selectedIndex =i;		
						return ;
					}
				}
				else{//多选
					var valArr:Array = [];
					
					var str:String='';
					if(Util.isNotBlank(_dataValue)){
						valArr = _dataValue.split(",");
					}
					
					for(var j:int=0;j<valArr.length;j++){
						if(valArr[j]==itemObj[dataField]){
							itemObj._selected = true;
							break;
						}
						unSelectedCount = dataProvider.length-valArr.length;
					}
				}
			}
			if(type=='showBlank'){
				this.selectedIndex = 0;
			}
			else if(type=='showAll'){
				if(unSelectedCount == 0){//全部选中
					this.selectedIndex = 0;
				}
				else{
					this.selectedIndex = -1;
				}
			}
			else{
				this.selectedIndex = -1;
			}
			
			if(_comboBoxType=='multiple'){
				updateText();
			}
		}
		
		//过滤数据
		private var tempList:IList = new ArrayList();;//记录过滤后的数据源
		
		override protected function textInput_changeHandler(event:TextOperationEvent):void{
			super.textInput_changeHandler(event); 
			
			var keyWord:String=StringUtil.trim(this.textInput.text);
			if(Util.isBlank(keyWord)){
				super.dataProvider = allList;
			}
			else{
				searchKeyWord(keyWord);
			}
		} 
		
		private function searchKeyWord(keyWord:String):void{
			tempList.removeAll();
			for(var i:int=0;i<allList.length;i++){
				var item:Object=allList.getItemAt(i);
				if(item[this.labelField].indexOf(keyWord , 0) > -1 || item[this.dataField].indexOf(keyWord , 0) > -1){
					tempList.addItem(item);
				}
			}
			super.dataProvider=tempList;
			
		}
		
		/*****************表单相关*************/
		
		//设置选中的值
		public function set dataValue(value:String):void{
			_dataValue = value;
			setSelected();
		}
		
		//取选中的值
		public function get dataValue():String
		{
			if(_comboBoxType == 'single'){
				if ((this.selectedIndex<0)|| (this.dataField == null))
				{
					return null;
				}
			}
			else if(_comboBoxType == 'multiple'){
				return getSelectedValues();
			}
			return this.selectedItem[dataField];
		}
		
		/**
		 * 返回下拉框显示的文本串
		 */ 
		public function get text():String{
			if ((this.selectedIndex<0)|| (this.dataField == null))
			{
				return null;
			}
			return this.itemToLabel(this.selectedItem);
		}
		
		public function validate():Boolean
		{
			//如果没有选中则置空文本框
			/*if(this.selectedIndex<0){
				if(type=='showBlank' || type=='showAll'){
					this.selectedIndex = 0;
				}
				else{
					this.selectedIndex = -1;
				}
			}*/
			
			var bResult:Boolean = true;
			//先判断是否必填，如果是必填项，则不能为空
			if(this.required){
				if(_comboBoxType == 'single'){
					if((this.type=='normal' && this.selectedIndex<0) 
						|| (this.type=='showBlank' && this.selectedIndex<1) 
						|| (this.type=='showAll' && this.selectedIndex<1))
					bResult = false;
					this.errorString= "必填项";
				}
				else if(_comboBoxType == 'multiple'){
					if(this.selectedItems.length<=0)
						bResult = false;
					this.errorString= "必填项";
				}
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
			if(type=='showBlank' || type=='showAll'){
				if(_comboBoxType == 'single'){
					this.selectedIndex = 0;
				}
				else{
					for(var i:int=0; i<this.dataProvider.length; i++){
						var itemObj:Object =  this.dataProvider.getItemAt(i);
						itemObj._selected = false;
						unSelectedCount = dataProvider.length;
						this.selectedIndex = -1;
						this.textInput.text = "";
					}
				}
			}
			else{
				if(_comboBoxType == 'single'){
					this.selectedIndex = -1;
				}
				else{
					for(var i:int=0; i<this.dataProvider.length; i++){
						var itemObj:Object =  this.dataProvider.getItemAt(i);
						itemObj._selected = false;
						unSelectedCount = dataProvider.length;
						this.selectedIndex = -1;
						this.textInput.text = "";
					}
				}
			}
			this.errorString = "";
		}	
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		
		override public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			var i:int = 0;
			for (i; i < dataProvider.length; i++){
				if(dataProvider.getItemAt(i)._selected==true){
					result.push(dataProvider.getItemAt(i));
					
				}
			}
			if(type=='showAll' && dataProvider.getItemAt(0)._selected == true){
				if(dataProvider.length == result.length){
					for(var j:int=dataProvider.length-1;j>0;j--){
						result.pop();
					}
				}
				else{
					result = new Vector.<Object>();
					for (var k:int=1; k < dataProvider.length; k++){
						if(dataProvider.getItemAt(k)._selected==true){
							result.push(dataProvider.getItemAt(k));
						}
					}
				}
			}
			return result;
		}
		
		public function updateText():void {
			var items:Vector.<Object> = this.selectedItems;
			var str:String = '';
			for(var i:int=0; i<items.length; i++){
				if(i>0){
					str += ',';
				}
				str += items[i][this.labelField];
			}
			this.textInput.text = str;
		}
		
		//复选时获取选中的dataField的dataValue
		public function getSelectedValues():String {
			var items:Vector.<Object> = this.selectedItems;
			var str:String = '';
			for(var i:int=0; i<items.length; i++){
				if(i>0){
					str += ',';
				}
				str += items[i][this.dataField];
			}
			return str;
		}
		
		/**
		 * 默认值
		 */ 
		private var _defaultValue:String = '';
		public function get defaultValue():String{
			return _defaultValue;
		}
		public function set defaultValue(obj:String):void{
			_defaultValue = obj;
		}
	}
}