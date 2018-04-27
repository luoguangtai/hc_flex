/**
 * 带验证的TextInput
 *
 */
package hc.components.form
{
	import hc.util.AlertUtil;
	import hc.util.RegExpUtil;
	import hc.util.Util;
	
	import flash.events.KeyboardEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.TextInput;
	
	[SkinState("editdisabled")]
	
	[IconFile("/assets/icon/icon_textInput.png")]
	public class TextInput extends spark.components.TextInput implements IFormItemComponent
	{				
		private var _dataType:String = 'string';//数据类型	
		
		public var regExp:Object;	//自定义正则表达式
		public var validateFunction:Function=null;//自定义的验证方法
		public var required:Boolean = false;//是否必填,如果为true则表示必填，不能为空
		
		public var minLength:Number;//字符串最小长度
		public var maxLength:Number;//字符串最大长度
		
		public var minValue:Number;//数值范围-最小值
		public var maxValue:Number;//数值范围-最大值
		
		public var nextComponent:Boolean = true;//是否启用回车转到下一组件
		
		public function TextInput(){
			super();
			this.addEventListener(FlexEvent.VALUE_COMMIT,valueCommitValid);		
			this.addEventListener(FlexEvent.CREATION_COMPLETE, function(event:FlexEvent):void{
				text = Util.isNotBlank(text)?text:_defaultValue;
			});
			//通过键盘(Tab键)把焦点移除时,如果验证不通过则不移动光标
//			this.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,textInput_keyFocusChange);
//			this.addEventListener(TextOperationEvent.CHANGE, pasteHandler);
		}
		
		override protected function getCurrentSkinState():String {
			if(this.editable==false){
				return 'editdisabled';
			}
			else{
				return super.getCurrentSkinState();
			}
		}
		
		/**
		 * 数据变更提交时验证,验证通过则置空errorString
		 */
		private function valueCommitValid(event:mx.events.FlexEvent):void
		{
			validate();
		}
//		
//		private function textInput_keyFocusChange(event: FocusEvent):void{
//			if(!validate()){
//				event.preventDefault();	
//			}
//		}
		
		/**
		 * 按回车建的时候，如果验证通过则转向下一个组件
		 */ 
		override protected function keyDownHandler(event:KeyboardEvent):void{
			super.keyDownHandler(event);
			if(nextComponent)
				Util.nextComponent(event, this.focusManager);
		}
		
		/**
		 * 粘帖操作后的数据验证
		 */ 
//		private function pasteHandler(event:TextOperationEvent):void{
//			if(event.operation is PasteOperation && Util.isNotBlank(this.restrict)){
//				if(!RegExpUtil.executeRegExpValidator(this.text,this.restrict)){
//					this.text = "";
//				}
//			}
//		}
		
		//[Inspectable(category="General", enumeration="文本,数字,正整数,正浮点数,1位小数,2位小数,日期,身份证,电话号码,邮政编码,电子邮箱,法人代码,银行账号,中文" , defaultValue="文本")]
		[Inspectable(category="General", enumeration="string,number,+int,+float,float1,+float1,float2,+float2,date,idCard,tel,mobileTel,postCode,email,entCode,bankAccount,customize,chinese" , defaultValue="string")]
		public function set dataType(value:String):void
		{
			_dataType=value;
		    setRestrict();
		}
		
		/**
		 * 设置Restrict，过滤键盘按键，限制错误输入
		 */
		private function setRestrict():void
		{
			this.restrict = null;
			switch(this._dataType)
			{				
				case "number":
					this.restrict="0-9\+\-\.";				
					break;
				case "+int":
					this.restrict="0-9";
					break;
				case "float2":
					this.restrict="0-9\+\-\.";
					break;
				case "+float":
					this.restrict="0-9\.";
					break;
				case "+float2":
					this.restrict="0-9\.";
					break;
				case "float1":
					this.restrict="0-9\+\-\.";
					break;
				case "+float1":
					this.restrict="0-9\.";
					break;
				case "date":
					this.restrict="0-9\\-/";
					break;
				case "idCard":
					this.restrict="0-9\X\x";
					break;
				case "tel":
					this.restrict="0-9\\-\,";
					break;	
				case "postCode":
					this.restrict="0-9";
					break;
				case "email":
					this.restrict="0-9\A-Z\a-z\@\.";
					break;
				case "entCode":
					this.restrict="0-9\A-Z\a-z";
					break;
				case "bankAccount":
					this.restrict="0-9";
					break;	
				case "mobileTel":
					this.restrict="0-9";
					break;
				case "chinese":
					this.restrict="[\u4e00-\u9fa5]";
					break;
				default:
					this.restrict = null;
					break;
			}		
		}
		
		//--------------------------------------------------
		//   	 reset 重置
		//--------------------------------------------------
		public function reset():void{
			this.text = _defaultValue;
			this.errorString = "";
		}	

		public function validate():Boolean
		{
			var bResult:Boolean = false;
			
			//不是必填项
			if(!this.required && Util.isBlank(this.text)){
				bResult = true;
				this.errorString = '';
				return bResult;
			}
			
			//先判断是否必填，如果是必填项，则不能为空
			if(this.required && Util.isBlank(this.text)){
				bResult = false;
				this.errorString= "必填项";
				return bResult;	
			}
			
			//如果设置了验证方法，则使用验证方法
			if(validateFunction != null){
				bResult = validateFunction(this) as Boolean;
				return bResult;
			}
			
			var tempNum:Number;
			switch(this._dataType)
			{
				case "string":
					bResult = true;
					var len:int = RegExpUtil.getStringBytes(this.text);
					//如果设置了最小长度，则进行不对，不能小于最小长度
					if(!isNaN(this.minLength) && len<this.minLength){
						bResult = false;
						this.errorString= "字符长度少于 "+ minLength;
					}
					//如果设置了最大长度，则不能超过最大长度
					if(!isNaN(this.maxLength) && len>this.maxLength){
						bResult = false;
						this.errorString= "字符长度超过 "+ maxLength;
					}
					break;
				case "number":
					bResult= RegExpUtil.executeNumberValidator(this.text);	
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入有效数字";
					}
					break;
				case "+int":
					bResult = RegExpUtil.executePositiveIntValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入正整数";
					}
					break;					
				case "+float":
					bResult = RegExpUtil.executeThousandPointValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入正数";
					}
					break;
				case "+float2":
					bResult = RegExpUtil.executeTwoDecimalValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入2位小数";
					}
					break;
				case "float2":
					bResult = RegExpUtil.executeFloatTwoDecimalValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入2位小数";
					}
					break;
				case "float1":
					bResult = RegExpUtil.executeFloatOneDecimalValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入1位小数";
					}
					break;
				case "+float1":
					bResult = RegExpUtil.executeOneDecimalValidator(this.text);
					if(bResult){
						if(Util.isNotBlank(this.text)){
							tempNum = Number(this.text);
							if(!isNaN(this.minValue) && tempNum<this.minValue){
								bResult = false;
								this.errorString= "不能小于 "+ minValue;
							}
							if(!isNaN(this.maxValue) && tempNum>this.maxValue){
								bResult = false;
								this.errorString= "不能大于 "+ maxValue;
							}
						}
					}
					else{
						this.errorString="请输入1位小数";
					}
					break;
				case "date":
					bResult = RegExpUtil.executeDateValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入日期,格式如：2012-01-01";
					}
					break;
				case "idCard":
					this.text = this.text.toUpperCase();//转换成大写
					bResult = RegExpUtil.executeIdcardValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入正确的身份证号码";
					}
					break;
				case "tel":
					bResult = RegExpUtil.executePhoneValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入电话号码";
					}
					break;	
				case "mobileTel":
					bResult = RegExpUtil.executeMobileTelValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入正确的手机号码";
					}
					break;
				case "postCode":
					bResult = RegExpUtil.executeZIPValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入邮政编码";
					}
					break;
				case "email":
					bResult = RegExpUtil.executeEmailValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入电子邮箱地址";
					}
					break;
				case "entCode":
					bResult = RegExpUtil.executeLegalPersonCodeValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入9位法人代码";
					}
					break;
				case "bankAccount":	
					bResult = RegExpUtil.executeBankAccoutValidator(this.text);
					if(bResult == false)
					{
						this.errorString="请输入16或19位数字";
					}
					break;
				case "customize":
					bResult = RegExpUtil.executeRegExpValidator(this.text,regExp);
					if(bResult == false)
					{
						this.errorString="数据格式错误，请输入有效信息";
					}
				case "chinese":
					bResult = RegExpUtil.executeRegExpValidator(this.text,regExp);
					if(bResult == false)
					{
						this.errorString="请输入中文";
					}
			}			
			//如果全部验证通过，则清空errorString
			if(bResult)
			{
				this.errorString="";
			}
			return bResult;
		}
		
		/**
		 * 设置值,传入一个表单值
		 */ 
		public function set dataValue(v:String):void{
			this.text = '';
			if(Util.isNotBlank(v)){
				this.text = String(v);
			}
		}
		/**
		 * 取控件的值
		 */ 
		public function get dataValue():String{
			return this.text;
		}
		
		private var _fieldName:String = '';//字段名，用来与java的属性名对应
		public function set fieldName(v:String):void{
			this._fieldName = v;
		}
		
		public function get fieldName():String{
			return this._fieldName;
		}
		
		/**
		 * 默认值
		 */ 
		private var _defaultValue:String = '';
		public function get defaultValue():String{
			return _defaultValue;
		}
		public function set defaultValue(obj:String):void{
			_defaultValue = obj;
		}
	}

}