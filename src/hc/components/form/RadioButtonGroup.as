package hc.components.form
{
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import flash.events.FocusEvent;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.layouts.TileLayout;
	
	public class RadioButtonGroup extends Group implements IFormItemComponent
	{
		public var labelField:String = 'label';
		public var dataField:String = 'cd';
		private var _dataValue:String = null;
		
		private var _dataProvider:IList;
		
		public var required:Boolean = false;//是否必填,如果为true则表示必填，不能为空
		
		//取数据的url
		private var _url:String = null;
		
		public function RadioButtonGroup()
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			var lay:TileLayout = new TileLayout();
			lay.horizontalGap = 10;
			lay.verticalGap = 10;
			lay.paddingLeft = 0;
			lay.paddingTop = 5;
			lay.paddingRight = 5;
			lay.paddingBottom = 5;
			this.layout = lay;
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{loadData()});
			//光标移出的时候验证
			this.addEventListener(FocusEvent.FOCUS_OUT, function(event:FocusEvent):void{validate();});
		}
		
		private function createRadioButton():void{
			this.removeAllElements();
			if(_dataProvider){
				var radioButton:RadioButton;
				var item:Object;
				for(var i:int = 0; i<_dataProvider.length; i++){
					item = _dataProvider.getItemAt(i);
					radioButton = new RadioButton();
					radioButton.selected = false;
					radioButton.groupName = this.id;
					radioButton.label = item[labelField];
					radioButton.value = item[dataField];
					this.addElement(radioButton);
				}
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
		
		//加载数据
		private function loadData():void{
			if(Util.isNotBlank(_url)){
				HttpUtil.doPost(_url, null, function(obj:Object):void{
					dataProvider = new ArrayList(obj as Array);
				},null,false);
			}
			else{
				setSelected();
			}
		}
		
		public function set dataProvider(value:IList):void{
			_dataProvider = value;
			if(this.initialized){
				createRadioButton();
				setSelected();
			}
		}
		
		public function get dataProvider():IList{
			return _dataProvider;
		}
		
		//设置选中
		private function setSelected():void{
			this.errorString = '';
			if(!this.dataField || !this._dataProvider) return;
			
			var item:RadioButton;
			for (var i:int=0; i<this.numElements; i++){
				item = this.getElementAt(i) as RadioButton;
				item.selected = (item.value == _dataValue)
			}
		}
		
		override protected function createChildren():void{
			super.createChildren();
			createRadioButton();
		}
		
		/**
		 * 要求必填，切没有选中值的时候验证不通过
		 */
		public function validate():Boolean
		{
			if(required && Util.isBlank(dataValue)){
				this.errorString= "必填项";
				return false;
			}
			else{
				this.errorString = '';
				return true;
			}
		}
		
		public function reset():void
		{
			dataValue = _defaultValue;
			this.errorString = '';
		}
		
		public function get dataValue():String
		{
			var v:String = null;
			var item:RadioButton;
			for (var i:int=0; i<this.numElements; i++){
				item = this.getElementAt(i) as RadioButton;
				if(item.selected){
					v = item.value.toString();
					break;
				}
			}
			return v;
		}
		
		public function set dataValue(v:String):void
		{
			_dataValue = v;
			if(Util.isNotBlank(v)){
				setSelected();
			}
		}
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
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