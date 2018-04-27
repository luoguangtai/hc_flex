package hc.layouts
{
	import mx.containers.utilityClasses.ConstraintColumn;
	import mx.containers.utilityClasses.ConstraintRow;
	
	import spark.layouts.ConstraintLayout;
	
	public class CellLayout extends ConstraintLayout
	{
		private var _rows:Array = ['33%','33%','33%'];
		private var _cols:Array = ['33%','33%','33%'];
		
		public function CellLayout()
		{
			super();
		}
		
		private function lay():void{
			if(_rows){
				var row1:Vector.<ConstraintRow> = new Vector.<ConstraintRow>();
				var row:ConstraintRow;
				for(var i:int = 0; i<_rows.length; i++){
					row = new ConstraintRow();
					row.id = 'row' + (i + 1);
					if(_rows[i] is Number){
						row.height = _rows[i] as Number;
					}
					else{
						row.percentHeight = Number((_rows[i] as String).replace('%',''));
					}
					row1.push(row);
				}
				this.constraintRows = row1;
			}
			
			if(_cols){
				var col1:Vector.<ConstraintColumn> = new Vector.<ConstraintColumn>();
				var col:ConstraintColumn;
				for(var i:int = 0; i<_cols.length; i++){
					col = new ConstraintColumn();
					col.id = 'col'+ (i + 1);
					if(_cols[i] is Number){
						col.width = _cols[i] as Number;
					}
					else{
						col.percentWidth = Number((_cols[i] as String).replace('%',''));
					}
					col1.push(col);
				}
				this.constraintColumns = col1;
			}
		}
		
		/**
		 * 设置行信息
		 * rows 输入行数组，内容为行的高度，如果是数值则表示绝对高度，字符串表示百分百，例如 [50,70,'45%']
		 */
		public function set rows(rows:Array):void{
			_rows = rows;
			lay();
		}
		
		/**
		 * 设置列信息
		 * rows 输入行数组，内容为行的高度，如果是数值则表示绝对高度，字符串表示百分百，例如 [50,70,'45%']
		 */
		public function set cols(cols:Array):void{
			_cols = cols;
			lay();
		}
	}
}