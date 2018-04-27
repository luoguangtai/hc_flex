package hc.components.detailGrid
{
	import mx.collections.IList;
	import mx.controls.Text;
	import mx.core.EventPriority;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	public class DetailLabel extends Text
	{
		public var fieldName:String;  //业务ID
		private var _value:String;
		private var _dataProvider:IList;
		public var dataField:String = "value";
		public var labelField:String = "name";
		public var delim:String = ",";
		private var createdStatus:Boolean = false;//当前控件是否创建完成
		protected var initVal:String;
		public function DetailLabel()
		{
			super();
			/*this.setStyle("paddingLeft","10");
			this.setStyle("paddingTop","10");
			this.setStyle("paddingRight","10");
			this.setStyle("paddingBottom","10");*/
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandle,false,EventPriority.DEFAULT_HANDLER);
		}
		protected function creationCompleteHandle(event:FlexEvent):void{
			createdStatus = true;
			setShowText(_value);
		}
		
		public function get dataValue():String
		{
			return _value;
		}
		
		public function set dataValue(value:String):void
		{
			_value = value;
			super.text = "";
			if(createdStatus){
				setShowText(value);
			}
			if(initVal == null){
				initVal = value;
			}
		}
		
		public function reset():void{
			if(initVal != null){
				setShowText(initVal);
			}else{
				setShowText("");
			}
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			_dataProvider = value;
		}
		
		protected function setShowText(value:String):void{
			if(value == null) return;
			if(_dataProvider == null){
				super.text = value;
			}else{
				var valArr:Array;
				if(value.indexOf("[") > -1 && value.indexOf("]") > -1){
					//checkBox数据格式
					valArr = value.substr(1,value.length-2).split("][");
				}else{
					//普通数据格式
					valArr = [value];
				}
				for each(var val:String in valArr){
					for each(var itemObj:Object in _dataProvider.toArray()){
						if(val == itemObj[dataField]){
							if(StringUtil.trim(super.text) != ""){
								super.text = super.text + delim;
							}
							super.text = super.text + itemObj[labelField];
						}
					}
				}
			}
		}
	}
}