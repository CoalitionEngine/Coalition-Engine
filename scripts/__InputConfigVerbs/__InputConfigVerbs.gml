function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        UP,
        DOWN,
        LEFT,
        RIGHT,
        CONFIRM,
        CANCEL,
		MENU,
		PAUSE,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    InputDefineVerb(INPUT_VERB.UP,      "up",         [vk_up,      "W"],);
    InputDefineVerb(INPUT_VERB.DOWN,    "down",       [vk_down,    "S"],);
    InputDefineVerb(INPUT_VERB.LEFT,    "left",       [vk_left,    "A"],);
    InputDefineVerb(INPUT_VERB.RIGHT,   "right",      [vk_right,   "D"],);
    InputDefineVerb(INPUT_VERB.CONFIRM, "confirm",    [vk_enter,   "Z"],);
    InputDefineVerb(INPUT_VERB.CANCEL,  "cancel",     [vk_shift,   "X"],);
    InputDefineVerb(INPUT_VERB.MENU,    "menu",       [vk_control, "C"],);
    InputDefineVerb(INPUT_VERB.PAUSE, "pause", vk_escape,);
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}
