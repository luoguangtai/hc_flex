package hc.components
{
	import hc.util.HttpUtil;
	import hc.util.Util;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	
	
	public class Tree extends mx.controls.Tree
	{
		//取数据的url
		private var _url:String = null;
		private var _expandLevel:int=1;
		
		public function Tree()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{loadData()});
		}
		/**
		 *远程服务端url 
		 */
		public function set url(value:String):void
		{
			_url = value;
			//加载数据
			if(this.initialized){
				loadData();
			}
		}
		//加载数据
		private function loadData():void{
			if(Util.isNotBlank(_url)){
				HttpUtil.doPost(_url, null, function(obj:Object):void{
					dataProvider = obj;
				},null,false);
			}
		}
		
	}
}