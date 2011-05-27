package rpg
{
	import com.adobe.utils.NumberFormatter;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.VBox;
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.PBUtil;
	
	import flash.display.DisplayObjectContainer;
	
	public class UserDataPanel extends Panel
	{
		private var userDescriptionLabel:Label;
		
		private var winStatsLabel:Label;
		
		private var coinsLabel:Label;
		
		private var vBox:VBox;
		
		private var weaponImage:ItemViewer;
		
		private var armorImage:ItemViewer;
		
		public function UserDataPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			
			width = 320;
			height = 280;
			
			vBox = new VBox(this, 20, 20);
			vBox.spacing = 15;
			
			userDescriptionLabel = new Label(vBox, 0, 0, PlayerData.instance.player.username + " is a true warrior from the depths of the Ocean.");
			winStatsLabel = new Label(vBox, 0, 0, "Battle Stats: " + PlayerData.instance.player.wins + "W " + PlayerData.instance.player.loses + "L");
			coinsLabel = new Label(vBox, 0, 0, "Coins: " + PlayerData.instance.player.coins);
			
			weaponImage = new ItemViewer();
			weaponImage.x = 20;
			weaponImage.y = 200;
			addChild(weaponImage);

			armorImage = new ItemViewer();
			armorImage.x = 100;
			armorImage.y = 200;
			addChild(armorImage);
		}
		
		public function updateBattleStats(val:String):void{
			
		}
		
		public function updateCoins():void{
			coinsLabel.text = "Coins: " + PlayerData.instance.player.coins;
		}
		
		public function updateUserDescription(val:String):void{
			
		}
		
		public function updateArmorImage(itemId:String):void{
			armorImage.setURL(itemId+".png");
		}
		
		public function updateWeaponImage(itemId:String):void{
			weaponImage.setURL(itemId+".png");
		}
	}
}