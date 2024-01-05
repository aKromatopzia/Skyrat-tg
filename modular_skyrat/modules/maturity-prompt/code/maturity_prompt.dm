/**
 * Creates a prompt window for user's date of birth.
 */
/proc/maturity_prompt(mob/user, list/buttons = list("Submit"), timeout = (60 SECONDS), ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/maturity_prompt/prompt = new(user, timeout, ui_state)
	prompt.ui_interact(user)
	prompt.wait()
	if (prompt)
		. = prompt.choice
		qdel(alert)

/datum/maturity_prompt
	/// The title of the TGUI window
	var/title = "18+?"
	/// The textual body of the TGUI window
	var/message = "This is an 18+ community. Please declare your date of birth."

	/// Year of birth listed by the user
	var/year
	/// Month of birth listed by the user
	var/month
	/// Day of birth listed by the user
	var/day

	/// The time at which the tgui_alert was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_alert, after which the window will close and delete itself.
	var/timeout
	/// Boolean field describing if the tgui_alert was closed by the user.
	var/closed
	/// The TGUI UI state that will be returned in ui_state(). Default: always_state
	var/datum/ui_state/state

/datum/maturity_prompt/New(mob/user, timeout, ui_state)
	src.state = ui_state
	src.timeout = timeout
	start_time = world.time
	QDEL_IN(src, timeout)

/datum/maturity_prompt/Destroy(force)
	SStgui.close_uis(src)
	state = null
	return ..()

/datum/maturity_prompt/proc/wait()
	while (!closed && !QDELETED(src))
		stoplag(1)

/datum/maturity_prompt/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MaturityPrompt")
		ui.open()

/datum/maturity_prompt/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/maturity_prompt/ui_state(mob/user)
	return state

/datum/maturity_prompt/ui_static_data(mob/user)
	var/list/data = list()
	data["title"] = title
	return data

/datum/maturity_prompt/ui_data(mob/user)
	var/list/data = list()
	if(timeout)
		data["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))
	return data

/datum/maturity_prompt/ui_act(action, list/params)
	. = ..()
	if (.)
		return
	if(action == "submit")
		// validate
		log_admin("[params["year"]]-[params["month"]]-[params["day"]]")
		closed = TRUE
		SStgui.close_uis(src)
		return TRUE


/datum/tgui_alert/proc/set_choice(choice)
	src.choice = choice
