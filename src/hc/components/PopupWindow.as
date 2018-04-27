package hc.components
{
	import flash.events.Event;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	[Event(name="onClose", type="flash.events.Event")]
	[Event(name="onOpen", type="flash.events.Event")]
	
	/**
	 * 弹出窗口，主要用在新增、编辑的时候提交创建好窗口，用的时候直接显示
	 */ 
	public class PopupWindow extends SkinnableContainer
	{
		[SkinPart(required="true")]
		public var titleLabel:Label;
		
		[SkinPart(required="true")]
		public var winGroup:Group;
		
		[SkinPart(required="true")]
		public var closeGroup:Group;
		
		//窗口宽度、高度
		private var _contentWidth:Number = 600;
		private var _contentHeight:Number = 500;
		//标题
		private var _title:String = '';
		
		public function PopupWindow()
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.visible = false;
		}
		
		public function set contentWidth(v:Number):void{
			_contentWidth = v;
			if(winGroup){
				winGroup.width = _contentWidth+10;
			}
		}
		
		public function get contentWidth():Number{
			return _contentWidth;
		}
		
		public function set contentHeight(v:Number):void{
			_contentHeight = v;
			if(winGroup){
				winGroup.height = _contentHeight + 32 + 5;
			}
		}
		
		public function get contentHeight():Number{
			return _contentHeight;
		}
		
		public function set title(v:String):void{
			_title = v;
			if(titleLabel){
				titleLabel.text = v;
			}
		}
		
		public function get title():String{
			return _title;
		}
		
		/**
		 * 打开窗口
		 */ 
		public function show():void{
			this.visible = true;
			this.dispatchEvent(new Event('onOpen'));
		}
		
		/**
		 * 关闭窗口
		 */ 
		public function close():void{
			this.visible = false;
			this.dispatchEvent(new Event('onClose'));
		}
	}
}