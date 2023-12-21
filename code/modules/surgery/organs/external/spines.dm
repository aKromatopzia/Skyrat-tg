///A lizards spines (those things on their back), but also including tail spines (gasp)
/obj/item/organ/external/spines
	name = "lizard spines"
	desc = "Not an actual spine, obviously."
	icon_state = "spines"

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPINES

	preference = "feature_lizard_spines"
	//dna_block = DNA_SPINES_BLOCK // SKYRAT EDIT REMOVAL - Customization - We have our own system to handle DNA.
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/spines

<<<<<<< HEAD
	///A two-way reference between the tail and the spines because of wagging sprites. Bruh.
	var/obj/item/organ/external/tail/lizard/paired_tail

/obj/item/organ/external/spines/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	if(.)
		paired_tail = locate(/obj/item/organ/external/tail/lizard) in receiver.organs //We want specifically a lizard tail, so we don't use the slot.
		paired_tail?.paired_spines = src

/obj/item/organ/external/spines/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	if(paired_tail)
		paired_tail.paired_spines = null
		paired_tail = null
=======
/obj/item/organ/external/spines/Insert(mob/living/carbon/receiver, special, movement_flags)
	// If we have a tail, attempt to add a tail spines overlay
	var/obj/item/organ/external/tail/our_tail = receiver.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	our_tail?.try_insert_tail_spines(our_tail.bodypart_owner)
	return ..()

/obj/item/organ/external/spines/Remove(mob/living/carbon/organ_owner, special, movement_flags)
	// If we have a tail, remove any tail spines overlay
	var/obj/item/organ/external/tail/our_tail = organ_owner.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
	our_tail?.remove_tail_spines(our_tail.bodypart_owner)
	return ..()
>>>>>>> c340a605065 (Lizard spines no longer "float" on characters without lizard tails. (#80456))

///Bodypart overlay for spines
/datum/bodypart_overlay/mutant/spines
	layers = EXTERNAL_ADJACENT|EXTERNAL_BEHIND
	feature_key = "spines"

/datum/bodypart_overlay/mutant/spines/get_global_feature_list()
	return GLOB.sprite_accessories["spines"] // SKYRAT EDIT - Customization - ORIGINAL: return GLOB.spines_list

<<<<<<< HEAD
/datum/bodypart_overlay/mutant/spines/get_base_icon_state()
	return (wagging ? "wagging_" : "") + sprite_datum.icon_state //add the wagging tag if we be wagging


=======
>>>>>>> c340a605065 (Lizard spines no longer "float" on characters without lizard tails. (#80456))
/datum/bodypart_overlay/mutant/spines/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE
