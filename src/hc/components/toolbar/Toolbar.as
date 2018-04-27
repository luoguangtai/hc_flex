package hc.components.toolbar
{
	import spark.components.BorderContainer;
	import spark.components.HGroup;
	
	public class Toolbar extends BorderContainer
	{
		private var _horizontalAlign:String = 'left';
		public function Toolbar()
		{
			super();
		}
		
		[Inspectable(category="General", enumeration="center,left,right" , defaultValue="left")]
		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(this.contentGroup is HGroup){
				(this.contentGroup as HGroup).horizontalAlign = _horizontalAlign;
				(this.contentGroup as HGroup).verticalAlign = 'middle';
			}
			
		}
	}
}