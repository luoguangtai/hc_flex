package hc.components.actionButton
{
	import hc.components.Button;

	/**
	 * 次要的、附加的按钮，通常用在取消、关闭等操作上
	 */
	[IconFile('/assets/icon/btn.png')]
	public class AccessoryButton extends Button
	{
		public function AccessoryButton()
		{
			super();
			this.setStyle('focusThickness',5);
		}
	}
}