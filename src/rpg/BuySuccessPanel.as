package rpg
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class BuySuccessPanel extends Panel
	{
		private var descriptionLabel:Label;
		private var notNowButton:PushButton;
		
		private var _cancelCallback:Function;
		
		public function BuySuccessPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0){
			super(parent, xpos, ypos);
			
			width = 250;
			height = 100;
			
			descriptionLabel = new Label(this, 20, 5, "Successfully purchased!");
			descriptionLabel.autoSize = true;
			descriptionLabel.textField.width = 200;
			descriptionLabel.textField.wordWrap = true;
			
			notNowButton = new PushButton(this, 120, 75, "Proceed");
			notNowButton.width = 45;
		}
		
		public function set cancelCallback(val:Function):void{
			_cancelCallback = val;
			notNowButton.addEventListener(MouseEvent.CLICK, _cancelCallback);
		}
	}
}