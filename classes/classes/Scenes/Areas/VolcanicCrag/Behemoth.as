package classes.Scenes.Areas.VolcanicCrag 
{
import classes.*;
import classes.GlobalFlags.kFLAGS;
import classes.Scenes.SceneLib;

public class Behemoth extends Monster
	{
		public function tailWhip():void {
			outputText("The behemoth charges at you with his spiked tail raised!  ");
			if (player.getEvasionRoll()) {
				outputText("You manage to dodge in time to avoid his swinging tail!");
				combatRoundOver();
				return;
			}
			else {
				outputText("You weren't aware of that and his tail hits you!  <b>Your defense has been reduced!</b>  ");
				var damage:int = str + level;
				damage = player.reduceDamage(damage);
				player.takeDamage(damage, true);
			}
			if (hasStatusEffect(StatusEffects.TailWhip)) addStatusValue(StatusEffects.TailWhip, 1, 5);
			else createStatusEffect(StatusEffects.TailWhip, 5, 0, 0, 0);
			combatRoundOver();
		}
		
		public function tease():void {
			outputText("The behemoth lifts his loincloth to reveal his large prick and waves his cock left and right.  You blush from looking at his cock.");
			player.dynStats("lus", 10 + (player.cor / 10) + (player.lib / 10));
			combatRoundOver();
		}
		
		override public function defeated(hpVictory:Boolean):void {
			SceneLib.volcanicCrag.behemothScene.winAgainstBehemoth();
		}
		
		override public function won(hpVictory:Boolean, pcCameWorms:Boolean):void {
			if (pcCameWorms){
				outputText("\n\nYour opponent doesn't seem to care.");
				doNext(SceneLib.combat.endLustLoss);
			} else {
				SceneLib.volcanicCrag.behemothScene.loseToBehemoth();
			}
		}
		
		public function Behemoth() 
		{
			this.a = "the ";
			this.short = "Behemoth";
			this.imageName = "behemoth";
			this.long = "The behemoth before you stands nine feet tall and is obviously a male.  His face is fairly cat-like and long horns protrude from his head, pointing forward.  His hair is black with blonde mane that runs across the top and back of his head and the entire length of his tail.  He's purple and muscular all over with spikes protruding from his upper back.  His cock is estimated to be eighteen inches long and 2½ inches thick when erect.  All he's wearing is a silken red loincloth tied together with gilded chains.  He doesn't appear to be wielding any form of weaponry but his claws look deadly.";
			// this.plural = false;
			this.createCock(18, 2.5, CockTypesEnum.HUMAN);
			this.balls = 2;
			this.ballSize = 3;
			this.cumMultiplier = 25;
			createBreastRow(Appearance.breastCupInverse("flat"));
			this.ass.analLooseness = AppearanceDefs.ANAL_LOOSENESS_TIGHT;
			this.ass.analWetness = AppearanceDefs.ANAL_WETNESS_NORMAL;
			this.tallness = 9*12;
			this.hipRating = AppearanceDefs.HIP_RATING_BOYISH;
			this.buttRating = AppearanceDefs.BUTT_RATING_TIGHT;
			this.skin.base.color = "purple";
			this.skin.growFur({color:"purple"});
			this.hairColor = "black";
			this.hairLength = 8;
			this.earType = AppearanceDefs.EARS_ELFIN;
			this.faceType = AppearanceDefs.FACE_CAT;
			this.horns = 7;
			this.hornType = AppearanceDefs.HORNS_DRACONIC_X2;
			this.lowerBody = AppearanceDefs.LOWER_BODY_TYPE_CAT;
			this.tailType = AppearanceDefs.TAIL_TYPE_BEHEMOTH;
			initStrTouSpeInte(180, 130, 100, 115);
			initWisLibSensCor(100, 35, 15, 15);
			this.weaponName = "claws";
			this.weaponVerb="claw";
			this.weaponAttack = 34;
			this.armorName = "loincloth";
			this.armorDef = 12;
			this.bonusHP = 900;
			this.bonusLust = 20;
			this.lust = 15;
			this.lustVuln = 0.3;
			this.temperment = TEMPERMENT_LUSTY_GRAPPLES;
			this.level = 30;
			this.gems = 70 + rand(30);
			this.drop = NO_DROP;
			this.special1 = tailWhip;
			this.special2 = tease;
			//this.special3 = aerialRave;
			checkMonster();
		}
		
	}

}
