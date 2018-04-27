package hc.components
{
	import hc.Const;
	
	import spark.components.Image;
	
	public class ImageButton extends Image
	{
		public function ImageButton()
		{
			super();
			this.buttonMode = true;
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled = value;
			this.filters = value?Const.ENABLED_FILTERS:Const.DISABLED_FILTERS;
		}
			
	}
}