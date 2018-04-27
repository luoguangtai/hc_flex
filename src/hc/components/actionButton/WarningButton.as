package hc.components.actionButton
{
	import hc.components.Button;
	
	/**
	 * 警示按钮，主要用在作废等操作上
	 */
	[IconFile('/assets/icon/btn_warning.png')]
	public class WarningButton extends Button
	{
		public function WarningButton()
		{
			super();
			this.setStyle('focusThickness',5);
		}
	}
}