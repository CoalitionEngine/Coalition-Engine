/**
	Sets the x and y position of the board
	@param {real} x					The x position
	@param {real} y					The y position
	@param {real,array,struct} time	The time taken for the anim
	@param {function,string} ease	The easing
	@param {Asset.GMObject} target	The target board to se the size to
*/
function Board_SetPos(xx = 320, yy = 320, time = {dist: 10}, ease = "oQuad", board = undefined) {
	forceinline
	Board.SetPos(xx, yy, time, ease, board);
}