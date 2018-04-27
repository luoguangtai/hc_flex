package hc.util
{
	/**
	 * 正则表达式验证类 
	 * @author Ouxd
	 * @builded 2011-12-30
	 */
	public class RegExpUtil
	{
		/*
		*身份证校验方法(支持18位)
		*17位数字和1位校验码：6位地址码数字(前6位)，8位生日数字(第7位到14位)，3位出生时间顺序码(15位到17位)，1位校验码(第18位数)
		*17位数字本体码加权求和公式 S = Sum(Ai * Wi), i = 0, , 16 ，先对前17位数字的权求和；
		*Ai:表示第i位置上的身份证号码数字值 Wi:表示第i位置上的加权因子 Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2；
		*计算模 Y = mod(S, 11);
		*通过模得到对应的校验码 Y: 0 1 2 3 4 5 6 7 8 9 10 校验码: 1 0 X 9 8 7 6 5 4 3 2
		*/
		private static function isIdCard(ss:String):Boolean{
			var paritybit:Array = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];
			var power_list:Array = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
			var s:String = ss.toUpperCase().toString();
			var power:Number = 0;
			for(var i:int=0;i<s.length;i++){
				if(i==s.length-1 && s.charAt(i)=="X"){ 
					break; 
				}
				if(s.charAt(i)<'0' || s.charAt(i)>'9'){
					return false;
				}
				if(i<s.length-1){
					power += Number(s.charAt(i)) * power_list[i]; 
				}
			}
			var date:Date = new Date();
			var year:Number = Number(s.substring(6,10));
			if(year<1900 || year>date.getFullYear()){
				return false;
			}
			var month:Number = Number(s.substring(10,12));
			if(month<1 || month>12){
				return false;    
			}
			var day:Number = Number(s.substring(12,14));
			if(day<1 || day>31){ 
				return false; 
			}
			return s.charAt(s.length - 1) == paritybit[power % 11];
		}
		
		/**
		 * 计算字符串的所占字节数 
		 * @param inputText 输入字符串,汉字作为两个字节
		 * @return 字节数
		 * 
		 */
		public static function getStringBytes(inputText:String):int
		{			
			var intByteLen:int = 0;
			var chrAti:String;
			for (var i:int=0; i<inputText.length; i++)
			{
				chrAti = inputText.charAt(i);
				if (escape(chrAti).length == (chrAti.length)*6)
					intByteLen += 2;
				else
					intByteLen += 1;
			}
			return intByteLen;			
		}
		
		/**
		 * 验证输入字符串是否匹配正则表达式 
		 * @param inputText 输入字符串
		 * @param regExp 正则表达式匹配模式
		 * @return 若匹配则返回true,否则返回false
		 * 
		 */
		public static function executeRegExpValidator(inputText:String,regExp:Object):Boolean{
			var bResult:Boolean = true;
			if (regExp == null){
				return bResult;
			}
			
			var regPattern:RegExp = new RegExp(regExp);
			
			bResult = regPattern.test(inputText);			
			return bResult;	
		}
		
				
		/**
		 * 验证输入字符串的字节数是否小于最大字节数 
		 * @param inputText 输入字符串
		 * @param maxBytes 最大字节数,小于等于0时则不做字节数限制
		 * @return 小于等于最大字节数返回true，否则返回false
		 * 
		 */
		public static function executeMaxByteValidator(inputText:String,maxBytes:int):Boolean
		{		
			var bResult:Boolean =true;
			if(maxBytes <=0) return bResult;
			var lenBytes:int = getStringBytes(inputText);			
			bResult = (maxBytes >= lenBytes)
			
			return bResult
		}		
		
		/**
		 * 验证输入字符串是否为数字
		 * @param inputText 输入字符串
		 * @return 若为数字则返回true，否则返回false
		 * 
		 */
		public static function executeNumberValidator(inputText:String):Boolean
		{			
			var bResult:Boolean = true;
			var regPattern:RegExp =/^((-\d+(\d+\.?\d*)?)|(\d+\.?\d*)|())$/;
			bResult= regPattern.test(inputText);
		
			return bResult;				
		}
		
		/**
		 * 验证输入字符串是否为带两位小数位的浮点数 
		 * @param inputText 输入字符串
		 * @return 
		 * 
		 */
		public static function executeFloatTwoDecimalValidator(inputText:String):Boolean{
			var bResult:Boolean = true;
			//var regPattern:RegExp =/^((-\d+\.?\d{2})|(\d+\.?\d{1})|\d+|())$/;					2012 06.20  del wufl
			var regPattern:RegExp = /^((-?\d+)|(-?\d+\.\d{1,2}))$/;						  //2012 06.20  add wufl
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为带一位小数位的浮点数 
		 * @param inputText 输入字符串
		 * @return 
		 * 
		 */
		public static function executeFloatOneDecimalValidator(inputText:String):Boolean{
			var bResult:Boolean = true;
			var regPattern:RegExp = /^((-?\d+)|(-?\d+\.\d{1}))$/;		
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为带两位小数位的正浮点数字 
		 * @param inputText 输入字符串
		 * @return 若为两位小数的正数则返回true，否则返回false
		 * 
		 */
		public static function executeTwoDecimalValidator(inputText:String):Boolean{
			var bResult:Boolean = true;
//			var regPattern:RegExp =/^((\d+\.?\d{2})|(\d+\.?\d{1})|\d+|())$/;					
			var regPattern:RegExp =/^(?:0|[1-9]\d*)(\.\d{1,2})?$/;	//新修改				
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为带一位小数位的正浮点数字 
		 * @param inputText 输入字符串
		 * @return 若为两位小数的正数则返回true，否则返回false
		 * 
		 */
		public static function executeOneDecimalValidator(inputText:String):Boolean{
			var bResult:Boolean = true;
			var regPattern:RegExp =/^(?:0|[1-9]\d*)(\.\d{1})?$/;	
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为正整数 
		 * @param inputText 输入字符串
		 * @return 若为正整数则返回true，否则返回false
		 * 
		 */
		public static function executePositiveIntValidator(inputText:String):Boolean
		{
			var bResult:Boolean = true;
			var regPattern:RegExp =/^((\d+)|(0))$/;
			bResult= regPattern.test(inputText);
			
			return bResult;		
		}
		
		/**
		 * 验证输入字符串是否为正数（正浮点数） 
		 * @param inputText
		 * @return 
		 * 
		 */
		public static function executePositiveFloatValidator(inputText:String):Boolean
		{			
			var bResult:Boolean = true;
			//var regPattern:RegExp =/^((\d+\.?\d*)|())$/;
			var regPattern:RegExp =/^\d+(\.\d+)?$/;			
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为千分位计数
		 * @param inputText
		 * @return 
		 * 
		 */
		public static function executeThousandPointValidator(inputText:String):Boolean
		{			
			var bResult:Boolean = true;
			var regPattern:RegExp =/^(\d{1,3}(,\d\d\d)*(\.\d+)?|\d+(\.\d+)?)$/;			
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		
		/**
		 * 验证输入字符串是否为日期格式
		 * 正确的日期格式，如：2011-12-30 
		 * @param inputText 输入字符串
		 * @return 若为日期格式则返回true，否则返回false
		 * 
		 */
		public static function executeDateValidator(inputText:String):Boolean
		{
			var bResult:Boolean = true;
			var regPattern:RegExp =/^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;
			bResult= regPattern.test(inputText);
			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为身份证号
		 * 身份证号为15位或18位,尾数可为x,格式为：350225781222623或35022519781222623X"
		 * @param inputText 输入字符串
		 * @return 若为有效身份证号则返回true，否则返回false
		 * 
		 */
		public static function executeIdcardValidator(inputText:String):Boolean
		{
			var bResult:Boolean = true;
//			var regPattern:RegExp =/^((QT-\S+)|(\d{15})|((\d{17})(X|x|\d{1}))|())$/;
//			var regPattern:RegExp = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
//			bResult= regPattern.test(inputText);	
			
			bResult = isIdCard(inputText);
			return bResult;	
		}		
		
		/**
		 * 验证输入字符串是否为9位的法人代码
		 * @param inputText 输入字符串
		 * @return 若为法人代码则返回true，否则返回false
		 * 
		 */
		public static function executeLegalPersonCodeValidator(inputText:String ):Boolean{
			var bResult:Boolean = true;
			var regPattern:RegExp =/^([a-zA-Z0-9]{9}|())$/;
			bResult= regPattern.test(inputText);			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为银行账号（16-19位) 
		 * @param inputText
		 * @return 
		 * 
		 */
		public static function executeBankAccoutValidator(inputText:String):Boolean{
			var bResult:Boolean = true;
			var regPattern:RegExp =/^\d{16,19}$/;
			bResult= regPattern.test(inputText);			
			return bResult;				
		}
		
		/**
		 * 验证输入字符串是否为电话号码
		 * 格式为 0592-8888888,8888889
		 * @param inputText 输入字符串
		 * @return 若为电话号码则返回true，否则返回false
		 * 
		 */
		public static function executePhoneValidator(inputText:String):Boolean
		{			
			var bResult:Boolean = true;
			var regPattern:RegExp =/^(((\d+\-?\d*)+\,?)*|())$/;
			bResult= regPattern.test(inputText);			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为电话号码
		 * 格式为 +86 13588888888 或 13588888888
		 * @param inputText 输入字符串
		 * @return 若为11位的电话号码则返回true，否则返回false
		 * 
		 */
		public static function executeMobileTelValidator(inputText:String):Boolean
		{
			var bResult:Boolean = true;			
			var regPattern:RegExp =/^0{0,1}(14[0-9]|13[0-9]|15[0-9]|18[0-9])[0-9]{8}$/;
			bResult= regPattern.test(inputText);			
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否为六位数的邮政编码
		 * @param inputText 输入字符串
		 * @return 若为邮政编码则返回true，否则返回false
		 * 
		 */
		public static function executeZIPValidator(inputText:String):Boolean
		{		
			var bResult:Boolean = true;
			var regPattern:RegExp =/^(\d{6}|())$/;
			bResult= regPattern.test(inputText);		
			return bResult;	
		}
		
		/**
		 * 验证输入字符串是否是电子邮箱格式 
		 * 正确的电子邮箱格式为：abc@163.com
		 * @param inputText 输入字符串
		 * @return 若是电子邮箱则返回true，否则返回false
		 * 
		 */
		public static function executeEmailValidator(inputText:String):Boolean
		{		
			var bResult:Boolean = true;
			var regPattern:RegExp =/^(()|[a-zA-Z0-9\.\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\}\~]+\@[a-zA-Z0-9\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\}\~]+(\.[a-zA-Z0-9]+)+)$/;
			bResult= regPattern.test(inputText);			
			return bResult;	
		}
		
	}
}