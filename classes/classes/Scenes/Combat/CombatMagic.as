/**
 * Coded by aimozg on 30.05.2017.
 */
package classes.Scenes.Combat {
import classes.GlobalFlags.kACHIEVEMENTS;
import classes.GlobalFlags.kFLAGS;
import classes.IMutations.*;
import classes.Items.Dynamic.Effects.SimpleRaceEnchantment;
import classes.Items.EnchantmentLib;
import classes.Items.JewelryLib;
import classes.Items.NecklaceLib;
import classes.PerkLib;
import classes.Races;
import classes.Scenes.Dungeons.D3.Lethice;
import classes.Scenes.NPCs.Forgefather;
import classes.Scenes.Places.TelAdre.UmasShop;
import classes.Scenes.SceneLib;
import classes.StatusEffectType;
import classes.StatusEffects;

public class CombatMagic extends BaseCombatContent {
	public function CombatMagic() {}

	internal function applyAutocast():void {
		outputText("\n\n");
		if (!player.hasPerk(PerkLib.HexKnowledge) || (player.hasPerk(PerkLib.HexKnowledge) && player.hasPerk(PerkLib.HyperCasting))) {
			if (player.hasPerk(PerkLib.Spellsword) && CombatAbilities.ChargeWeapon.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_CHARGE_WEAPON_DISABLED] == 0) {
				CombatAbilities.ChargeWeapon.autocast();
			}
			if (player.hasPerk(PerkLib.Spellbow) && CombatAbilities.ChargeRWeapon.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_CHARGE_R_WEAPON_DISABLED] == 0) {
				CombatAbilities.ChargeRWeapon.autocast();
			}
			if (player.hasPerk(PerkLib.Spellarmor) && CombatAbilities.ChargeArmor.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_CHARGE_ARMOR_DISABLED] == 0) {
				CombatAbilities.ChargeArmor.autocast();
			}
		}
		if (!player.hasPerk(PerkLib.DivineKnowledge) || (player.hasPerk(PerkLib.DivineKnowledge) && player.hasPerk(PerkLib.HyperCasting))) {
			if (player.hasPerk(PerkLib.Battlemage) && CombatAbilities.Might.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_MIGHT_DISABLED] == 0) {
				CombatAbilities.Might.autocast();
			}
			if (player.hasPerk(PerkLib.Battleflash) && CombatAbilities.Blink.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_BLINK_DISABLED] == 0) {
				CombatAbilities.Blink.autocast();
			}
		}
		if (player.hasPerk(PerkLib.Battleshield) && CombatAbilities.ManaShield.isKnownAndUsable && flags[kFLAGS.AUTO_CAST_MANA_SHIELD_DISABLED] == 0) {
			CombatAbilities.ManaShield.autocast();
		}
	}

	internal function cleanupAfterCombatImpl():void {
		if (player.hasStatusEffect(StatusEffects.CounterRagingInferno)) player.removeStatusEffect(StatusEffects.CounterRagingInferno);
		if (player.hasStatusEffect(StatusEffects.CounterGlacialStorm)) player.removeStatusEffect(StatusEffects.CounterGlacialStorm);
		if (player.hasStatusEffect(StatusEffects.CounterHighVoltage)) player.removeStatusEffect(StatusEffects.CounterHighVoltage);
		if (player.hasStatusEffect(StatusEffects.CounterEclipsingShadow)) player.removeStatusEffect(StatusEffects.CounterEclipsingShadow);
		if (player.hasStatusEffect(StatusEffects.CounterHighTide)) player.removeStatusEffect(StatusEffects.CounterHighTide);
	}

	internal function costChange_all():Number {
		var costPercent:Number = 0;
		costPercent += 100*player.spellcostStat.value;
        if (player.hasPerk(PerkLib.SeersInsight)) costPercent -= (100 * player.perkv1(PerkLib.SeersInsight));
		if (player.hasPerk(PerkLib.SpellcastingAffinity)) costPercent -= player.perkv1(PerkLib.SpellcastingAffinity);
		if (player.hasPerk(PerkLib.WarMageNovice)) costPercent -= 10;
		if (player.hasPerk(PerkLib.WarMageApprentice)) costPercent -= 10;
		if (player.hasPerk(PerkLib.WarMageAdept)) costPercent -= 10;
		if (player.hasPerk(PerkLib.WarMageExpert)) costPercent -= 15;
		if (player.hasPerk(PerkLib.WarMageMaster)) costPercent -= 20;
		if (player.hasPerk(PerkLib.HyperCasting)) costPercent -= 20;
		if (player.headjewelryName == "fox hairpin") costPercent -= 20;
        if (player.weapon == weapons.N_STAFF) costPercent += 200;
		if (player.weapon == weapons.U_STAFF) costPercent -= 50;
		if (player.weapon == weapons.ASCENSU) costPercent -= 25;
        return costPercent;
    }

    internal function costChange_spell():Number {
		var costPercent:Number = 0;
        if (player.level >= 27 && player.inte >= 100) costPercent += 50;
		if (player.level >= 54 && player.inte >= 200) costPercent += 50;
		if (player.level >= 78 && player.inte >= 300) costPercent += 50;
		if (player.level >= 126 && player.inte >= 400) costPercent += 50;
        return costPercent;
    }

    internal function costChange_heal():Number {
		var costPercent:Number = 0;
        if (player.hasPerk(PerkLib.WisenedHealer)) {
			costPercent += 100;
			if (player.level >= 27 && player.wis >= 100) costPercent += 25;
			if (player.level >= 54 && player.wis >= 200) costPercent += 25;
			if (player.level >= 78 && player.wis >= 300) costPercent += 25;
			if (player.level >= 126 && player.wis >= 400) costPercent += 25;
		}
		if (player.level >= 27 && player.inte >= 100) costPercent += 25;
		if (player.level >= 54 && player.inte >= 200) costPercent += 25;
		if (player.level >= 78 && player.inte >= 300) costPercent += 25;
		if (player.level >= 126 && player.inte >= 400) costPercent += 25;
		if (player.hasPerk(PerkLib.NaturalHealingMinor)) costPercent -= 10;
		if (player.hasPerk(PerkLib.NaturalHealingMajor)) costPercent -= 15;
		if (player.hasPerk(PerkLib.NaturalHealingEpic)) costPercent -= 20;
		if (player.hasPerk(PerkLib.NaturalHealingLegendary)) costPercent -= 25;
        return costPercent;
    }

	internal function spellCostImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell();
		//Addiditive mods
		if (spellModImpl() > 1) costPercent += Math.round(spellModImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		//Limiting it and multiplicative mods
		if (player.hasPerk(PerkLib.BloodMage) && costPercent < 50) costPercent = 50;
		mod *= costPercent / 100;
		if (player.hasPerk(PerkLib.BloodMage) && mod < 5) mod = 5;
		else if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}
	
	internal function spellCostBloodImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell();
		//Addiditive mods
		if (player.hasPerk(PerkLib.HiddenJobBloodDemon)) costPercent -= 5;
		if (player.hasPerk(PerkLib.WayOfTheBlood)) costPercent -= 5;
		if (player.hasPerk(PerkLib.BloodDemonToughness)) costPercent -= 5;
		if (player.hasPerk(PerkLib.MyBloodForBloodPuppies)) costPercent -= 5;
		if (player.hasPerk(PerkLib.YourPainMyPower)) costPercent -= 5;
		if (player.hasPerk(PerkLib.BloodDemonIntelligence)) costPercent -= 5;
		//
		//
		if (player.hasPerk(PerkLib.BloodDemonWisdom)) costPercent -= 5;
		//
		if (spellModImpl() > 1) costPercent += Math.round(spellModImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		//Limiting it and multiplicative mods
		if (costPercent < 5) costPercent = 5;
		mod *= costPercent / 100;
		if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

    internal function costChange_white():Number {
		var costPercent:Number = 0;
        if (player.hasPerk(PerkLib.Ambition)) costPercent -= (100 * player.perkv2(PerkLib.Ambition));
		if (player.weapon == weapons.PURITAS) costPercent -= 15;
        return costPercent;
    }

	internal function spellCostWhiteImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell() + costChange_white();
		//Addiditive mods
		if (spellModWhiteImpl() > 1) costPercent += Math.round(spellModWhiteImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		//Limiting it and multiplicative mods
		if (player.hasPerk(PerkLib.BloodMage) && costPercent < 50) costPercent = 50;
		mod *= costPercent / 100;
		if (player.hasPerk(PerkLib.BloodMage) && mod < 5) mod = 5;
		else if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

    internal function costChange_black():Number {
		var costPercent:Number = 0;
        if (player.hasPerk(PerkLib.Obsession)) costPercent -= (100 * player.perkv2(PerkLib.Obsession));
		if (player.hasPerk(PerkLib.Necromancy)) costPercent -= 50;
		if (player.weapon == weapons.DEPRAVA) costPercent -= 15;
        return costPercent;
    }

	internal function spellCostBlackImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell() + costChange_black();
		//Addiditive mods
		if (spellModBlackImpl() > 1) costPercent += Math.round(spellModBlackImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		//Limiting it and multiplicative mods
		if (player.hasPerk(PerkLib.BloodMage) && costPercent < 50) costPercent = 50;
		mod *= costPercent / 100;
		if (player.hasPerk(PerkLib.BloodMage) && mod < 5) mod = 5;
		else if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

    internal function costChange_grey():Number {
		var costPercent:Number = 0;
		if (player.hasPerk(PerkLib.GrandGreyArchmage2ndCircle)) costPercent -= 20;
        return costPercent;
    }

	internal function spellCostGreyImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell() + costChange_grey();
		//Addiditive mods
		if (spellModGreyImpl() > 1) costPercent += Math.round(spellModGreyImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= player.perkv1(PerkLib.AscensionMysticality);
		//Limiting it and multiplicative mods
		if (player.hasPerk(PerkLib.BloodMage) && costPercent < 50) costPercent = 50;
		mod *= costPercent / 100;
		if (player.hasPerk(PerkLib.BloodMage) && mod < 5) mod = 5;
		else if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function spellCostGreenImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_spell() + costChange_white();
		//Addiditive mods
		if (spellModGreenImpl() > 1) costPercent += Math.round(spellModGreenImpl() - 1) * 10;
		//Limiting it and multiplicative mods
		if (player.hasPerk(PerkLib.BloodMage) && costPercent < 50) costPercent = 50;
		mod *= costPercent / 100;
		if (player.hasPerk(PerkLib.BloodMage) && mod < 5) mod = 5;
		else if (mod < 2) mod = 2;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

    internal function modChange_all():Number {
		var mod:Number = player.spellpowerStat.value - 1; // spellpower stat starts with 1
        if (player.jewelryEffectId == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.jewelryEffectId2 == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.jewelryEffectId3 == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.jewelryEffectId4 == JewelryLib.MODIFIER_SPELL_POWER) mod += (player.jewelryEffectMagnitude / 100);
		if (player.necklaceEffectId == NecklaceLib.MODIFIER_SPELL_POWER) mod += (player.necklaceEffectMagnitude / 100);
		if (player.armor == armors.DWARMOR) mod += 0.3;
		if (player.hasAetherTwinsTierWeapon()) mod += 0.2;
		if (player.hasAetherTwinsTierShield()) mod += 0.5;
		if (player.countCockSocks("blue") > 0) mod += (player.countCockSocks("blue") * .05);
        if (player.hasPerk(PerkLib.ChiReflowMagic)) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
		// hope it doesn't lag too much
		for each (var e:SimpleRaceEnchantment in player.allEnchantments(EnchantmentLib.RaceSpellPowerBonus)) {
			mod += 0.02 * e.power * player.racialTier(e.race);
		}
		for each (var f:SimpleRaceEnchantment in player.allEnchantments(EnchantmentLib.RaceSpellPowerDoubled)) {
			mod += f.power * (player.isRaceCached(f.race)? 2:1);
		}
        return mod;
    }

    internal function modChange_spell_1():Number {
		var mod:Number = 0;
		if (player.hasPerk(PerkLib.Archmage) && player.inte >= 100) mod += .3;
		if (player.hasPerk(PerkLib.ArchmageEx) && player.inte >= 100) mod += 1.05;
		if (player.hasPerk(PerkLib.Channeling) && player.inte >= 60) mod += .2;
		if (player.hasPerk(PerkLib.GrandArchmage) && player.inte >= 125) mod += .4;
		if (player.hasPerk(PerkLib.GrandArchmage2ndCircle) && player.inte >= 150) mod += .5;
		if (player.hasPerk(PerkLib.GrandArchmage3rdCircle) && player.inte >= 175) mod += .6;
		if (player.hasPerk(PerkLib.GrandMage) && player.inte >= 75) mod += .2;
		if (player.hasPerk(PerkLib.JobSorcerer) && player.inte >= 25) mod += .1;
		if (player.hasPerk(PerkLib.Mage) && player.inte >= 50) mod += .1;
		if (player.hasPerk(PerkLib.Spellpower) && player.inte >= 50) mod += .1;
		if (player.hasPerk(PerkLib.TraditionalMageI) && ((player.isUsingStaff() || player.isPartiallyStaffTypeWeapon() || player.isUsingWand()) && player.isUsingTome())) {
			var tmb:Number = 1;
			if (player.hasPerk(PerkLib.TraditionalMageII)) tmb += 1;
			if (player.hasPerk(PerkLib.TraditionalMageIII)) tmb += 1;
			if (player.hasPerk(PerkLib.TraditionalMageIV)) tmb += 1;
			if (player.hasPerk(PerkLib.TraditionalMageV)) tmb += 1;
			if (player.hasPerk(PerkLib.TraditionalMageVI)) tmb += 1;
			if (player.isPartiallyStaffTypeWeapon()) tmb *= 0.5;
			mod += tmb;
		}
        if (player.hasPerk(PerkLib.Ambition)) {
			mod += player.perkv2(PerkLib.Ambition);
		}
		if (player.hasPerk(PerkLib.KnowledgeIsPower)) {
			if (player.perkv1(IMutationsLib.RatatoskrSmartsIM) >= 3) mod += (Math.round(camp.codex.checkUnlocked() / 100) * 3);
			else mod += Math.round(camp.codex.checkUnlocked() / 100);
		}
		if (player.hasPerk(PerkLib.ZenjisInfluence3)) mod += .3;
		if (player.hasPerk(PerkLib.ChiReflowMagic)) mod += UmasShop.NEEDLEWORK_MAGIC_SPELL_MULTI;
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) mod += (player.cor * .01);
		if (player.hasPerk(PerkLib.InariBlessedKimono)) mod += ((100 - player.cor) * .01);
        return mod;
    }

    internal function modChange_spell_2():Number {
		var mod:Number = 0;
		if (player.hasPerk(PerkLib.SeersInsight)) mod += player.perkv1(PerkLib.SeersInsight);
		if (player.headJewelry == headjewelries.SPHINXAS) mod += .5;
        if (player.hasStatusEffect(StatusEffects.Maleficium)) {
			if (player.perkv1(IMutationsLib.ObsidianHeartIM) >= 2) {
				if (player.perkv1(IMutationsLib.ObsidianHeartIM) >= 3) mod += 2.5;
				else mod += 1.25;
			} else mod += 1;
		}
        if (player.hasStatusEffect(StatusEffects.PerfectClarity)) {
			if (player.perkv1(IMutationsLib.DiamondHeartIM) >= 2) {
				if (player.perkv1(IMutationsLib.DiamondHeartIM) >= 3) mod += 2.5;
				else mod += 1.25;
			} else mod += 1;
		}
		if (player.hasPerk(PerkLib.ElementalBody)) {
			if (player.perkv1(PerkLib.ElementalBody) == 1 || player.perkv1(PerkLib.ElementalBody) == 2 || player.perkv1(PerkLib.ElementalBody) == 3) {
				if (player.perkv2(PerkLib.ElementalBody) == 1) mod += .05;
				if (player.perkv2(PerkLib.ElementalBody) == 2) mod += .1;
				if (player.perkv2(PerkLib.ElementalBody) == 3) mod += .15;
				if (player.perkv2(PerkLib.ElementalBody) == 4) mod += .2;
			}
			else {
				if (player.perkv2(PerkLib.ElementalBody) == 1) mod += .1;
				if (player.perkv2(PerkLib.ElementalBody) == 2) mod += .2;
				if (player.perkv2(PerkLib.ElementalBody) == 3) mod += .3;
				if (player.perkv2(PerkLib.ElementalBody) == 4) mod += .4;
			}
			if (player.hasPerk(PerkLib.SharedPower) && player.perkv1(PerkLib.SharedPower) > 0) mod += (0.1*player.perkv1(PerkLib.SharedPower));
		}
        return mod;
    }

    internal function modChange_heal():Number {
		var mod:Number = 0;
        if (player.hasPerk(PerkLib.SpellpowerHealing) && player.wis >= 50) mod += .2;
		if (player.hasPerk(PerkLib.NaturalHealingMinor)) mod += .3;
		if (player.hasPerk(PerkLib.NaturalHealingMajor)) mod += .4;
		if (player.hasPerk(PerkLib.NaturalHealingEpic)) mod += .5;
		if (player.hasPerk(PerkLib.NaturalHealingLegendary)) mod += .6;
		return mod;
    }

	internal function spellModImpl():Number {
		var mod:Number = 1 + modChange_all() + modChange_spell_1() + modChange_spell_2();
		if (player.hasPerk(PerkLib.Obsession)) mod += player.perkv1(PerkLib.Obsession);
		if (player.hasPerk(PerkLib.KnowledgeIsPower)) {
			if (player.perkv1(IMutationsLib.RatatoskrSmartsIM) >= 3) mod += (Math.round(camp.codex.checkUnlocked() / 100) * 3);
			else mod += Math.round(camp.codex.checkUnlocked() / 100);
		}
		if (player.hasPerk(PerkLib.ZenjisInfluence3)) mod += .3;
		if (player.headJewelry == headjewelries.DMONSKUL) mod += player.cor * .006;
		if (player.isGargoyle() && Forgefather.material == "alabaster") {
			if (Forgefather.refinement == 0) mod += (.15);
			if (Forgefather.refinement == 1) mod += (.25);
			if (Forgefather.refinement == 2 || Forgefather.refinement == 3) mod += (.5);
			if (Forgefather.refinement == 4) mod += (1);
		}
		if (player.hasPerk(PerkLib.AscensionMysticality)) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.weapon == weapons.ASCENSU) mod *= 6.5;
		if (player.hasStatusEffect(StatusEffects.DarkRitual)) mod *= 3;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}
	
	internal function spellModBloodImpl():Number {
        var mod:Number = 1;
		if (spellModImpl() > 1) mod += (spellModImpl() - 1);
		if (player.hasPerk(PerkLib.HiddenJobBloodDemon)) mod += .1;
		if (player.hasPerk(PerkLib.WayOfTheBlood)) mod += .15;
		if (player.hasPerk(PerkLib.BloodDemonToughness)) mod += .2;
		if (player.hasPerk(PerkLib.MyBloodForBloodPuppies)) mod += .25;
		if (player.hasPerk(PerkLib.YourPainMyPower)) mod += .3;
		if (player.hasPerk(PerkLib.BloodDemonIntelligence)) mod += .35;
        //
		//
		if (player.hasPerk(PerkLib.BloodDemonWisdom)) mod += .5;
		//
		mod = Math.round(mod * 100) / 100;
		return mod;
	}
	
	internal function spellModGreyImpl():Number {
		var mod:Number = 1;
		if (spellModImpl() > 1) mod += (spellModImpl() - 1);
		if (player.hasPerk(PerkLib.SpellpowerGrey) && player.inte >= 50) mod += .15;
		if (player.hasPerk(PerkLib.GreyMageApprentice) && player.inte >= 75) mod += .1;
		if (player.hasPerk(PerkLib.GreyMage) && player.inte >= 125) mod += .2;
		if (player.hasPerk(PerkLib.GreyArchmage) && player.inte >= 175) mod += .3;
		if (player.hasPerk(PerkLib.GrandGreyArchmage) && player.inte >= 225) mod += .4;
		if (player.hasPerk(PerkLib.GrandGreyArchmage2ndCircle) && player.inte >= 275) mod += .5;
		return mod;
	}

	internal function spellModWhiteImpl():Number {
		var mod:Number = 1;
		if (spellModImpl() > 1) mod += (spellModImpl() - 1);
		if (player.hasStatusEffect(StatusEffects.BlessingOfDivineMarae)) {
			mod += player.statusEffectv2(StatusEffects.BlessingOfDivineMarae);
		}
		if (player.hasPerk(PerkLib.AvatorOfPurity)) mod += .2;
		if (Forgefather.purePearlEaten) mod +=.25;
		if (player.hasPerk(PerkLib.UnicornBlessing) && player.cor <= 20) mod += .2;
		if (player.hasPerk(PerkLib.PrestigeJobArchpriest)) mod += .2;
		if (player.hasPerk(PerkLib.PrestigeJobWarlock)) mod -= .4;
		if (player.hasKeyItem("Holy Symbol") >= 0) mod += .2;
		if (player.necklace == necklaces.LEAFAMU) {
			if (player.isElf()) mod += .2;
			else mod += .1;
		}
		if (player.weapon == weapons.PURITAS) mod *= 2.5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function spellModBlackImpl():Number {
		var mod:Number = 1;
		if (spellModImpl() > 1) mod += (spellModImpl() - 1);
		if (player.hasPerk(PerkLib.AvatorOfCorruption)) mod += .3;
		if (Forgefather.lethiciteEaten) mod +=.25;
		if (player.hasPerk(PerkLib.BicornBlessing) && player.cor >= 80) mod += .2;
		if (player.hasPerk(PerkLib.PrestigeJobArchpriest)) mod -= .4;
		if (player.hasPerk(PerkLib.PrestigeJobWarlock)) mod += .2;
		if (player.countMiscJewelry(miscjewelries.DMAGETO) > 0) mod += 0.25;
		if (player.weapon == weapons.DEPRAVA) mod *= 2.5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function spellModGreenImpl():Number {
		var mod:Number = 1;
		if (spellModWhiteImpl() > 1) mod += (spellModWhiteImpl() - 1);
		if (player.hasPerk(PerkLib.OneWiththeForest) && player.perkv2(PerkLib.OneWiththeForest) > 0) mod += (0.05 * player.perkv2(PerkLib.OneWiththeForest));
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healCostImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_heal();
		//Addiditive mods
		if (healModImpl() > 1) costPercent += Math.round(healModImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		mod *= costPercent / 100;
		if (mod < 5) mod = 5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healCostWhiteImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_heal() + costChange_white();
		//Addiditive mods
		if (healModWhiteImpl() > 1) costPercent += Math.round(healModWhiteImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		mod *= costPercent / 100;
		if (mod < 5) mod = 5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healCostBlackImpl(mod:Number):Number {
		var costPercent:Number = 100 + costChange_all() + costChange_heal() + costChange_black();
		//Addiditive mods
		if (healModBlackImpl() > 1) costPercent += Math.round(healModBlackImpl() - 1) * 10;
		if (player.hasPerk(PerkLib.AscensionMysticality)) costPercent -= (player.perkv1(PerkLib.AscensionMysticality) * 2);
		mod *= costPercent / 100;
		if (mod < 5) mod = 5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healModImpl():Number {
		var mod:Number = 1 + modChange_all() + modChange_heal();
		if (player.hasPerk(PerkLib.Obsession)) mod += player.perkv1(PerkLib.Obsession);
		if (player.hasPerk(PerkLib.Ambition)) mod += player.perkv1(PerkLib.Ambition);
		if (player.hasPerk(PerkLib.TamamoNoMaeCursedKimono)) mod += (player.cor * .01);
		if (player.hasPerk(PerkLib.SeersInsight)) mod += player.perkv1(PerkLib.SeersInsight);
		if (player.hasPerk(PerkLib.InariBlessedKimono)) mod += ((100 - player.cor) * .01);
		if (player.hasPerk(PerkLib.AscensionMysticality)) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.weapon == weapons.ASCENSU) mod *= 6.5;
		if (player.weapon == weapons.ECLIPSE) mod *= 0.2;
		if (player.weapon == weapons.OCCULUS) mod *= 5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healModWhiteImpl():Number {
		var mod:Number = 1;
		if (healModImpl() > 1) mod += (healModImpl() - 1);
		if (player.hasPerk(PerkLib.Ambition)) mod += player.perkv2(PerkLib.Ambition);
		if (player.hasStatusEffect(StatusEffects.BlessingOfDivineMarae)) mod += player.statusEffectv2(StatusEffects.BlessingOfDivineMarae);
		if (player.hasPerk(PerkLib.AvatorOfPurity)) mod += .3;
		if (player.hasPerk(PerkLib.UnicornBlessing) && player.cor <= 20) mod += .2;
		if (player.hasKeyItem("Holy Symbol") >= 0) mod += .2;
		if (player.hasPerk(PerkLib.SeersInsight)) mod += player.perkv1(PerkLib.SeersInsight);
		if (player.hasPerk(PerkLib.AscensionMysticality)) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.weapon == weapons.PURITAS) mod *= 2.5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function healModBlackImpl():Number {
		var mod:Number = 1;
		if (healModImpl() > 1) mod += (healModImpl() - 1);
		if (player.hasPerk(PerkLib.Obsession)) mod += player.perkv2(PerkLib.Obsession);
		if (player.hasPerk(PerkLib.AvatorOfCorruption)) mod += .3;
		if (player.hasPerk(PerkLib.BicornBlessing) && player.cor >= 80) mod += .2;
		if (player.hasPerk(PerkLib.SeersInsight)) mod += player.perkv1(PerkLib.SeersInsight);
		if (player.hasPerk(PerkLib.AscensionMysticality)) mod *= 1 + (player.perkv1(PerkLib.AscensionMysticality) * 0.1);
		if (player.weapon == weapons.DEPRAVA) mod *= 2.5;
		mod = Math.round(mod * 100) / 100;
		return mod;
	}

	internal function spellGreyCooldownImpl():Number {
		var mod:Number = 3;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 1;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellGreyTier2CooldownImpl():Number {
		var mod:Number = 6;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 2;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellWhiteCooldownImpl():Number {
		var mod:Number = 3;
		if (player.hasPerk(PerkLib.AvatorOfPurity)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 1;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellWhiteTier2CooldownImpl():Number {
		var mod:Number = 6;
		if (player.hasPerk(PerkLib.AvatorOfPurity)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 2;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellWhiteTier3CooldownImpl():Number {
		var mod:Number = 12;
		if (player.hasPerk(PerkLib.AvatorOfPurity)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 4;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellBlackCooldownImpl():Number {
		var mod:Number = 3;
		if (player.hasPerk(PerkLib.AvatorOfCorruption)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.Necromancy)) mod -= 1;
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 1;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellBlackTier2CooldownImpl():Number {
		var mod:Number = 6;
		if (player.hasPerk(PerkLib.AvatorOfCorruption)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.Necromancy)) mod -= 1;
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 2;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellBlackTier3CooldownImpl():Number {
		var mod:Number = 12;
		if (player.hasPerk(PerkLib.AvatorOfCorruption)) mod -= 1;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.Necromancy)) mod -= 1;
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 4;
		if (mod < 0) mod = 0;
		return mod;
	}

	internal function spellGenericCooldownImpl():Number {
		var mod:Number = 3;
		if (player.hasPerk(PerkLib.NaturalSpellcasting)) {
			if (player.necklace == necklaces.LEAFAMU && player.isElf()) mod -= 2;
			else mod -= 1;
		}
		if (player.hasPerk(PerkLib.HyperCasting)) mod -= 1;
		return mod;
	}

	public function getBlackMagicMinLust():Number {
		if (player.hasPerk(PerkLib.GreyMage)) return 30;
		return 50;
	}

	public function getWhiteMagicLustCap():Number {
		var whiteLustCap:int = player.maxLust() * 0.75;
		if (player.hasPerk(PerkLib.Enlightened) && player.cor < (10 + player.corruptionTolerance)) whiteLustCap += (player.maxLust() * 0.1);
		if (player.hasPerk(PerkLib.FocusedMind) && !player.hasPerk(PerkLib.GreyMage)) whiteLustCap += (player.maxLust() * 0.1);
		if (player.hasPerk(PerkLib.GreyMage)) {
			if (player.hasPerk(PerkLib.Enlightened) && player.cor < (10 + player.corruptionTolerance)) whiteLustCap = (player.maxLust() - 15);
			else whiteLustCap = (player.maxLust() - 45);
		}
		return whiteLustCap;
	}

	private function omnicasterMutliForReflectDmgAndAchievments():Number {
		return AbstractSpell.omnicasterRepeatCount();
	}
	
	public function perkRelatedDurationBoosting():Number {
		var perkRelatedDB:Number = 0;
		if (player.hasPerk(PerkLib.LongerLastingBuffsI)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.LongerLastingBuffsII)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.LongerLastingBuffsIII)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.LongerLastingBuffsIV)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.LongerLastingBuffsV)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.LongerLastingBuffsVI)) perkRelatedDB += 1;
		if (player.hasPerk(PerkLib.EverLastingBuffs)) perkRelatedDB += 5;
		if (player.hasPerk(PerkLib.EternalyLastingBuffs)) perkRelatedDB += 5;
		return perkRelatedDB;
	}

	internal function calcInfernoModImpl(damage:Number, casting:Boolean = true):int {
        var modDmg:Number = damage;
        //v1 is counter value in 5% (for later tiers),
		if (player.hasPerk(PerkLib.RagingInferno)) { //if has perk
            if (casting) {
                if (player.hasStatusEffect(StatusEffects.CounterRagingInferno)) { //counter created
					var cap:Number = 40;
					if (player.hasPerk(PerkLib.RagingInfernoEx)) cap += 80;
					if (player.hasPerk(PerkLib.RagingInfernoSu)) cap += 480;
                    //calculating damage
                    if (player.statusEffectv1(StatusEffects.CounterRagingInferno) > 0)
                        modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterRagingInferno) * 0.05));
                    //fancy messages
                    if (player.statusEffectv1(StatusEffects.CounterRagingInferno) == 0)
                        outputText("\nUnfortunately, traces of your previously used fire magic are too weak to be used.\n\n");
                    else
					    outputText("\nTraces of your previously used fire magic are still here, and you use them to empower another spell!\n\n");
                    //increasing counters
					var increase:Number = 8;
					if (player.hasPerk(PerkLib.RagingInfernoEx)) increase += 4;
					if (player.statusEffectv1(StatusEffects.CounterRagingInferno) < cap) {
						player.addStatusValue(StatusEffects.CounterRagingInferno, 1, increase);
						player.addStatusValue(StatusEffects.CounterRagingInferno, 2, 1);
					}
                }
                else {
                    if (player.hasPerk(PerkLib.RagingInfernoEx))
                        player.createStatusEffect(StatusEffects.CounterRagingInferno,12,1,0,0);
                    else
                        player.createStatusEffect(StatusEffects.CounterRagingInferno,8,1,0,0);
                }
            }
            else //just calc damage
                if (player.hasStatusEffect(StatusEffects.CounterRagingInferno) && player.statusEffectv1(StatusEffects.CounterRagingInferno) > 0)
                    modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterRagingInferno) * 0.05));
        }
		return modDmg;
	}

    internal function calcGlacialModImpl(damage:Number, casting:Boolean = true):int {
        var modDmg:Number = damage;
        //v1 is counter value in 5% (for later tiers),
		if (player.hasPerk(PerkLib.GlacialStorm)) { //if has perk
            if (casting) {
                if (player.hasStatusEffect(StatusEffects.CounterGlacialStorm)) { //counter created
                    var cap:Number = 40;
					if (player.hasPerk(PerkLib.GlacialStormEx)) cap += 80;
					if (player.hasPerk(PerkLib.GlacialStormSu)) cap += 480;
                    //calculating damage
                    if (player.statusEffectv1(StatusEffects.CounterGlacialStorm) > 0)
                        modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterGlacialStorm) * 0.05));
                    //fancy messages
                    if (player.statusEffectv1(StatusEffects.CounterGlacialStorm) == 0)
                        outputText("\nUnfortunately, traces of your previously used ice magic are too weak to be used.\n\n");
                    else
					    outputText("\nTraces of your previously used ice magic are still here, and you use them to empower another spell!\n\n");
                    //increasing counters
					var increase:Number = 8;
					if (player.hasPerk(PerkLib.GlacialStormEx)) increase += 4;
					if (player.statusEffectv1(StatusEffects.CounterGlacialStorm) < cap) {
						player.addStatusValue(StatusEffects.CounterGlacialStorm, 1, increase);
						player.addStatusValue(StatusEffects.CounterGlacialStorm, 2, 1);
					}
                }
                else {
                    if (player.hasPerk(PerkLib.GlacialStormEx))
                        player.createStatusEffect(StatusEffects.CounterGlacialStorm,12,1,0,0);
                    else
                        player.createStatusEffect(StatusEffects.CounterGlacialStorm,8,1,0,0);
                }
            }
            else //just calc damage
                if (player.hasStatusEffect(StatusEffects.CounterGlacialStorm) && player.statusEffectv1(StatusEffects.CounterGlacialStorm) > 0)
                    modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterGlacialStorm) * 0.05));
        }
		return modDmg;
	}

    internal function calcVoltageModImpl(damage:Number, casting:Boolean = true):int {
        var modDmg:Number = damage;
        //v1 is counter value in 5% (for later tiers),
		if (player.hasPerk(PerkLib.HighVoltage)) { //if has perk
            if (casting) {
                if (player.hasStatusEffect(StatusEffects.CounterHighVoltage)) { //counter created
                    var cap:Number = 40;
					if (player.hasPerk(PerkLib.HighVoltageEx)) cap += 80;
					if (player.hasPerk(PerkLib.HighVoltageSu)) cap += 480;
                    //calculating damage
                    if (player.statusEffectv1(StatusEffects.CounterHighVoltage) > 0)
                        modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterHighVoltage) * 0.05));
                    if (player.statusEffectv1(StatusEffects.CounterHighVoltage) == 0)
                    //fancy messages
                        outputText("\nUnfortunately, traces of your previously used lightning magic are too weak to be used.\n\n");
                    else
					    outputText("\nTraces of your previously used lightning magic are still here, and you use them to empower another spell!\n\n");
                    //increasing counters
					var increase:Number = 8;
					if (player.hasPerk(PerkLib.HighVoltageEx)) increase += 4;
					if (player.statusEffectv1(StatusEffects.CounterHighVoltage) < cap) {
						if (player.hasPerk(PerkLib.HighVoltageEx))
						player.addStatusValue(StatusEffects.CounterHighVoltage, 1, increase);
						player.addStatusValue(StatusEffects.CounterHighVoltage, 2, 1);
					}
                }
                else {
                    if (player.hasPerk(PerkLib.HighVoltageEx))
                        player.createStatusEffect(StatusEffects.CounterHighVoltage,12,1,0,0);
                    else
                        player.createStatusEffect(StatusEffects.CounterHighVoltage,4,1,0,0);
                }
            }
            else //just calc damage
                if (player.hasStatusEffect(StatusEffects.CounterHighVoltage) && player.statusEffectv1(StatusEffects.CounterHighVoltage) > 0)
                    modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterHighVoltage) * 0.05));
        }
		return modDmg;
	}

    internal function calcEclypseModImpl(damage:Number, casting:Boolean = true):int {
        var modDmg:Number = damage;
        //v1 is counter value in 5% (for later tiers),
		if (player.hasPerk(PerkLib.EclipsingShadow)) { //if has perk
            if (casting) {
                if (player.hasStatusEffect(StatusEffects.CounterEclipsingShadow)) { //counter created
                    var cap:Number = 40;
					if (player.hasPerk(PerkLib.EclipsingShadowEx)) cap += 80;
					if (player.hasPerk(PerkLib.EclipsingShadowSu)) cap += 480;
                    //calculating damage
                    if (player.statusEffectv1(StatusEffects.CounterEclipsingShadow) > 0)
                        modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterEclipsingShadow) * 0.05));
                    //fancy messages
                    if (player.statusEffectv1(StatusEffects.CounterEclipsingShadow) == 0)
                        outputText("\nUnfortunately, traces of your previously used darkness magic are too weak to be used.\n\n");
                    else
					    outputText("\nTraces of your previously used darkness magic are still here, and you use them to empower another spell!\n\n");
                    //increasing counters
					var increase:Number = 8;
					if (player.hasPerk(PerkLib.EclipsingShadowEx)) increase += 4;
					if (player.statusEffectv1(StatusEffects.CounterEclipsingShadow) < cap) {
						player.addStatusValue(StatusEffects.CounterEclipsingShadow, 1, increase);
						player.addStatusValue(StatusEffects.CounterEclipsingShadow, 2, 1);
					}
                }
                else {
                    if (player.hasPerk(PerkLib.EclipsingShadowEx))
                        player.createStatusEffect(StatusEffects.CounterEclipsingShadow,12,1,0,0);
                    else
                        player.createStatusEffect(StatusEffects.CounterEclipsingShadow,8,1,0,0);
                }
            }
            else //just calc damage
                if (player.hasStatusEffect(StatusEffects.CounterEclipsingShadow) && player.statusEffectv1(StatusEffects.CounterEclipsingShadow) > 0)
                    modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterEclipsingShadow) * 0.05));
        }
		return modDmg;
    }

    internal function calcTideModImpl(damage:Number, casting:Boolean = true):int {
        var modDmg:Number = damage;
        //v1 is counter value in 5% (for later tiers),
		if (player.hasPerk(PerkLib.HighTide)) { //if has perk
            if (casting) {
                if (player.hasStatusEffect(StatusEffects.CounterHighTide)) { //counter created
                    var cap:Number = 40;
					if (player.hasPerk(PerkLib.HighTideEx)) cap += 80;
					if (player.hasPerk(PerkLib.HighTideSu)) cap += 480;
                    //calculating damage
                    if (player.statusEffectv1(StatusEffects.CounterHighTide) > 0)
                        modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterHighTide) * 0.05));
                    //fancy messages
                    if (player.statusEffectv1(StatusEffects.CounterHighTide) == 0)
                        outputText("\nUnfortunately, traces of your previously used water magic are too weak to be used.\n\n");
                    else
					    outputText("\nTraces of your previously used water magic are still here, and you use them to empower another spell!\n\n");
                    //increasing counters
					var increase:Number = 8;
					if (player.hasPerk(PerkLib.HighTideEx)) increase += 4;
					if (player.statusEffectv1(StatusEffects.CounterHighTide) < cap) {
						player.addStatusValue(StatusEffects.CounterHighTide, 1, increase);
						player.addStatusValue(StatusEffects.CounterHighTide, 2, 1);
					}
                }
                else {
                    if (player.hasPerk(PerkLib.HighTideEx))
                        player.createStatusEffect(StatusEffects.CounterHighTide,12,1,0,0);
                    else
                        player.createStatusEffect(StatusEffects.CounterHighTide,8,1,0,0);
                }
            }
            else //just calc damage
                if (player.hasStatusEffect(StatusEffects.CounterHighTide) && player.statusEffectv1(StatusEffects.CounterHighTide) > 0)
                    modDmg = Math.round(damage * (1 + player.statusEffectv1(StatusEffects.CounterHighTide) * 0.05));
        }
		return modDmg;
    }
	
	public function MagicPrefixEffect():void {
		//if (player.hasPerk(PerkLib.Spellsong) && player.hasStatusEffect(StatusEffects.Sing)) {
		//	outputText(" You weave your song into magic to unleash a spell.\n\n");
		//}
		if (player.armorName == "Drider-Weave Sheer Robe") {
			outputText("As your mana flows through your body, culminating in your hands, your sheer robe glows, giving [themonster] a good, long look at you.\n\n");
			if (player.gender == 2 || (player.gender == 3 && rand(2) == 0)) {
				outputText("You lean forward, moving your [breasts] from side to side. As your mana focuses, you roll your shoulders back and your hips forward, giving the [themonster] a little moan, biting your lip, your arms behind your back. Their gaze drops to your snatch, but as they gaze at your delta, you finish your spell, robes turning back to normal. ");
			}
			else {
				outputText("You spread your hands, letting mana flow through you. Your robe all but vanishes, and you thrust your hips forward, [cock] hardening slightly, your bulge standing up straight and tenting the sheer silk. Giving your enemy a cocky grin, you lick your lips, giving them a few thrusts of your hips. ");
				outputText("[Themonster], stunned by the sudden change in your bearing and…manhood, gives you more than enough time to finish your spell. ");
			}
			if (player.perkv1(PerkLib.ImpNobility) > 0) {
				outputText("  Your imp cohorts assist you spellcasting adding their diagrams to your own.");
			}
			var damage:Number = 0;
			var damagemultiplier:Number = 1;
			damage += combat.teases.teaseBaseLustDamage();
			if (player.hasPerk(PerkLib.HistoryWhore) || player.hasPerk(PerkLib.PastLifeWhore)) damagemultiplier += combat.historyWhoreBonus();
			if (player.hasPerk(PerkLib.DazzlingDisplay) && rand(100) < 10) damagemultiplier += 0.2;
			if (player.headjewelryName == "pair of Golden Naga Hairpins") damagemultiplier += 0.1;
			if (player.hasPerk(PerkLib.UnbreakableBind)) damagemultiplier += 1;
			if (player.hasStatusEffect(StatusEffects.ControlFreak)) damagemultiplier += (2 - player.statusEffectv1(StatusEffects.ControlFreak));
			if (player.hasPerk(PerkLib.Sadomasochism)) damage *= player.sadomasochismBoost();
			damage *= damagemultiplier;
			//Determine if critical tease!
			var crit:Boolean = false;
			var critChance:int = 5;
			if (player.hasPerk(PerkLib.CriticalPerformance)) {
				if (player.lib <= 100) critChance += player.lib / 5;
				if (player.lib > 100) critChance += 20;
			}
			if (rand(100) < critChance) {
				crit = true;
				damage *= 1.75;
			}
			if (monster.hasStatusEffect(StatusEffects.HypnosisNaga)) damage *= 0.5;
			if (player.hasPerk(PerkLib.RacialParagon)) damage *= combat.RacialParagonAbilityBoost();
			if (player.armor == armors.ELFDRES && player.isElf()) damage *= 2;
        	if (player.armor == armors.FMDRESS && player.isWoodElf()) damage *= 2;
			if (player.hasPerk(PerkLib.FueledByDesire) && player.lust100 >= 50 && flags[kFLAGS.COMBAT_TEASE_HEALING] == 0) {
				outputText("\nYou use your own lust against the enemy, cooling off a bit in the process.");
				player.takeLustDamage(Math.round(-damage)/40, true);
				damage *= 1.2;
			}
			monster.teased(Math.round(monster.lustVuln * damage));
			if (crit) outputText(" <b>Critical!</b>");
			SceneLib.combat.teaseXP(1 + SceneLib.combat.bonusExpAfterSuccesfullTease());
			outputText("\n\n");
		}
	}

	//THIS FEATURE GOVERNS EVERY POST CAST EFFECT YOUR SPELLS MAY CAUSE
	public function MagicAddonEffect(numberOfProcs:Number = 1):void {
		if (player.hasStatusEffect(StatusEffects.Venomancy)) {
			if (player.tailVenom >= player.VenomWebCost()) {
				var injections:Number = 0;
				if (player.hasPerk(PerkLib.ArcaneVenom)) numberOfProcs *= AbstractSpell.stackingArcaneVenom();
				while (player.tailVenom >= player.VenomWebCost() && injections < numberOfProcs) {
					var damageB:Number = 35 + rand(player.lib / 10);
					var poisonScaling:Number = 1;
					var dam4Bab:Number = 1;
					if (player.hasPerk(PerkLib.ImprovedVenomGlandSu)) dam4Bab *= 2;
					poisonScaling += player.lib/100;
					poisonScaling += player.tou/100;
					if (player.level < 10) damageB += 20 + (player.level * 3);
					else if (player.level < 20) damageB += 50 + (player.level - 10) * 2;
					else if (player.level < 30) damageB += 70 + (player.level - 20) * 1;
					else damageB += 80;
					damageB *= 0.04;
					damageB *= dam4Bab;
					poisonScaling *= dam4Bab;
					damageB *= 1+(poisonScaling/10);
					monster.teased(Math.round(monster.lustVuln * damageB), false);
					monster.statStore.addBuffObject({tou:-poisonScaling}, "Poison",{text:"Poison"});
					var venomType:StatusEffectType = StatusEffects.NagaVenom;
					if (player.racialScore(Races.NAGA) >= 23) venomType = StatusEffects.ApophisVenom;
					if (monster.hasStatusEffect(venomType)) {
							monster.addStatusValue(venomType, 3, 1);
					} else monster.createStatusEffect(venomType, 0, 0, 1, 0);
					if (player.hasPerk(PerkLib.WoundPoison)){
						if (monster.hasStatusEffect(StatusEffects.WoundPoison)) monster.addStatusValue(StatusEffects.WoundPoison, 1, 10);
						else monster.createStatusEffect(StatusEffects.WoundPoison, 10,0,0,0);
					}
					player.tailVenom -= player.VenomWebCost();
					flags[kFLAGS.VENOM_TIMES_USED] += 0.2;
					injections++;
				}
				outputText(" Your venom is forcefully injected ");
				if (injections > 1) outputText(""+injections+" times");
				outputText(" in [themonster] through your magic!");
			}
		}
		if (player.hasStatusEffect(StatusEffects.BalanceOfLife)) HPChange((player.maxHP() * numberOfProcs * 0.05), false);
	}

	public function spellMagicBolt():void {
		spellMagicBolt2(false, false);
	}
	public function spellElementalBolt():void {
		spellMagicBolt2(true, false);
	}
	public function spellEdgyMagicBolt():void {
		spellMagicBolt2(false, true);
	}
	public function spellEdgyElementalBolt():void {
		spellMagicBolt2(true, true);
	}
	public function spellMagicBolt2(elemental:Boolean = false, edgy:Boolean = false):void {
		useMana(elemental ? 80 : 40, Combat.USEMANA_MAGIC);
		if (edgy) player.wrath -= 100;
		flags[kFLAGS.LAST_ATTACK_TYPE] = 2;
		clearOutput();
		combat.darkRitualCheckDamage();
		if (handleShell()) return;
		outputText("You narrow your eyes, focusing your mind with deadly intent.  ");
		if (player.hasPerk(PerkLib.StaffChanneling) && player.weaponSpecials("Staff")) outputText("You point your staff and shoot a magic bolt toward [themonster]!\n\n");
		else outputText("You point your hand toward [themonster] and shoot a magic bolt!\n\n");
		var damage:Number = scalingBonusIntelligence() * spellMod() * 1.2;
		if (damage < 10) damage = 10;
		//weapon bonus
		if (player.hasPerk(PerkLib.StaffChanneling) && player.weaponSpecials("Staff")) {
			if (player.weaponAttack < 51) damage *= (1 + (player.weaponAttack * 0.04));
			else if (player.weaponAttack >= 51 && player.weaponAttack < 101) damage *= (3 + ((player.weaponAttack - 50) * 0.035));
			else if (player.weaponAttack >= 101 && player.weaponAttack < 151) damage *= (4.75 + ((player.weaponAttack - 100) * 0.03));
			else if (player.weaponAttack >= 151 && player.weaponAttack < 201) damage *= (6.25 + ((player.weaponAttack - 150) * 0.025));
			else damage *= (7.5 + ((player.weaponAttack - 200) * 0.02));
		}
		if (player.hasPerk(PerkLib.ElementalBolt)) damage *= 1.25;
		if (player.armorName == "FrancescaCloak") damage *= 2;
		if (edgy) damage *= 2;
		//Determine if critical hit!
		var crit:Boolean = false;
		var critChance:int = 5;
		critChance += combatMagicalCritical();
		if (monster.isImmuneToCrits() && !player.hasPerk(PerkLib.EnableCriticals)) critChance = 0;
		if (rand(100) < critChance) {
			crit = true;
			damage *= 1.75;
		}
		damage = Math.round(damage);
		outputText(monster.capitalA + monster.short + " takes ");
		doMagicDamage(damage, true, true);
		outputText(" damage.");
		if (crit) outputText(" <b>*Critical Hit!*</b>");
		MagicAddonEffect();
		outputText("\n\n");
		checkAchievementDamage(damage);
		if (edgy) awardAchievement("Edgy Caster", kACHIEVEMENTS.COMBAT_EDGY_CASTER);
		flags[kFLAGS.SPELLS_CAST]++;
		if(!player.hasStatusEffect(StatusEffects.CastedSpell)) player.createStatusEffect(StatusEffects.CastedSpell,0,0,0,0);
		spellPerkUnlock();
		combat.heroBaneProc(damage);
		statScreenRefresh();
		if (player.hasPerk(PerkLib.ElementalBolt)) {
			if (player.hasStatusEffect(StatusEffects.CounterHighTide)) {
				if (player.hasPerk(PerkLib.HighTideSu)) player.addStatusValue(StatusEffects.CounterHighTide, 1, 2);
				else if (player.hasPerk(PerkLib.HighTideEx)) player.addStatusValue(StatusEffects.CounterHighTide, 1, 3);
				player.addStatusValue(StatusEffects.CounterHighTide, 1, 4);
			}
			if (player.hasStatusEffect(StatusEffects.CounterEclipsingShadow)) {
				if (player.hasPerk(PerkLib.EclipsingShadowSu)) player.addStatusValue(StatusEffects.CounterEclipsingShadow, 1, 2);
				else if (player.hasPerk(PerkLib.EclipsingShadowEx)) player.addStatusValue(StatusEffects.CounterEclipsingShadow, 1, 3);
				player.addStatusValue(StatusEffects.CounterEclipsingShadow, 1, 4);
			}
			if (player.hasStatusEffect(StatusEffects.CounterGlacialStorm)) {
				if (player.hasPerk(PerkLib.GlacialStormSu)) player.addStatusValue(StatusEffects.CounterGlacialStorm, 1, 2);
				else if (player.hasPerk(PerkLib.GlacialStormEx)) player.addStatusValue(StatusEffects.CounterGlacialStorm, 1, 3);
				player.addStatusValue(StatusEffects.CounterGlacialStorm, 1, 4);
			}
			if (player.hasStatusEffect(StatusEffects.CounterHighVoltage)) {
				if (player.hasPerk(PerkLib.HighVoltageSu)) player.addStatusValue(StatusEffects.CounterHighVoltage, 1, 2);
				else if (player.hasPerk(PerkLib.HighVoltageEx)) player.addStatusValue(StatusEffects.CounterHighVoltage, 1, 3);
				player.addStatusValue(StatusEffects.CounterHighVoltage, 1, 4);
			}
			if (player.hasStatusEffect(StatusEffects.CounterRagingInferno)) {
				if (player.hasPerk(PerkLib.RagingInfernoSu)) player.addStatusValue(StatusEffects.CounterRagingInferno, 1, 2);
				else if (player.hasPerk(PerkLib.RagingInfernoEx)) player.addStatusValue(StatusEffects.CounterRagingInferno, 1, 3);
				player.addStatusValue(StatusEffects.CounterRagingInferno, 1, 4);
			}
		}
		if(monster.HP <= monster.minHP()) doNext(endHpVictory);
		else
		{
			if (monster is Lethice && (monster as Lethice).fightPhase == 3)
			{
				outputText("\n\n<i>\"Ouch. Such arcane skills for one so uncouth,\"</i> Lethice growls. With a snap of her fingers, a pearlescent dome surrounds her. <i>\"How will you beat me without your magics?\"</i>\n\n");
				monster.createStatusEffect(StatusEffects.Shell, 2, 0, 0, 0);
			}
			enemyAI();
		}
	}
	
	public function spellGreenCovenantOff():void {
		clearOutput();
		outputText("Information Noona Warning:\n\n<b>Your Green Covenant is deactivated now.</b>");
		player.removeStatusEffect(StatusEffects.GreenCovenant);
		enemyAI();
	}

	private function handleShell():Boolean{
        if(monster.hasStatusEffect(StatusEffects.Shell)) {
            outputText("As soon as your magic touches the multicolored shell around [themonster], it sizzles and fades to nothing.  Whatever that thing is, it completely blocks your magic!\n\n");
            flags[kFLAGS.SPELLS_CAST]++;
            if(!player.hasStatusEffect(StatusEffects.CastedSpell)) player.createStatusEffect(StatusEffects.CastedSpell,0,0,0,0);
            spellPerkUnlock();
            enemyAI();
            return true;
        }
		return false;
	}
}
}
