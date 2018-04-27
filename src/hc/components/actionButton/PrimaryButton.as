package hc.components.actionButton
{
	import hc.components.Button;
	
	/**
	 * 操作按钮，通常用在保存、确定、打印等按钮上
	 */
	[IconFile('/assets/icon/btn_primary.png')]
	public class PrimaryButton extends Button
	{
		public function PrimaryButton()
		{
			super();
			this.setStyle('focusThickness',5);
		}
	}
}