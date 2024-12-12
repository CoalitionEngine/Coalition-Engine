///Resets the board state to default
///@param {bool} angle_div	Whether the angle of the board be fixed between -90 < x < 90 or not
function Board_Reset(anglediv = true) {
	forceinline
	Board.SetSize();
	if anglediv oBoard.image_angle %= 90;
	Board.SetAngle();
	Board.SetPos();
}