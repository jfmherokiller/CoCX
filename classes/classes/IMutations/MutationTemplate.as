/**
 * Original code by aimozg on 27.01.14.
 * Reworked for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
    import classes.PerkClass;
    import classes.PerkType;

    public class MutationTemplate extends PerkType
    {
        //v1 contains the mutation tier
        override public function desc(params:PerkClass = null):String {
            var descS:String = "";
            var pTier:int = player.perkv1(IMutationsLib.MutationsTemplateIM)
            if (pTier >= 1){
                descS += "";
            }
            if (pTier >= 2){
                descS += "";
            }
            if (pTier >= 3){
                descS += "";
            }
            if (descS != "")descS += ".";
            return descS;
        }
        //Name. Need it say more?
        override public function name(params:PerkClass=null):String {
            var sufval:String;
            switch (player.perkv1(IMutationsLib.MutationsTemplateIM)){
                case 2:
                    sufval = "(Primitive)";
                    break;
                case 3:
                    sufval = "(Evolved)";
                    break;
                default:
                    sufval = "";
            }
            return "PerkName Here" + sufval;
        }
        //returns max Perk Tier of specific perk
        public static function perkTier():int{
            return 3;
        }
        //Mutation Requirements
        public static function mutationReqs():void{
            var pTier:int = player.perkv1(IMutationsLib.MutationsTemplateIM);
            if (pTier == 0){
                IMutationsLib.MutationsTemplateIM.requireAdaptationsMutationSlot();
            }
            else{
                IMutationsLib.MutationsTemplateIM.requireLevel(30 * pTier)
                        /*.requireCustomFunction(function (player:Player):Boolean {
                            return player.perkv1(IMutationsLib.MutationsTemplateIM) == pTier;
                        }, "Previous perk tier required.");*/
            }
        }

        public function MutationTemplate() {
            super("PerkName Here", "PerkName Here", ".");
        }

        override public function keepOnAscension(respec:Boolean = false):Boolean {
            return true;
        }
    }
}