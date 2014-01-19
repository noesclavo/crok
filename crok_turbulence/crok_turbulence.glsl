uniform float adsk_time;
uniform float adsk_result_w, adsk_result_h;
uniform float Speed;
uniform float Offset;
uniform float Zoom;
uniform int Detail;
uniform vec2 Position;
uniform vec3 Colour;

float time = adsk_time*.05 * Speed + Offset+50. ;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);

// water turbulence effect by joltz0r 2013-07-04, improved 2013-07-07


void main( void ) {
	vec2 sp = gl_FragCoord.xy / resolution;
	vec2 p = sp*Zoom - Position;
	vec2 i = p;
	float c = 1.0;
	float inten = .05;

	for (int n = 0; n < Detail; n++) 
	{
		float t = time/5. * (1.0 - (3.0 / float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (2.*sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
	}
	c /= float(Detail);
	c = 1.5-sqrt(pow(c,3.*0.5));
	gl_FragColor = vec4(vec3(c*c*c*c*Colour.r,c*c*c*c*Colour.g,c*c*c*c*Colour.b), 1.0);

}