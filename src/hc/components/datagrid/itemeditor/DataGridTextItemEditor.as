package hc.components.datagrid.itemeditor
{
	import hc.components.form.TextInput;
	import spark.components.gridClasses.GridItemEditor;
	
	public class DataGridTextItemEditor extends GridItemEditor
	{
		private var _v:String = '';
		private var _textInput:TextInput;
		
		public function DataGridTextItemEditor()
		{
			super();
			_textInput = new TextInput();
			_textInput.percentWidth = 100;
			_textInput.percentHeight = 100;
			_textInput.dataType = 'string';
			_textInput.nextComponent = false;
			this.addElement(_textInput);
		}
		
		override public function get value():Object
		{
				return _textInput.text;
		}
		
		override public function set value(newValue:Object):void
		{
			_v = newValue != null ? newValue.toString() : '';
			_textInput.text = newValue != null ? newValue.toString() : '0';
		}
		
		override public function setFocus():void
		{
			_textInput.setFocus();
			_textInput.selectAll();
		}
		override public function save():Boolean
		{
			var s:Boolean = super.save();
			if(s && _v!=_textInput.text){
				data['_UPDATE'] = true;
				dataGrid.dataProvider.itemUpdated(data);
			}
			return s;
		}
	}
}