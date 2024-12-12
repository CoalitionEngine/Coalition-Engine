event_inherited();
//Sets shader bloom, you may remove this
bloomIntensity = shader_get_uniform(shd_Bloom, "intensity");
bloomblurSize = shader_get_uniform(shd_Bloom, "blurSize");
//Sets interactibility
Interactable = true;