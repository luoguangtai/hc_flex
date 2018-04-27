package hc.components.datagrid
{
	import flash.events.Event;

	public class PageChangedEvent extends Event
	{
		private var _pageIndex:int = 0;
		private var _pageSize:int = 0;
		
		private static const PAGE_CHANGED:String = "pageChanged";
        
		public function PageChangedEvent(type:String, pageindex:int, pagesize:int)
        {
            super(type);
            this._pageIndex = pageindex;
			this._pageSize = pagesize;
        }
		
		public function get pageSize():int
		{
			return _pageSize;
		}

		public function get pageIndex():int
		{
			return _pageIndex;
		}


	}
}