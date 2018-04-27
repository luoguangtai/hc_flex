package hc.events
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		private var _obj:Object;
		public function CustomEvent(type:String, obj:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_obj = obj;
		}
		
		public function getObject():Object{
			return _obj;
		}
		
	}
}