package hc.util
{
	import spark.formatters.NumberFormatter;
	
	public class NumberUtil
	{
		public static var FOUR:int = 4;		
		private static var numFormatter:NumberFormatter = new NumberFormatter();
		
		/**
		 * 是否是数值字符串;  
		 */
		public static function isNumber(char:String):Boolean{  
			if(char == null){  
				return false;  
			}  
			return !(isNaN(Number(char)))  
		}  
		
		/**
		 * 取整，四舍五入
		 */
		public static function round(v:Number):Number{
			return Math.round(v);
		}
		
		/**
		 * 保留指定位小数
		 */
		public static function toFixed(v:Number, digits:int=2):String{
			return v.toFixed(digits);
		}
		
		/**
		 * 数字格式化成字符串，指定小数位数
		 */
		public static function format(v:Number, digits:int=2):String{
			numFormatter.fractionalDigits = digits;
			return numFormatter.format(v);
		}
		
		public static function parse(v:String):Number{
			return 	Number(v);
		}
		
		/**
		 * 计算百分比
		 */ 
		public static function percent(v:Number, sum:Number, digits:int=0):String{
			if(sum==0){
				return '';
			}
			return toFixed(v*100/sum,0);
		}
		
		//格式化千分位
		public static function formatThousandth(v:Number, digits:int=2):String {
			if(isNaN(v)) return null;
			numFormatter.groupingPattern = '3;*';
			numFormatter.fractionalDigits = digits;
			numFormatter.useGrouping = true;
			numFormatter.groupingPattern = ',';
			return numFormatter.format(v);
		}
	}
}