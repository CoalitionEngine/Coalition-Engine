var i = 0, writer, n = array_length(TextWriterList);
repeat n
{
	writer = TextWriterList[i];
	writer.draw(TextPosition[i][0], TextPosition[i][1], TextTypistList[i]);
	++i;
}