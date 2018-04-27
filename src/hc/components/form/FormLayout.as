package hc.components.form
{
	
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.layouts.supportClasses.LayoutElementHelper;
	
	public class FormLayout extends LayoutBase
	{
		public function FormLayout()
		{
			super();
		}
	
		private var _columnCount:int = 3;//布局显示的列数		
		private var _vGap:Number = 0;//上下两个数据项之间的间隙
		private var _hGap:Number = 0;//左右两个数据项之间的间隙
		private var _paddingLeft:Number = 0;
		private var _paddingRight:Number = 10;
		private var _paddingTop:Number = 10;
		private var _paddingBottom:Number = 10;
		
		//——————————————————————————————
		//
		//				Properties
		//
		//——————————————————————————————
		
		//-------------------------------------
		//	columnCount
		//-------------------------------------
		
		/**
		 * 布局显示的列数 
		 * @return 
		 * 
		 */
		public function get columnCount():int
		{
			return _columnCount;
		}
		
		public function set columnCount(value:int):void
		{		
			if (_columnCount == value) 
				return;
			
			_columnCount = value;
			invalidateTargetSizeAndDisplayList();
		}		
		
		//-------------------------------------
		//	hGap
		//-------------------------------------
		
		/**
		 * Form上的FormItem列之间的水平间距 
		 * @return 
		 * 
		 */
		public function get hGap():Number{
			return _hGap;
		}

		public function set hGap(value:Number):void{
			if (_hGap == value) 
				return;
			
			_hGap = value;
			invalidateTargetSizeAndDisplayList();
		}

		//-------------------------------------
		//	vGap
		//-------------------------------------
		
		/**
		 * Form上的FormItem行之间的竖直间距
		 * @return 
		 * 
		 */
		public function get vGap():Number{
			return _vGap;
		}

		public function set vGap(value:Number):void{	
			if (_vGap == value) 
				return;
			
			_vGap = value;
			invalidateTargetSizeAndDisplayList();
		}

		//-------------------------------------
		//	paddingBottom
		//-------------------------------------
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//-------------------------------------
		//	paddingTop
		//-------------------------------------
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//-------------------------------------
		//	paddingRight
		//-------------------------------------
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//-------------------------------------
		//	paddingLeft
		//-------------------------------------
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//——————————————————————————————
		//
		//				Methods
		//
		//——————————————————————————————
		
		override public function updateDisplayList(width:Number, height:Number)
			: void
		{
			super.updateDisplayList( width, height );
			//计算列宽
			var clientWidth:Number = width - paddingLeft  - paddingRight;
			var colWidth:Number = Math.floor( (clientWidth - (columnCount -1)* hGap) / columnCount );
			
			//需要计算每一行的最大行高
			var layoutTarget:GroupBase = target;
			//数据项坐标变量
			var xpos:Number=paddingLeft;
			var ypos:Number=paddingTop;
			//数据项占满最大的空间（宽和高）
			//var fullWidth:Number = Math.floor((width-(cols+1)*hgap) / cols);
			
			//数据项
			var element:ILayoutElement;
			var lineNum:Number = 0;
			var colNum:Number = 0;
			var layoutElementWidth:Number;
			var layoutElementHeight:Number;
			var colspan:Number;
			var rowHeight:Number = 0;
			
			//遍历每个数据项，并指定数据项显示坐标和宽高			
			for( var i:int = 0; i < layoutTarget.numElements; i++ )
			{
				element = layoutTarget.getElementAt( i );
				if(element is FormItem){
					var formItem:FormItem = element as FormItem;
					if (! formItem.visible)
					{
						continue;	
					}					
					colspan = formItem.colSpan;
					if(colspan >  columnCount) colspan = columnCount;					
				}else{
					colspan = 1;
				}
				
				
//				layoutElementWidth = 0;
//				layoutElementHeight = 0;
//				//计算数据项显示的宽高
//				if (!isNaN(element.percentWidth))
//					layoutElementWidth = calculatePercentWidth(element, colWidth);
//				else
//					layoutElementWidth = element.getPreferredBoundsWidth();
				layoutElementHeight = element.getPreferredBoundsHeight();
				//计算数据项显示坐标
				/*xpos = colNum * gab + (colNum-1)*layoutElementWidth;
				ypos = lineNum * gab + (lineNum-1)*layoutElementHeight;*/
				layoutElementWidth = colspan * colWidth + (colspan-1)* hGap;
				
				//换行
				if(xpos + layoutElementWidth > width){
					xpos = paddingLeft;
					ypos += vGap + rowHeight;
					rowHeight = 0;
				}
				rowHeight = Math.max(rowHeight,layoutElementHeight);
				//指定数据项显示坐标和宽高
				element.setLayoutBoundsSize( NaN, NaN );
				element.setLayoutBoundsPosition( xpos, ypos );
				element.setLayoutBoundsSize(layoutElementWidth,layoutElementHeight);
				colNum++;
				//改变X坐标
				xpos += hGap + layoutElementWidth;
			}
		}
		
		override public function measure():void
		{
			var layoutTarget:GroupBase = target;
			if (!layoutTarget) return;
			
			var maxWidth:Number = 0;
			var elementWidth:Number = 0;
			var measuredHeight:Number = vGap;
			var lineMaxHeight:Number = 0;
			var element:ILayoutElement;
			var numElements:int = layoutTarget.numElements;
			var colNum:int = 0;
			
			for(var i:int=0;i<numElements;i++){
				element = layoutTarget.getElementAt(i);
				elementWidth = element.getPreferredBoundsWidth() + hGap;
				maxWidth = Math.max(elementWidth,maxWidth);
				if(element is FormItem){
					if (! (element as FormItem).visible)
					{
						continue;	
					}
					if(colNum + (element as FormItem).colSpan > columnCount){
						//换行
						measuredHeight += lineMaxHeight + vGap;
						lineMaxHeight = element.getPreferredBoundsHeight();
						colNum = (element as FormItem).colSpan;
					}else{
						//同行
						lineMaxHeight = Math.max(lineMaxHeight,element.getPreferredBoundsHeight());
						colNum += (element as FormItem).colSpan;
					}
				}else{
					if(colNum + 1 > columnCount){
						//换行
						measuredHeight += lineMaxHeight + vGap;
						lineMaxHeight = element.getPreferredBoundsHeight();
						colNum = 1;
					}else{
						//同行
						lineMaxHeight = Math.max(lineMaxHeight,element.getPreferredBoundsHeight());
						colNum += 1;
					}
				}
			}
			measuredHeight += lineMaxHeight + vGap;
			
			layoutTarget.measuredWidth = columnCount * maxWidth + hGap;    
			layoutTarget.measuredHeight = measuredHeight;  
		}
		
		private static function calculatePercentWidth(layoutElement:ILayoutElement, width:Number):Number
		{
			var percentWidth:Number = LayoutElementHelper.pinBetween(Math.round(layoutElement.percentWidth * 0.01 * width),
				layoutElement.getMinBoundsWidth(),
				layoutElement.getMaxBoundsWidth() );
			return percentWidth < width ? percentWidth : width;
		}
		
		private static function calculatePercentHeight(layoutElement:ILayoutElement, height:Number):Number
		{
			var percentHeight:Number = LayoutElementHelper.pinBetween(Math.round(layoutElement.percentHeight * 0.01 * height),
				layoutElement.getMinBoundsHeight(),
				layoutElement.getMaxBoundsHeight() );
			return percentHeight < height ? percentHeight : height;
		}
		
		
		private function invalidateTargetSizeAndDisplayList():void
		{
			var g:GroupBase = target;
			if (!g)
				return;
			
			g.invalidateSize();
			g.invalidateDisplayList();
		}
	}
}