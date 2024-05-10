timer++;

if timer <= induration
{
	global.sur_list[| TEMPID][1] = EaseOutQuad(timer, 0, displace, induration);
	global.sur_list[| TEMPID + 1][1] = EaseOutQuad(timer, 0, displace, induration);
}
if timer >= induration + duration
{
	global.sur_list[| TEMPID][1] = EaseOutQuad(timer - induration - duration, displace, -displace, endduration);
	global.sur_list[| TEMPID + 1][1] = EaseOutQuad(timer - induration - duration, displace, -displace, endduration);
}
if timer >= induration + duration + endduration ins_dest id;
