package classes.Scenes.Combat.SpellsGreen {
import classes.Monster;
import classes.PerkLib;
import classes.Scenes.Combat.AbstractGreenSpell;
import classes.StatusEffects;

public class BriarthornSpell extends AbstractGreenSpell {
	public function BriarthornSpell() {
		super("Briarthorn",
			"While entangling, vines grows sharp thorns that rend the opponent's flesh and deliver a deadly poison that rend vitality. This spell also Inflict heavy bleed and poison damage.",
			TARGET_ENEMY,
			TIMING_INSTANT,
			[TAG_LUSTDMG]);
		baseManaCost = 20;
	}
	
	override public function get isKnown():Boolean {
		return player.hasStatusEffect(StatusEffects.KnowsBriarthorn);
	}
	
	override public function describeEffectVs(target:Monster):String {
		return "~" + calcDamage(target, false, false) + " lust poison damage and bleeding DoT"
	}
	
	override public function calcCooldown():int {
		return spellWhiteCooldown();
	}
	
	override public function isActive():Boolean {
		return monster.hasStatusEffect(StatusEffects.Briarthorn);
	}
	
	override protected function usabilityCheck():String {
		var uc:String = super.usabilityCheck();
		if (uc) return uc;
		
		if (!monster.hasStatusEffect(StatusEffects.Entangled)) {
			return "Briarthorn require to have enemy/ies entangled by the vines.";
		}
		
		return "";
	}
	
	override public function advance(display:Boolean):void {
		if (player.hasStatusEffect(StatusEffects.Briarthorn)) {
			if (player.statusEffectv1(StatusEffects.Briarthorn) <= 0) {
				player.removeStatusEffect(StatusEffects.Briarthorn);
				if (display) outputText("<b>Briarthorn effect wore off!</b>\n\n");
			} else {
				player.addStatusValue(StatusEffects.Briarthorn, 1, -1);
			}
		}
	}
	
	public function calcDamage(monster:Monster, randomize:Boolean = true, casting:Boolean = true):Number { //casting - Increase Elemental Counter while casting (like Raging Inferno)
		var baseDamage:Number = (combat.teases.teaseBaseLustDamage() * 3 * spellModGreen());
		if (player.hasPerk(PerkLib.VegetalAffinity)) baseDamage *= 1.5;
		if (player.hasPerk(PerkLib.GreenMagic)) baseDamage *= 2;
		if (player.hasStatusEffect(StatusEffects.GreenCovenant)) baseDamage *= 2;
		return adjustLustDamage(baseDamage, monster, CAT_SPELL_GREEN, randomize);
	}
	
	override protected function doSpellEffect(display:Boolean = true):void {
		if (display) {
			outputText("You concentrate on the vines causing them to grow vicious thorns that tear through your opponent's flesh delivering a noxious poison.");
			if (monster.lustVuln == 0) {
				if (display) {
					outputText("\nIt has no effect!  Your foe clearly does not experience lust in the same way as you.\n");
				}
				return;
			}
			monster.createStatusEffect(StatusEffects.Briarthorn, 6, 0, 0, 0);
			var arve:Number = 1;
			if (player.hasPerk(PerkLib.ArcaneVenom)) arve += stackingArcaneVenom();
			while (arve-->0) doSpellEffect2();
			outputText("\n");
		}
	}
	
	private function doSpellEffect2():void {
		var lustDmg:Number = calcDamage(monster, true, true);
		//Determine if critical tease!
		var crit:Boolean   = false;
		var critChance:int = 5;
		if (player.hasPerk(PerkLib.CriticalPerformance)) {
			if (player.lib <= 100) critChance += player.lib / 5;
			if (player.lib > 100) critChance += 20;
		}
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance = 0;
		if (rand(100) < critChance) {
			crit = true;
			lustDmg *= 1.75;
		}
		lustDmg = Math.round(monster.lustVuln * lustDmg);
		monster.teased(lustDmg, false);
		if (crit) outputText(" <b>Critical!</b>");
		combat.teaseXP(1 + combat.bonusExpAfterSuccesfullTease());
		if (player.hasPerk(PerkLib.VerdantLeech)) {
			if (monster.lustVuln != 0 && !monster.hasPerk(PerkLib.EnemyTrueAngel)) monster.lustVuln += 0.025;
			HPChange(Math.round(player.maxHP() * 0.05), false);
		}
	}
}
}
