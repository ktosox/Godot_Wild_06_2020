shader_type canvas_item;	
	
render_mode blend_mix;	
uniform vec4 modulate : hint_color;	
	
void fragment() {	
	COLOR = texture(TEXTURE, UV);
	if(COLOR.r<0.2 ){COLOR = vec4(modulate.rgb, texture(TEXTURE, UV).a * modulate.a);}
}	