event_inherited();
//Sets shader bloom, you may remove this
__bloomIntensity = shader_get_uniform(shd_Bloom, "intensity");
__bloomblurSize = shader_get_uniform(shd_Bloom, "blurSize");
//Sets interactibility
Interactable = true;