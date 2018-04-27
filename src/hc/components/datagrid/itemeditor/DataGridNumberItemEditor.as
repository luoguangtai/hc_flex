package hc.components.datagrid.itemeditor
{
	import hc.components.form.TextInput;
	import hc.util.Util;
	
	import spark.components.gridClasses.GridItemEditor;
	
	public class DataGridNumberItemEditor extends GridItemEditor
	{
		private var _v:String = '';
		private var _textInput:TextInput;
		
		public function DataGridNumberItemEditor()
		{
			super();
			_textInput = new TextInput();
			_textInput.percentWidth = 100;
			_textInput.percentHeight = 100;
			_textInput.dataType = 'number';
			_textInput.nextComponent = false;
			this.addElement(_textInput);
		}
		
		override public function get value():Object
		{
			if(!_textInput.validate()){
				return _v;
			}
			else{
				return _textInput.text;
			}
		}
		
		override public function set value(newValue:Object):void
		{
			if(Util.isBlank(newValue)){
				_v = '';
				_textInput.text = '';
			}
			else{
				_v = newValue.toString();
				_textInput.text = newValue.toString();
			}
//			_v = newValue != null ? newValue.toString() : '';
//			_textInput.text = newValue != null ? new Number(newValue.toString()).toString() : '';
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