package hc.components.toolbar
{
	[IconFile('/assets/icon/btn_add.png')]
	public class AddButton extends ToolbarButton
	{
		public function AddButton()
		{
			super();
			this.label='新增'; 
		}
		private var _cusDataObj:Object = new Object();
		public function get cusDataObj():Object
		{
			return _cusDataObj;
		}
		
		public function set cusDataObj(value:Object):void
		{
			this._cusDataObj=value;
		}
	}
}