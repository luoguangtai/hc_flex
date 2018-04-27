package hc.components
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	
	[IconFile('/assets/icon/btn.png')]
	public class Button extends spark.components.Button
	{
		public function Button()
		{
			super();
			this.label = '按钮';
			this.buttonMode = true;
			this.addEventListener(KeyboardEvent.KEY_DOWN, keydown);
		}
		
		private function keydown(event:KeyboardEvent):void{
			if(event.keyCode==13){
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
	}
}