package hc.components.toolbar
{
	import hc.Const;
	import hc.components.Button;
	

	[IconFile('/assets/icon/btn_add.png')]
	public class ToolbarButton extends Button
	{
		public function ToolbarButton()
		{
			super();
			this.label='Toolbar按钮基类'; 
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled = value;
			this.filters = value?Const.ENABLED_FILTERS:Const.DISABLED_FILTERS;
		}
	}
}