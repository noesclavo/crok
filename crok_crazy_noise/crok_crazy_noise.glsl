uniform float adsk_time;
uniform float adsk_result_w, adsk_result_h;
uniform float Speed;
uniform float Offset;
uniform float Contrast;
uniform float Steps;
uniform float Resolution_X;
uniform float Resolution_Y;
uniform float Morph;
uniform float Zoom;
uniform float Detail;
uniform float Density;

uniform sampler2D Source;

vec2 iResolution = vec2(adsk_result_w, adsk_result_h);
float iGlobalTime = adsk_time*.004;

// created by ztri


float time = 0.0;
	 
vec3 rotate(vec3 r, float v){ return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v));}

float noise( in vec3 x )
{
	float  z = x.z*Morph;
	vec2 offz = vec2(0.437,0.123);
	vec2 offt = vec2(time*0.001,time*-0.005);
	vec2 uv1 = x.xy + offz*floor(z) + offt; 
	vec2 uv2 = uv1  + offz;
	return mix(texture2D( Source, uv1 ,-100.0).x,texture2D( Source, uv2 ,-100.0).x,fract(z))-0.5;
}

float noises( in vec3 p){
	float a = 0.0;
	p.y *= Resolution_Y;
	for(float i=1.0;i<Steps;i++){
		a += noise(p)/i;
		p = p*Resolution_X + vec3(i*a*0.1,a*0.1,a*0.0);
	}
	return a;
}

void main(void)
{	
    time        = iGlobalTime*Speed+Offset;
    vec2 uv     = gl_FragCoord.xy/(iResolution.xx*0.5)-vec2(1.0,iResolution.y/iResolution.x);
    vec3 cam    = vec3(time*0.5,cos(time*0.2)*10.0,0.0);
    vec3 ray   = rotate(normalize(vec3(uv.x,uv.y,0.5).xyz),sin(time*0.3));
    vec3 pos    = cam+ray*-Zoom; 
        	
    float test  = 0.0;
    float dist   = 0.0;
    for(int i=0;i<20;i++){
        test = noises(pos*Density*.05)*Detail-0.2; 
        pos += ray*test;
		dist += test;
    }
	
	gl_FragColor = vec4(sqrt(vec3(1.0,1.0,0.95)+ray.y*0.3+(sin(pos*0.1)*0.03)-abs(dist*Contrast*.03)-dot(uv,uv)*0.3),1.0);
}