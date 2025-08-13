///@func Blur_Screen(duration, amount)
///@desc Blurs the screen
///@param {real} duration The duration to blur
///@param {real} amount The amount to blur 
///@return {Id.Instance<blur_shader>} The created `blur_shader` object
function Blur_Screen(duration, amount)
{
	forceinline
	with (instance_create_depth(0, 0, -1000, blur_shader))
	{
		self.duration = duration;	//sets duration
		var_blur_amount = amount;	//sets blur amount
		TweenFire(self, "o", 0, false, 0, duration, "var_blur_amount>", 0);
		return self;
	}
}