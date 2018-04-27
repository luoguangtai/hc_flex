package hc.util
{
	import spark.formatters.DateTimeFormatter;

	public class DateUtil
	{
		private static var df:DateTimeFormatter = new DateTimeFormatter();
		public static var dfStr1:String = "yyyyMMdd";
		public static var dfStr2:String = "yyyyMMdd HH:mm:ss";
		public static var dfStr3:String = "yyyy-MM-dd";
		public static var dfStr4:String = "yyyy年MM月dd日";
		public static var dfStr5:String = "yyyy-MM-dd HH:mm:ss";
		public static var dfStr6:String = "HH:mm:ss";
		
		/**
		 * 字符串转日期
		 * 格式1 2009-01-01 12:22:23
		 * 或格式2 2009-01-01
		 * 或格式3 20090101 12:22:23
		 * 或格式4 20090101
		 * */
		public static function parse(dateString:String):Date{
			if ( dateString == null ) {   
				return null;   
			}   
			
			dateString = dateString.split("-").join("");
			var year:int = int(dateString.substr(0,4));   
			var month:int = int(dateString.substr(4,2))-1;   
			var day:int = int(dateString.substr(6,2));   
			
			if ( year == 0 && month == 0 && day == 0 ) {   
				return null;   
			}   
			
			if ( dateString.length == 8 ) {   
				return new Date(year, month, day);   
			}   
			
			var hour:int = int(dateString.substr(9,2));   
			var minute:int = int(dateString.substr(12,2));   
			var second:int = int(dateString.substr(15,2));   
			
			return new Date(year, month, day, hour, minute, second);   
		}
		
		/**
		 * Date转String
		 * */
		public static function formatDate(v:Date,dfStr:String):String{
			df.dateTimePattern = dfStr;
			return df.format(v);
		}
		
		/**
		 *取传入日期的前几天或是后几天的日期	
		 * @param curDate  传入日期
		 * @param dayNumber 与传入日期相差的天数.格式:当前日期前传付整数，如：-2 ；当前日期之后传正整数，如：2 .
		 * @return Date,传入日期的前几天或是后几天的日期.
		 */
		public static function getDateByDifferDayNum(curDate:Date, dayNumber:int):Date{
			if(Util.isBlank(curDate)){
				return  curDate;
			}else{ 
				return  new Date(curDate.getTime()+(dayNumber *( 24 * 60 * 60 * 1000))) ;
			}
		}
		
		/**
		 * 计算两个日期之间相差的天数
		 * @param date1 date1
		 * @param date2 date2
		 * @return int 相差的天数
		 */
		public static function daysBetween(date1:Date, date2:Date):int{
			if(Util.isBlank(date1) || Util.isBlank(date2)){
				return 0;
			}
			return int((date2.getTime() - date1.getTime())/(1000*24*60*60));
		}
		
		/**
		 * 获取当天
		 * */
		public static function now():Date
		{
			return new Date();
		}
		
		/**
		 * 返回当月第一天
		 * */
		public static function firstDayOfMonth():Date
		{
			var d:Date = new Date();
			d.setDate(1);
			return d;
		}
	}
}