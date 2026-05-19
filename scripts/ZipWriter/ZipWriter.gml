/*
	Modified from YaL's pre 2023.6 zip functions for legacy compatibility,
	converting the zipping system into native GM is low priority for now.
*/


// Feather disable all
__mq_zip_std_Date=[undefined,undefined];__zip_std_haxe_type_markerValue=[];__mt_zip_std_Date=new zip_std_haxe_class(7,"zip_std_Date");__mt_zip_std_haxe_class=new zip_std_haxe_class(-1,"zip_std_haxe_class");
#macro mq_zip_std_Date global.__mq_zip_std_Date
#macro zip_std_haxe_type_markerValue global.__zip_std_haxe_type_markerValue
#macro mt_zip_std_Date global.__mt_zip_std_Date
#macro mt_zip_std_haxe_class global.__mt_zip_std_haxe_class

/// legacy_zip_create(compressionLevel)
/// @desc (LEGACY) Creates a buffer for the zip file
/// @param {int} compressionLevel=-1
/// @returns {zip}
function legacy_zip_create(_compressionLevel=-1){
	var _this = array_create(4);
	_this[0]=buffer_create(128,buffer_grow,1);
	_this[1]=ds_list_create();
	_this[2]=true;
	_this[3]=_compressionLevel;
	return _this;
}
/// zip_impl_write(_dst,_src,_srcPos,_srcLen)
function zip_impl_write(_dst,_src,_srcPos,_srcLen){
	var _dstPos=buffer_tell(_dst),
		_dstNext=_dstPos+_srcLen,
		_dstSize=buffer_get_size(_dst);
	if(_dstNext>_dstSize){
		do _dstSize*=2;
		until(_dstNext<=_dstSize);
		buffer_resize(_dst,_dstSize);
	}
	buffer_copy(_src,_srcPos,_srcLen,_dst,_dstPos);
	buffer_seek(_dst,buffer_seek_start,_dstNext);
}

/// zip_destroy(this:zip)
/// @desc Removes the zip cache from memory
/// @param {zip} this
function zip_destroy(_this){
	buffer_delete(_this[0]);
	_this[0]=-1;
	ds_list_destroy(_this[1]);
	_this[1]=-1;
	_this[2]=false;
}

/// zip_add_buffer_ext(this,path,buf,pos,len,compressionLevel)
/// @desc Writes buffer data to the zip file
/// @param {zip} this
/// @param {string} path
/// @param {buffer} buf
/// @param {int} pos
/// @param {int} len
/// @param {int} compressionLevel
function zip_add_buffer_ext(_this,_path,_buf,_pos,_len,_compressionLevel=_this[3]){
	if(!_this[2])show_error("Zip writer is already finalized.",true);
	var _compress=_compressionLevel!=0;
	var _o=_this[0];
	buffer_write(_o,buffer_s32,67324752);
	buffer_write(_o,buffer_u16,20);
	buffer_write(_o,buffer_u16,2048);
	buffer_write(_o,buffer_u16,_compress?8:0);
	//Current time
	var _time=[mt_zip_std_Date];
	array_copy(_time,1,mq_zip_std_Date,1,1);
	_time[1]=date_current_datetime();
	buffer_write(_o,buffer_u16,((date_get_hour(_time[1])<<11)|(date_get_minute(_time[1])<<5))|(date_get_second(_time[1])>>1));
	buffer_write(_o,buffer_u16,((date_get_year(_time[1])-1980<<9)|(date_get_month(_time[1])-1+1<<5))|date_get_weekday(_time[1]));
	var _crc=buffer_crc32(_buf,_pos,_len)^0xFFFFFFFF;
	var _cbuf=undefined;
	var _clen=_len;
	if(_compress){
		_cbuf=buffer_compress(_buf,_pos,_len);
		_clen=buffer_get_size(_cbuf)-6;
	}
	buffer_write(_o,buffer_u32,_crc);
	buffer_write(_o,buffer_s32,_clen);
	buffer_write(_o,buffer_s32,_len);
	buffer_write(_o,buffer_u16,string_byte_length(_path));
	buffer_write(_o,buffer_u16,0);
	buffer_write(_o,buffer_text,_path);
	var _file=[_path,_compress,_clen,_len,_crc,_time];
	if(_compress){
		zip_impl_write(_o,_cbuf,2,_clen);
		buffer_delete(_cbuf);
	} else zip_impl_write(_o,_buf,_pos,_len);
	ds_list_add(_this[1],_file);
}

/// zip_add_buffer(this,path,buf,compressionLevel)
/// Writes buffer data to the zip file
/// @param {zip} this
/// @param {string} path
/// @param {buffer} buf
/// @param {int} compressionLevel=-1
function zip_add_buffer(_this,_path,_buf,_compressionLevel=-1){
	zip_add_buffer_ext(_this,_path,_buf,0,buffer_get_size(_buf),_compressionLevel);
}

/// legacy_zip_add_file(this,path,filePath,compressionLevel)
/// (LEGACY) Writes data from a file to the zip file
/// @param {zip} this
/// @param {string} path
/// @param {string} filePath
/// @param {int} compressionLevel
function legacy_zip_add_file(_this,_path,_filePath,_compressionLevel=-1){
	var _buf=buffer_load(_filePath);
	zip_add_buffer_ext(_this,_path,_buf,0,buffer_get_size(_buf),_compressionLevel);
	buffer_delete(_buf);
}

/// zip_finalize(this)
/// @desc Wrap up the formatting for the zip file
function zip_finalize(_this){
	_this[2]=false;
	var _o=_this[0];
	var _cdr_size=0;
	var _cdr_offset=0;
	var __g_list=_this[1];
	var __g_index=0;
	while(__g_index<ds_list_size(__g_list)){
		var _f=__g_list[|__g_index++];
		var _namelen=string_byte_length(_f[0]);
		var _extraFieldsLength=0;
		buffer_write(_o,buffer_s32,33639248);
		buffer_write(_o,buffer_u16,20);
		buffer_write(_o,buffer_u16,20);
		buffer_write(_o,buffer_u16,2048);
		buffer_write(_o,buffer_u16,(_f[1]?8:0));
		var _d=_f[5];
		buffer_write(_o,buffer_u16,(((date_get_hour(_d[1])<<11)|(date_get_minute(_d[1])<<5))|(date_get_second(_d[1])>>1)));
		buffer_write(_o,buffer_u16,(((date_get_year(_d[1])-1980<<9)|(date_get_month(_d[1])-1+1<<5))|date_get_weekday(_d[1])));
		buffer_write(_o,buffer_u32,_f[4]);
		buffer_write(_o,buffer_s32,_f[2]);
		buffer_write(_o,buffer_s32,_f[3]);
		buffer_write(_o,buffer_u16,_namelen);
		buffer_write(_o,buffer_u16,_extraFieldsLength);
		buffer_write(_o,buffer_u16,0);
		buffer_write(_o,buffer_u16,0);
		buffer_write(_o,buffer_u16,0);
		buffer_write(_o,buffer_s32,0);
		buffer_write(_o,buffer_s32,_cdr_offset);
		buffer_write(_o,buffer_text,_f[0]);
		_cdr_size+=46+_namelen+_extraFieldsLength;
		_cdr_offset+=30+_namelen+_extraFieldsLength+_f[2];
	}
	buffer_write(_o,buffer_s32,101010256);
	buffer_write(_o,buffer_u16,0);
	buffer_write(_o,buffer_u16,0);
	buffer_write(_o,buffer_u16,ds_list_size(_this[1]));
	buffer_write(_o,buffer_u16,ds_list_size(_this[1]));
	buffer_write(_o,buffer_s32,_cdr_size);
	buffer_write(_o,buffer_s32,_cdr_offset);
	buffer_write(_o,buffer_u16,0);
}

/// legacy_zip_save(this,path)
/// @desc (LEGACY) Saves the zip file to the given path
/// @param {zip} this
/// @param {string} path
function legacy_zip_save(_this,_path){
	if(_this[2])zip_finalize(_this);
	buffer_save_ext(_this[0],_path,0,buffer_tell(_this[0]));
}

/// zip_get_buffer(this)
/// @desc Get buffer data
/// @param {zip} this
/// @returns {buffer}
function zip_get_buffer(_this){
	if(_this[2])zip_finalize(_this);
	return _this[0];
}

/// zip_std_haxe_class(id,name)
function zip_std_haxe_class(_id,_name)constructor{
	static superClass=undefined; /// @is {haxe_class<any>}
	static marker=undefined; /// @is {any}
	static index=undefined; /// @is {int}
	static name=undefined; /// @is {string}
	self.superClass=undefined;
	self.marker=zip_std_haxe_type_markerValue;
	self.index=_id;
	self.name=_name;
	static __class__="class";
}

var z = legacy_zip_create();
//
screen_save("screen.png");
legacy_zip_add_file(z, "test.png", "screen.png");
//
var b = buffer_create(32, buffer_grow, 1);
buffer_write(b, buffer_text, "All is well!");
zip_add_buffer_ext(z, "test/test.txt", b, 0, buffer_tell(b));
buffer_delete(b);
//
legacy_zip_save(z, "test.zip");
zip_destroy(z);